ugh, sorry about that — I can’t attach those files directly right now, so here’s a **one-shot bootstrap script** that recreates the entire “Lesson Studio — Resurrection Kit” on your machine with the exact same contents (README, schema, CSV templates, converter, validator, Dart stubs).

Save this as `bootstrap_lesson_studio_kit.sh`, then run:

```bash
bash bootstrap_lesson_studio_kit.sh
```

It will create a `lesson_studio_kit/` folder with everything inside.

````bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="lesson_studio_kit"
mkdir -p "$ROOT/schema" "$ROOT/tools" "$ROOT/out"

# ---------------- README ----------------
cat > "$ROOT/README_LessonStudio_TODO.md" <<'EOF'
# Lesson Studio — Resurrection Kit (MVP)

This kit gives you everything needed to restart a simple authoring workflow later:
- Author in **CSV** (wide format + optional flashcards sheet)
- Convert to **App JSON (V1)** with a single command
- (Optional) **Validate** JSON against a schema
- Dart **mapper stubs** to keep app-side adapters tidy

## Files
- `schema/lessons_v1.schema.json` — JSON Schema for exported app file
- `tools/authoring_lessons.csv` — authoring template (one row per lesson)
- `tools/authoring_flashcards.csv` — optional extra sheet (multiple cards per lesson)
- `tools/csv_to_json.py` — converter (CSV → JSON V1)
- `tools/json_validate.py` — validate output against schema (requires `pip install jsonschema`)
- `tools/dart_mapper_stubs.dart` — Dart model + mapper stubs (drop into your repo, adapt names)

## Authoring: Two Options

### A) Single CSV (one card per lesson)
Edit `tools/authoring_lessons.csv` directly. It supports **one flashcard per lesson** in the same row.
- `content_text`: separate multiple paragraphs with `||`
- `content_images`: `;`-separated (e.g., `assets/images/one.jpg;assets/images/two.jpg`)

### B) Two CSVs (many cards per lesson)
- Keep **lessons** in `tools/authoring_lessons.csv` (ignore the flashcard columns there)
- Add **multiple flashcards** in `tools/authoring_flashcards.csv` (one row per flashcard, linked by `lesson_id`)

## Convert CSV → JSON

```bash
# Single CSV (A): one card per lesson
python tools/csv_to_json.py \
  --lessons tools/authoring_lessons.csv \
  --module docking \
  --out out/lessons_docking.json

# Two CSVs (B): many cards per lesson
python tools/csv_to_json.py \
  --lessons tools/authoring_lessons.csv \
  --flashcards tools/authoring_flashcards.csv \
  --module docking \
  --out out/lessons_docking.json
````

The converter creates the `out/` folder if missing.

## Validate JSON (optional)

```bash
pip install jsonschema
python tools/json_validate.py \
  --schema schema/lessons_v1.schema.json \
  --data out/lessons_docking.json
