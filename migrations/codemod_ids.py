#!/usr/bin/env python3
import json, sys, re, hashlib, csv
from pathlib import Path
from typing import Dict, Any, List, Tuple, Set

# -----------------------------
# Config (edit if needed)
# -----------------------------
BASE_DIR = Path("assets/json")     # root of your repos
PATHS_DIR = BASE_DIR / "paths"
REPO_DIRS = [BASE_DIR / "lessons", BASE_DIR / "parts", BASE_DIR / "tools"]  # where objects live
ID_MAP_PATH = Path("migrations/id_map.json")  # default mapping path
DRY_RUN = True                     # start in dry-run; override with --write
RENAME_FLASHCARDS = True           # keep flashcard ids in sync with parent id
FLASHCARD_PREFIX = "flashcard_"    # used for detection & regeneration
CSV_LOG = Path("migrations/codemod_report.csv")  # summary output

# -----------------------------
# Helpers
# -----------------------------
ID_KEY = "id"
ITEMS_KEY = "items"       # in path chapters
CHAPTERS_KEY = "chapters" # in path files

ID_RE = re.compile(r'^(?P<stem>(lesson|part|tool)_[a-zA-Z0-9]+_)(?P<major>\d+)\.(?P<minor>\d+)$')

def load_json(p: Path) -> Any:
    with p.open("r", encoding="utf-8") as f:
        return json.load(f)

def save_json(p: Path, obj: Any) -> None:
    p.parent.mkdir(parents=True, exist_ok=True)
    with p.open("w", encoding="utf-8") as f:
        json.dump(obj, f, ensure_ascii=False, indent=2)

def iter_repo_objects(doc: Any) -> List[Tuple[str, Dict[str, Any], str]]:
    """
    Return list of (container_key, obj_dict, object_kind)
    container_key: e.g., 'lessons', 'tools', 'parts' (or any top-level array)
    object_kind:    'lesson' | 'tool' | 'part' | 'unknown'
    """
    objs = []
    for k, v in list(doc.items()):
        if isinstance(v, list) and v and all(isinstance(x, dict) for x in v):
            # Guess kind
            kind = "unknown"
            if k.lower().startswith("lesson"): kind = "lesson"
            elif k.lower().startswith("tool"): kind = "tool"
            elif k.lower().startswith("part"): kind = "part"
            elif k in ("lessons", "tools", "parts"): kind = k[:-1]  # crude, but works
            for o in v:
                if isinstance(o, dict) and ID_KEY in o:
                    objs.append((k, o, kind))
    return objs

def iter_path_item_ids(doc: Any) -> List[Tuple[Dict[str, Any], str]]:
    """Returns a list of (item_dict, item_id) for all path items."""
    out = []
    chapters = doc.get(CHAPTERS_KEY, [])
    for ch in chapters:
        for it in ch.get(ITEMS_KEY, []):
            if isinstance(it, dict) and ID_KEY in it:
                out.append((it, it[ID_KEY]))
    return out

def sha8(s: str) -> str:
    return hashlib.sha1(s.encode("utf-8")).hexdigest()[:8]

def enforce_dot00(id_str: str) -> bool:
    """Return True if (non-flashcard) id ends with .00"""
    if id_str.startswith(FLASHCARD_PREFIX):
        return True  # flashcards can be anything; we manage them separately
    return id_str.endswith(".00")

def replace_flashcard_id(old_fc_id: str, old_parent_id: str, new_parent_id: str) -> str:
    """
    If old_fc_id contains the old parent id, replace that substring with the new one.
    Otherwise, regenerate a tight-coupled id: 'flashcard_<new_parent_id>_<stable-suffix>'
    """
    if old_parent_id in old_fc_id:
        return old_fc_id.replace(old_parent_id, new_parent_id)
    suffix = sha8(old_fc_id)
    return f"{FLASHCARD_PREFIX}{new_parent_id}_{suffix}"

def collect_all_object_ids() -> Dict[str, Path]:
    """Scan repo dirs and return mapping of object_id -> file_path (for duplicate/dangling checks)."""
    seen: Dict[str, Path] = {}
    for root in REPO_DIRS:
        if not root.exists():
            continue
        for p in root.rglob("*.json"):
            try:
                doc = load_json(p)
            except Exception:
                continue
            for _, obj, _ in iter_repo_objects(doc):
                obj_id = obj.get(ID_KEY)
                if obj_id:
                    seen[obj_id] = p
    return seen

