#!/usr/bin/env python3
import argparse, json, subprocess, hashlib, re
from pathlib import Path
from typing import Dict, Any, List, Tuple, Optional

BASE_DIR = "assets/json"
REPO_DIRS = ["lessons", "parts", "tools"]

def git_show(commit: str, path: str) -> Optional[str]:
    try:
        return subprocess.check_output(["git", "show", f"{commit}:{path}"], text=True)
    except subprocess.CalledProcessError:
        return None

def git_list_json(commit: str, subdir: str) -> List[str]:
    try:
        out = subprocess.check_output(
            ["git", "ls-tree", "-r", "--name-only", commit, f"{BASE_DIR}/{subdir}"],
            text=True
        )
        return [p for p in out.splitlines() if p.endswith(".json")]
    except subprocess.CalledProcessError:
        return []

def iter_repo_objects(doc: Dict[str, Any]) -> List[Tuple[str, Dict[str, Any], str, str]]:
    """yield (container_key, obj_dict, kind, title)"""
    out: List[Tuple[str, Dict[str, Any], str, str]] = []
    for k, v in list(doc.items()):
        if isinstance(v, list) and v and all(isinstance(x, dict) for x in v):
            kind = "unknown"
            lk = k.lower()
            if lk.startswith("lesson"): kind = "lesson"
            elif lk.startswith("tool"): kind = "tool"
            elif lk.startswith("part"): kind = "part"
            elif k in ("lessons", "tools", "parts"): kind = k[:-1]
            for o in v:
                if isinstance(o, dict) and "id" in o:
                    out.append((k, o, kind, o.get("title", "")))
    return out

def normalize_title(title: str) -> str:
    # Lowercase, strip trailing "", collapse whitespace/punctuation runs
    t = title or ""
    t = t.lower().strip()
    t = re.sub(r"-json$", "", t)
    t = re.sub(r"[^\w]+", " ", t)
    t = re.sub(r"\s+", " ", t).strip()
    return t

def stable_signature(obj: Dict[str, Any], kind: str) -> str:
    # Content-based signature ignoring `id`, tolerant to key order
    payload = {k: v for k, v in obj.items() if k != "id"}
    blob = json.dumps([kind, payload], ensure_ascii=False, sort_keys=True)
    return hashlib.sha1(blob.encode("utf-8")).hexdigest()

def load_index(commit: str):
    """Return:
       by_file_title[(file, kind, norm_title)] -> id
       by_sig[signature] -> (id, file, kind, title)
    """
    by_file_title: Dict[Tuple[str,str,str], str] = {}
    by_sig: Dict[str, Tuple[str,str,str,str]] = {}
    for sub in REPO_DIRS:
        for rel in git_list_json(commit, sub):
            text = git_show(commit, rel)
            if not text:
                continue
            try:
                doc = json.loads(text)
            except Exception:
                continue
            for _, obj, kind, title in iter_repo_objects(doc):
                oid = obj.get("id")
                norm = normalize_title(title)
                if oid:
                    by_file_title[(rel, kind, norm)] = oid
                    sig = stable_signature(obj, kind)
                    by_sig[sig] = (oid, rel, kind, title)
    return by_file_title, by_sig

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True, help="older commit (e.g. 25dc5ec)")
    ap.add_argument("--tip",  required=True, help="newer commit (e.g. 9021153)")
    ap.add_argument("--tsv",  default="migrations/reports/id_changes.tsv")
    ap.add_argument("-", default="migrations/reports/id_map.json")
    args = ap.parse_args()

    Path("migrations/reports").mkdir(parents=True, exist_ok=True)

    base_by_ft, base_by_sig = load_index(args.base)
    tip_by_ft,  tip_by_sig  = load_index(args.tip)

    rows: List[Tuple[str,str,str,str]] = []   # file, title, old_id, new_id
    id_map: Dict[str,str] = {}

    # --- Pass 1: file+kind+normalized-title exact join ---
    matched_sigs: set = set()
    used_keys: set = set()
    for (file, kind, norm), old_id in base_by_ft.items():
        new_id = tip_by_ft.get((file, kind, norm))
        if new_id and new_id != old_id:
            # recover a human title for the row (from tip signature index if present)
            # fall back: derive title from norm
            title = None
            # try to find a tip object with this id to fetch title
            for sig, (tid, f2, k2, t2) in tip_by_sig.items():
                if tid == new_id and f2 == file and k2 == kind:
                    title = t2
                    matched_sigs.add(sig)
                    break
            if not title:
                title = norm
            rows.append((file, title, old_id, new_id))
            id_map[old_id] = new_id
            used_keys.add((file, kind, norm))

    # --- Pass 2: content-signature fallback for any missed pairs ---
    for sig, (old_id, file, kind, title) in base_by_sig.items():
        if sig in matched_sigs:
            continue
        tip_hit = tip_by_sig.get(sig)
        if not tip_hit:
            continue
        new_id, file2, kind2, title2 = tip_hit
        if new_id != old_id:
            rows.append((file2, title2, old_id, new_id))
            id_map[old_id] = new_id

    # De-dup rows (just in case)
    seen = set()
    uniq_rows = []
    for r in rows:
        key = (r[0], r[2], r[3])
        if key in seen: 
            continue
        seen.add(key)
        uniq_rows.append(r)

    with open(args.tsv, "w", encoding="utf-8") as f:
        f.write("file\ttitle\told_id\tnew_id\n")
        for file, title, old_id, new_id in uniq_rows:
            f.write(f"{file}\t{title}\t{old_id}\t{new_id}\n")

    with open(args.json, "w", encoding="utf-8") as f:
        json.dump(id_map, f, ensure_ascii=False, indent=2)

    print(f"Wrote {args.tsv} ({len(uniq_rows)} changes)")
    print(f"Wrote {args.json} ({len(id_map)} mappings)")

if __name__ == "__main__":
    main()
