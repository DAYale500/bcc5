# BCC5 Universal CSV ↔ JSON Converter

This gives you a **standard, branch‑agnostic** pipeline to author **lessons, parts, tools** (and their optional **flashcards**) in spreadsheets, then assemble the JSON bundles your app already consumes — and back again.

## Install

```yaml
# pubspec.yaml
dependencies:
  csv: ^6.0.0
```
```bash
dart pub get
```

Put the script somewhere like `tool/universal_convert.dart`.

## Directory Layout

```
data_csv/
  lessons/
    lessons_seamanship.csv
    lessons_emergencies.csv
  parts/
    parts_engine.csv
  tools/
    tools_docking.csv
  flashcards/
    flashcards_lessons_seamanship.csv
    flashcards_tools_docking.csv
    # OR a single combined:
    # flashcards.csv (must include 'type' and 'module' columns)
assets/
  json/
    lessons/
      seamanship.json
      emergencies.json
    parts/
      engine.json
    tools/
      docking.json
```

## Item CSV Columns

`id,title,keywords,isPaid,content_md,content_file,module`

- **keywords**: comma or semicolon separated
- **isPaid**: `true` or `false`
- **content_md**: inline markdown (## headings, paragraphs, `- ` bullets, and `![](path)` images)
- **content_file**: optional path to a `.md` file if you prefer editing in a doc
- **module**: optional explicit value; otherwise it is **inferred from filename** (e.g., `lessons_emergencies.csv` → `emergencies`)

## Flashcards CSV Columns (optional)

`parent_id,card_id,title,sideA_text,sideB_text,isPaid,showAFirst,module`

- Place per‑module files like `flashcards_lessons_emergencies.csv`, _or_ a single `flashcards.csv` that includes `type` and `module` columns.
- `parent_id` must match the `id` in the parent item CSV.
- Cards are embedded into the JSON output for each item.

## Run

### CSV → JSON

```bash
dart run tool/universal_convert.dart to-json --type=lessons
dart run tool/universal_convert.dart to-json --type=parts
dart run tool/universal_convert.dart to-json --type=tools
```
Emits `assets/json/<type>/<module>.json` bundles.

### JSON → CSV

```bash
dart run tool/universal_convert.dart to-csv --type=lessons
dart run tool/universal_convert.dart to-csv --type=parts
dart run tool/universal_convert.dart to-csv --type=tools
```
Emits `data_csv/<type>/<type>_<module>.csv` and `data_csv/flashcards/flashcards_<type>_<module>.csv`.

## Notes & Extending

- Markdown↔blocks supports a minimal, predictable subset to keep round‑trips stable.
- If your current JSON embeds flashcards (e.g., `emergencies.json` with lesson + flashcard), this tool **preserves that shape** when converting CSV → JSON, and **round-trips** JSON → CSV by emitting item and flashcard CSVs. It’s compatible with your existing emergencies example. 
- If you later need richer block types or structured flashcards (images, lists), add columns like `sideA_json`, `sideB_json` and extend the serializer.