def build_used_majors_by_stem() -> Dict[str, Set[int]]:
    """
    Build a map: stem -> set(majors in use)
    stem example: 'lesson_term_'
    """
    used: Dict[str, Set[int]] = {}
    for root in REPO_DIRS:
        if not root.exists(): continue
        for p in root.rglob("*.json"):
            try:
                doc = load_json(p)
            except Exception:
                continue
            for _, obj, _ in iter_repo_objects(doc):
                oid = obj.get(ID_KEY)
                m = ID_RE.match(oid or "")
                if not m: continue
                stem = m.group("stem")
                major = int(m.group("major"))
                used.setdefault(stem, set()).add(major)
    return used

def next_free_major(stem: str, used: Dict[str, Set[int]]) -> int:
    """Find the smallest positive integer major not in use for this stem."""
    majors = used.setdefault(stem, set())
    cand = 1
    while cand in majors:
        cand += 1
    majors.add(cand)  # reserve it
    return cand

# -----------------------------
# Main codemod
# -----------------------------
def main():
    global DRY_RUN
    # CLI flags
    args = sys.argv[1:]
    AUTO = ("--auto" in args)
    if "--write" in args: DRY_RUN = False
    if "--map" in args:
        try:
            idx = args.index("--map")
            map_arg = args[idx+1]
            map_path = Path(map_arg)
            if map_path.exists():
                global ID_MAP_PATH
                ID_MAP_PATH = map_path
        except Exception:
            pass

    # 0) Build auto map if requested (or load file)
    id_map: Dict[str, str] = {}

    if AUTO:
        # Build mapping by scanning repos and assigning new *.00 ids for any with minor != 00
        used = build_used_majors_by_stem()
        for root in REPO_DIRS:
            if not root.exists(): continue
            for p in root.rglob("*.json"):
                try:
                    doc = load_json(p)
                except Exception:
                    continue
                for _, obj, _ in iter_repo_objects(doc):
                    old_id = obj.get(ID_KEY)
                    if not old_id: continue
                    m = ID_RE.match(old_id)
                    if not m: 
                        # If it's a non-flashcard but doesn't match the pattern and doesn't end with .00, flag later
                        continue
                    minor = m.group("minor")
                    stem = m.group("stem")
                    major = int(m.group("major"))
                    if minor != "00":
                        # Need a new major that is free for this stem
                        new_major = next_free_major(stem, used)
                        new_id = f"{stem}{new_major:02d}.00"
                        id_map[old_id] = new_id
                    else:
                        # Already .00 -> just reserve its major so we don't reuse it
                        used.setdefault(stem, set()).add(major)
        # Also scan PATH items to catch references whose objects may not exist yet
        for p in PATHS_DIR.rglob("*.json"):
            try:
                doc = load_json(p)
            except Exception:
                continue
            for _, item_id in iter_path_item_ids(doc):
                m = ID_RE.match(item_id or "")
                if not m: 
                    continue
                minor = m.group("minor")
                stem = m.group("stem")
                major = int(m.group("major"))
                if minor != "00":
                    # If not already mapped, allocate one
                    if item_id not in id_map:
                        used.setdefault(stem, set()).add(major)  # reserve existing
                        new_major = next_free_major(stem, used)
                        id_map[item_id] = f"{stem}{new_major:02d}.00"
    else:
        # Load mapping file
        if not ID_MAP_PATH.exists():
            print(f"ERROR: ID map not found at {ID_MAP_PATH}. Use --auto or provide --map <path>.")
            sys.exit(1)
        with ID_MAP_PATH.open("r", encoding="utf-8") as f:
            id_map_root = json.load(f)

        # Accept flat {old:new} or module-scoped {"module": {old:new}}
        if isinstance(id_map_root, dict) and all(isinstance(v, str) for v in id_map_root.values()):
            id_map = dict(id_map_root)
        else:
            for k, v in id_map_root.items():
                if isinstance(v, dict):
                    for old_id, new_id in v.items():
                        id_map[old_id] = new_id

    # For reporting
    changes: List[Tuple[str, str, str, str]] = []  # (file, kind, old_id, new_id)

    # 1) Apply renames inside repositories (lessons/parts/tools)
    for root in REPO_DIRS:
        if not root.exists(): continue
        for p in root.rglob("*.json"):
            doc = load_json(p)
            modified = False
            for container, obj, kind in iter_repo_objects(doc):
                old_id = obj.get(ID_KEY)
                if not old_id:
                    continue
                new_id = id_map.get(old_id, old_id)
                if new_id != old_id:
                    # rename object id
                    obj[ID_KEY] = new_id
                    modified = True
                    changes.append((str(p), kind, old_id, new_id))

                    # rename *any* flashcards array present, not just lessons
                    if RENAME_FLASHCARDS and isinstance(obj.get("flashcards"), list):
                        for fc in obj["flashcards"]:
                            fc_id = fc.get(ID_KEY)
                            if isinstance(fc_id, str):
                                new_fc_id = replace_flashcard_id(fc_id, old_id, new_id)
                                if new_fc_id != fc_id:
                                    fc[ID_KEY] = new_fc_id
                                    changes.append((str(p), "flashcard", fc_id, new_fc_id))

            if modified and not DRY_RUN:
                save_json(p, doc)

    # 2) Apply renames inside PATH files (items)
    for p in PATHS_DIR.rglob("*.json"):
        doc = load_json(p)
        modified = False
        for item_dict, item_id in iter_path_item_ids(doc):
            new_id = id_map.get(item_id, item_id)
            if new_id != item_id:
                item_dict[ID_KEY] = new_id
                modified = True
                changes.append((str(p), "path_item", item_id, new_id))
        if modified and not DRY_RUN:
            save_json(p, doc)

    # 3) Validation phase
    # Reload all repo ids post-change (or current state if dry-run)
    all_ids_after = collect_all_object_ids()

    # a) Every path item id must resolve to a repo object
    dangling: List[Tuple[str, str]] = []
    for p in PATHS_DIR.rglob("*.json"):
        doc = load_json(p)
        for _, item_id in iter_path_item_ids(doc):
            if item_id not in all_ids_after:
                dangling.append((str(p), item_id))

    # b) Every repo object id must end with .00 (non-flashcards)
    bad_suffix: List[Tuple[str, str]] = []
    for obj_id, filep in all_ids_after.items():
        # Only check non-flashcards and ids matching our (lesson|part|tool)_ pattern
        if obj_id.startswith(FLASHCARD_PREFIX):
            continue
        m = ID_RE.match(obj_id or "")
        if m and not obj_id.endswith(".00"):
            bad_suffix.append((str(filep), obj_id))

    # c) Duplicates (same id in more than one file)
    id_counts: Dict[str, int] = {}
    for root in REPO_DIRS:
        if not root.exists(): continue
        for p in root.rglob("*.json"):
            doc = load_json(p)
            for _, obj, _ in iter_repo_objects(doc):
                oid = obj.get(ID_KEY)
                if not oid: continue
                id_counts[oid] = id_counts.get(oid, 0) + 1
    duplicates = [(oid, cnt) for oid, cnt in id_counts.items() if cnt > 1]

    # Emit CSV report
    CSV_LOG.parent.mkdir(parents=True, exist_ok=True)
    with CSV_LOG.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["file", "kind", "old_id", "new_id"])
        for row in changes:
            w.writerow(row)

    # Print summary
    print("\n=== CODEMOD SUMMARY ===")
    print(f"Mode: {'DRY RUN' if DRY_RUN else 'WRITE MODE'}")
    print(f"Changes planned: {len(changes)} (see {CSV_LOG})")

    if dangling:
        print("\nDangling path references (MUST FIX):")
        for f, missing_id in dangling:
            print(f" - {missing_id}  (in {f})")
    else:
        print("\nNo dangling path references.")

    if bad_suffix:
        print("\nIDs without .00 suffix (MUST FIX or update mapping):")
        for f, bad in bad_suffix:
            print(f" - {bad}  (in {f})")
    else:
        print("\nAll non-flashcard IDs end with .00 ✅")

    if duplicates:
        print("\nDuplicate IDs after codemod (MUST FIX):")
        for oid, cnt in duplicates:
            print(f" - {oid} appears {cnt} times")
    else:
        print("\nNo duplicate IDs ✅")

    # Exit status: fail if errors exist
    if dangling or bad_suffix or duplicates:
        print("\n❌ Validation failed. Fix the above issues, update your mapping or rerun --auto, then re-run.")
        sys.exit(2)

    print("\n✅ Validation passed.")
    if DRY_RUN:
        print("Switch to --write (or set DRY_RUN=False) to apply changes.")

if __name__ == "__main__":
    main()