```

## App-Side

* Keep the learner app reading **V1 JSON**.
* If/when schema changes, update the mappers in `dart_mapper_stubs.dart` and bump `schemaVersion`.
* Optionally add a pre-commit/CI step to run `json_validate.py` on changed JSON.
  EOF

# ---------------- SCHEMA ----------------

cat > "\$ROOT/schema/lessons\_v1.schema.json" <<'EOF'
{
"\$schema": "[https://json-schema.org/draft/2020-12/schema](https://json-schema.org/draft/2020-12/schema)",
"title": "BCC5 Lessons V1",
"type": "object",
"required": \["schemaVersion", "module", "lessons"],
"properties": {
"schemaVersion": { "type": "integer", "const": 1 },
"module": { "type": "string", "minLength": 1 },
"lessons": {
"type": "array",
"items": {
"type": "object",
"required": \["id", "title", "content", "keywords", "isPaid", "flashcards"],
"properties": {
"id": { "type": "string", "minLength": 1 },
"title": { "type": "string", "minLength": 1 },
"content": {
"type": "array",
"items": {
"type": "object",
"required": \["type", "content"],
"properties": {
"type": { "type": "string", "enum": \["text", "image"] },
"content": { "type": "string" }
},
"additionalProperties": false
}
},
"keywords": { "type": "array", "items": { "type": "string" } },
"isPaid": { "type": "boolean" },
"flashcards": {
"type": "array",
"items": {
"type": "object",
"required": \["id", "title", "sideA", "sideB", "isPaid", "showAFirst"],
"properties": {
"id": { "type": "string" },
"title": { "type": "string" },
"sideA": {
"type": "array",
"items": {
"type": "object",
"required": \["type", "content"],
"properties": {
"type": { "type": "string", "enum": \["text"] },
"content": { "type": "string" }
},
"additionalProperties": false
}
},
"sideB": {
"type": "array",
"items": {
"type": "object",
"required": \["type", "content"],
"properties": {
"type": { "type": "string", "enum": \["text"] },
"content": { "type": "string" }
},
"additionalProperties": false
}
},
"isPaid": { "type": "boolean" },
"showAFirst": { "type": "boolean" }
},
"additionalProperties": false
}
}
},
"additionalProperties": false
}
}
},
"additionalProperties": false
}
EOF

# ---------------- CSV TEMPLATES ----------------

cat > "\$ROOT/tools/authoring\_lessons.csv" <<'EOF'
module,lesson\_id,lesson\_title,keywords,isPaid,content\_text,content\_images,flashcard\_id,flashcard\_title,flashcard\_sideA,flashcard\_sideB,flashcard\_isPaid,flashcard\_showAFirst
docking,lesson\_dock\_1.00,"L1: Handling Dock Lines Repository","",FALSE,"Learn how to approach the dock methodically to ensure smooth arrivals.||Use dock lines effectively to secure the boat in variable conditions.||Crew coordination and preparation makes docking safer and easier.","assets/images/fallback\_image.jpeg;assets/images/fallback\_image.jpeg",flashcard\_lesson\_dock\_1.00,"Using Dock Lines","What is the purpose of dock lines during mooring?","To secure the vessel to the dock and control its movement.",FALSE,TRUE
EOF

cat > "\$ROOT/tools/authoring\_flashcards.csv" <<'EOF'
lesson\_id,flashcard\_id,flashcard\_title,sideA,sideB,flashcard\_isPaid,flashcard\_showAFirst
lesson\_dock\_1.00,flashcard\_lesson\_dock\_1.00,"Using Dock Lines","What is the purpose of dock lines during mooring?","To secure the vessel to the dock and control its movement.",FALSE,TRUE
EOF

# ---------------- CONVERTER ----------------

cat > "\$ROOT/tools/csv\_to\_json.py" <<'EOF'
\#!/usr/bin/env python3
import argparse, csv, json
from pathlib import Path

def parse\_bool(val):
if isinstance(val, bool): return val
s = str(val).strip().lower()
return s in ("1","true","yes","y","on")

def split\_multi(val, sep):
if val is None: return \[]
s = str(val).strip()
if not s: return \[]
return \[x.strip() for x in s.split(sep) if x.strip()]

def build\_content(text\_field, image\_field):
content = \[]
for t in split\_multi(text\_field, "||"):
content.append({"type": "text", "content": t})
for img in split\_multi(image\_field, ";"):
content.append({"type": "image", "content": img})
return content

def read\_rows(path):
with open(path, newline='', encoding='utf-8') as f:
return list(csv.DictReader(f))

def attach\_one\_card(dest\_list, row):
fc\_id = (row\.get("flashcard\_id") or "").strip()
if not fc\_id: return
dest\_list.append({
"id": fc\_id,
"title": (row\.get("flashcard\_title") or "").strip(),
"sideA": \[{"type":"text","content": (row\.get("flashcard\_sideA") or "").strip()}],
"sideB": \[{"type":"text","content": (row\.get("flashcard\_sideB") or "").strip()}],
"isPaid": parse\_bool(row\.get("flashcard\_isPaid","false")),
"showAFirst": parse\_bool(row\.get("flashcard\_showAFirst","true"))
})

def main():
ap = argparse.ArgumentParser(description="Convert authoring CSV → BCC5 App JSON (V1)")
ap.add\_argument("--lessons", required=True, help="Path to authoring\_lessons.csv")
ap.add\_argument("--flashcards", help="Path to authoring\_flashcards.csv (optional)")
ap.add\_argument("--module", required=True, help="Module id, e.g., docking")
ap.add\_argument("--out", required=True, help="Output JSON path")
args = ap.parse\_args()

lessons\_rows = read\_rows(args.lessons)
flash\_rows = read\_rows(args.flashcards) if args.flashcards else \[]

flash\_by\_lesson = {}
for fr in flash\_rows:
lid = (fr.get("lesson\_id") or "").strip()
flash\_by\_lesson.setdefault(lid, \[]).append(fr)

lessons = \[]
for r in lessons\_rows:
lesson\_id = (r.get("lesson\_id") or "").strip()
if not lesson\_id: continue
lesson = {
"id": lesson\_id,
"title": (r.get("lesson\_title") or "").strip(),
"content": build\_content(r.get("content\_text"), r.get("content\_images")),
"keywords": split\_multi(r.get("keywords"), ";"),
"isPaid": parse\_bool(r.get("isPaid","false")),
"flashcards": \[]
}
\# single in-row card:
attach\_one\_card(lesson\["flashcards"], r)
\# optional many-cards CSV:
for fr in flash\_by\_lesson.get(lesson\_id, \[]):
lesson\["flashcards"].append({
"id": (fr.get("flashcard\_id") or "").strip(),
"title": (fr.get("flashcard\_title") or "").strip(),
"sideA": \[{"type":"text","content": (fr.get("sideA") or "").strip()}],
"sideB": \[{"type":"text","content": (fr.get("sideB") or "").strip()}],
"isPaid": parse\_bool(fr.get("flashcard\_isPaid","false")),
"showAFirst": parse\_bool(fr.get("flashcard\_showAFirst","true")),
})
lessons.append(lesson)

out = {"schemaVersion": 1, "module": args.module, "lessons": lessons}
out\_path = Path(args.out)
out\_path.parent.mkdir(parents=True, exist\_ok=True)
out\_path.write\_text(json.dumps(out, ensure\_ascii=False, indent=2), encoding="utf-8")
print(f"Wrote JSON → {out\_path}")

if **name** == "**main**":
main()
EOF
chmod +x "\$ROOT/tools/csv\_to\_json.py"

# ---------------- VALIDATOR ----------------

cat > "\$ROOT/tools/json\_validate.py" <<'EOF'
\#!/usr/bin/env python3
import argparse, json, sys
from pathlib import Path

def main():
ap = argparse.ArgumentParser(description="Validate JSON against a JSON Schema (requires 'jsonschema')")
ap.add\_argument("--schema", required=True, help="Path to JSON schema")
ap.add\_argument("--data", required=True, help="Path to JSON data")
args = ap.parse\_args()

try:
from jsonschema import Draft202012Validator
except Exception:
print("This script requires the 'jsonschema' package. Install with: pip install jsonschema")
sys.exit(2)

schema = json.loads(Path(args.schema).read\_text(encoding="utf-8"))
data = json.loads(Path(args.data).read\_text(encoding="utf-8"))

validator = Draft202012Validator(schema)
errors = sorted(validator.iter\_errors(data), key=lambda e: e.path)
if not errors:
print("✅ JSON is valid ✅")
sys.exit(0)
print("❌ JSON failed validation:")
for err in errors:
loc = "/".join(\[str(x) for x in err.path])
print(f" - {loc}: {err.message}")
sys.exit(1)

if **name** == "**main**":
main()
EOF
chmod +x "\$ROOT/tools/json\_validate.py"

# ---------------- DART STUBS ----------------

cat > "\$ROOT/tools/dart\_mapper\_stubs.dart" <<'EOF'
// tools/dart\_mapper\_stubs.dart
class AuthorModule {
final int schemaVersion;
final String module;
final List<AuthorLesson> lessons;
AuthorModule({required this.schemaVersion, required this.module, required this.lessons});
}

class AuthorLesson {
final String id;
final String title;
final List<AuthorBlock> blocks;
final List<String> keywords;
final bool isPaid;
final List<AuthorFlashcard> flashcards;
AuthorLesson({
required this.id,
required this.title,
required this.blocks,
required this.keywords,
required this.isPaid,
required this.flashcards,
});
}

class AuthorBlock {
final String type; // 'text'|'image'
final String content;
AuthorBlock({required this.type, required this.content});
}

class AuthorFlashcard {
final String id;
final String title;
final String sideAText;
final String sideBText;
final bool isPaid;
final bool showAFirst;
AuthorFlashcard({
required this.id,
required this.title,
required this.sideAText,
required this.sideBText,
required this.isPaid,
required this.showAFirst,
});
}

AuthorModule parseV1(Map\<String, dynamic> json) {
final lessons = <AuthorLesson>\[];
for (final l in (json\['lessons'] as List)) {
final blocks = <AuthorBlock>\[];
for (final b in (l\['content'] as List)) {
blocks.add(AuthorBlock(type: b\['type'], content: b\['content']));
}
final cards = <AuthorFlashcard>\[];
for (final c in (l\['flashcards'] as List)) {
String readSide(List<dynamic> side) {
if (side.isEmpty) return '';
final obj = side.first as Map\<String, dynamic>;
return obj\['content'] ?? '';
}
cards.add(AuthorFlashcard(
id: c\['id'],
title: c\['title'],
sideAText: readSide(c\['sideA'] as List),
sideBText: readSide(c\['sideB'] as List),
isPaid: c\['isPaid'] as bool? ?? false,
showAFirst: c\['showAFirst'] as bool? ?? true,
));
}
lessons.add(AuthorLesson(
id: l\['id'],
title: l\['title'],
blocks: blocks,
keywords: (l\['keywords'] as List).cast<String>(),
isPaid: l\['isPaid'] as bool? ?? false,
flashcards: cards,
));
}
return AuthorModule(
schemaVersion: json\['schemaVersion'] as int? ?? 1,
module: json\['module'],
lessons: lessons,
);
}

Map\<String, dynamic> toV1(AuthorModule m) {
return {
'schemaVersion': 1,
'module': m.module,
'lessons': m.lessons.map((l) => {
'id': l.id,
'title': l.title,
'content': l.blocks.map((b) => {
'type': b.type,
'content': b.content,
}).toList(),
'keywords': l.keywords,
'isPaid': l.isPaid,
'flashcards': l.flashcards.map((c) => {
'id': c.id,
'title': c.title,
'sideA': \[{'type': 'text', 'content': c.sideAText}],
'sideB': \[{'type': 'text', 'content': c.sideBText}],
'isPaid': c.isPaid,
'showAFirst': c.showAFirst,
}).toList(),
}).toList(),
};
}
EOF

echo "✅ Created \$ROOT"

```

If you’d still prefer downloadable files, I can try to regenerate them again here—but the script above will reliably rebuild the exact kit on your machine anytime.
```
