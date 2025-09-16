# Module-Based Content Workflow (CSV → JSON → App)

This document explains the **editor-friendly** workflow to maintain lessons (and later parts/tools/paths) using a **single JSON file per module**. Editors work in spreadsheets; developers (or CI) convert the CSV export to the JSON file the app reads.

---

## 1) Directory layout (app assets)

```
assets/
  json/
    lessons/
      docking.json
      safety.json
      emergencies.json
      seamanship.json
      terminology.json   ← example in this doc
      systems.json
      teamwork.json
      knots.json
      navigation.json
    parts/
      hull.json           (future)
      rigging.json        (future)
    paths/
      competentCrew.json  (future)
```

Each module file packs its items in a single JSON bundle:
```json
{
  "module": "terminology",
  "lessons": [
    {
      "id": "lesson_term_1.00",
      "title": "Essential Terms",
      "content": [
        {"type": "text", "data": "Introduction to essential sailing terms."}
      ],
      "keywords": ["essential terms","sailing basics","orientation"],
      "isPaid": false,
      "flashcards": [
        {
          "id": "flashcard_lesson_term_1.00",
          "title": "Essential Terms",
          "sideA": [{"type":"text","data":"What are some essential...?"}],
          "sideB": [{"type":"text","data":"Terms like 'bow' (front)..."}],
          "isPaid": false,
          "showAFirst": true
        }
      ]
    }
  ]
}
```

---

## 2) Spreadsheet schema (one sheet per module)

**One row = one lesson.** Suggested columns:

| Column            | Type     | Notes                                                                 |
|-------------------|----------|-----------------------------------------------------------------------|
| `id`              | text     | e.g., `lesson_term_1.00`. Prefix determines module.                  |
| `title`           | text     | Human-friendly title.                                                |
| `keywords`        | text     | Semicolon-separated list: `foo; bar; baz`.                           |
| `isPaid`          | boolean  | `TRUE`/`FALSE`                                                        |
| `content_json`    | JSON     | A JSON array of content blocks (see below).                          |
| `flashcards_json` | JSON     | Optional JSON array of flashcard objects.                            |

### Content block JSON (cell value in `content_json`)
- The app accepts any of these payload keys for block text: `content` **or** `value` **or** `data`.
- Example cell content (exactly as typed into the spreadsheet cell):

```json
[
  {"type":"text","data":"Introduction to essential sailing terms."},
  {"type":"image","data":"assets/images/terms.png"},
  {"type":"bulletList","data":["Bow","Stern","Port","Starboard"]}
]
```

### Flashcards JSON (cell value in `flashcards_json`)
```json
[
  {
    "id": "flashcard_lesson_term_1.00",
    "title": "Essential Terms",
    "sideA": [{"type":"text","data":"What are some essential terms?"}],
    "sideB": [{"type":"text","data":"Bow, stern, port, starboard."}],
    "isPaid": false,
    "showAFirst": true
  }
]
```

> Tip: If editors don’t want to write JSON, they can leave `content_json` blank and just type normal text in a separate column; the converter can wrap that text into a single `text` block automatically.

---

## 3) Convert CSV → JSON (per module)

Save this script as `scripts/csv_to_module_json.py`:

```python
import csv, json, sys, pathlib

def parse_bool(s):
    return str(s).strip().lower() in ("true","1","yes","y")

def parse_json_cell(s, fallback_text_key=None):
    s = (s or "").strip()
    if not s:
        return []
    try:
        return json.loads(s)
    except Exception:
        # If the editor wrote plain text, wrap it as one text block
        if fallback_text_key:
            return [{ "type": "text", fallback_text_key: s }]
        return []

def main():
    if len(sys.argv) != 4:
        print("Usage: python3 csv_to_module_json.py <module> <in.csv> <out.json>")
        sys.exit(1)

    module_name, csv_path, out_path = sys.argv[1], sys.argv[2], sys.argv[3]
    lessons = []

    with open(csv_path, newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            lessons.append({
                "id": row.get("id","").strip(),
                "title": row.get("title","").strip(),
                "content": parse_json_cell(row.get("content_json",""), "data"),
                "keywords": [k.strip() for k in row.get("keywords","").split(";") if k.strip()],
                "isPaid": parse_bool(row.get("isPaid","false")),
                "flashcards": parse_json_cell(row.get("flashcards_json",""))
            })

    bundle = {"module": module_name, "lessons": lessons}

    pathlib.Path(out_path).parent.mkdir(parents=True, exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as out:
        json.dump(bundle, out, ensure_ascii=False, indent=2)

    print(f"Wrote {out_path} with {len(lessons)} lessons")

if __name__ == "__main__":
    main()
```

**Run it:**
```bash
python3 scripts/csv_to_module_json.py terminology content_spreadsheets/terminology.csv assets/json/lessons/terminology.json
```

- After writing to `assets/…`, do a **hot restart** so Flutter reloads assets.
- The **Lessons list** reads titles from `terminology.json`.
- The **Lesson detail** finds a lesson by `id` inside the same file.

---

## 4) Optional reverse: JSON → CSV

This is useful for bulk review or handing back to editors. Save as `scripts/module_json_to_csv.py`:

```python
import csv, json, sys, pathlib

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 module_json_to_csv.py <in.json> <out.csv>")
        sys.exit(1)

    in_path, out_path = sys.argv[1], sys.argv[2]
    with open(in_path, encoding="utf-8") as f:
        bundle = json.load(f)

    lessons = bundle.get("lessons", [])
    fields = ["id", "title", "keywords", "isPaid", "content_json", "flashcards_json"]

    pathlib.Path(out_path).parent.mkdir(parents=True, exist_ok=True)
    with open(out_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for e in lessons:
            writer.writerow({
                "id": e.get("id",""),
                "title": e.get("title",""),
                "keywords": "; ".join(e.get("keywords", [])),
                "isPaid": "TRUE" if e.get("isPaid", False) else "FALSE",
                "content_json": json.dumps(e.get("content", []), ensure_ascii=False),
                "flashcards_json": json.dumps(e.get("flashcards", []), ensure_ascii=False),
            })

    print(f"Wrote {out_path} with {len(lessons)} rows")

if __name__ == "__main__":
    main()
```

**Run it:**
```bash
python3 scripts/module_json_to_csv.py assets/json/lessons/terminology.json content_spreadsheets/terminology.csv
```

---

## 5) Quick QA checklist

- **IDs** follow the prefix convention (`lesson_term_`, `lesson_dock_`, etc.).  
- **Titles** exist for every lesson row.  
- **Content** renders (the app accepts `content` or `value` or `data`).  
- **Keywords** are semicolon-separated in CSV.  
- **Assets** referenced by `image` blocks exist and are listed in `pubspec.yaml` if bundled.  
- After copying a new JSON into `assets/json/lessons/`, perform a **hot restart**.

---

## 6) Notes for developers

- `JsonLessonIndex.getLessonsForModule` reads `assets/json/lessons/<module>.json` and returns `[{id,title}]` for the list screen.  
- `JsonLessonRepository.loadById(id)` derives the module from the lesson id, opens `<module>.json`, finds the matching lesson, and returns the model.  
- This approach eliminates per-lesson files and separate index files; editors only manage **one CSV per module**.
