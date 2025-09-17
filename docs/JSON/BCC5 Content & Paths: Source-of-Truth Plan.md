# BCC5 Content & Paths: Source-of-Truth Plan

*Last updated: today*

This document defines how lessons, parts, tools, and learning paths are authored, stored, discovered, and rendered in the app—without hard-coded module names. It’s meant to be copy-pasted into your repo (e.g., `docs/content-architecture.md`) so the team can resurrect the approach anytime.

---

## 1) Goals

* **Single source of truth in JSON/CSV**, no code edits for new modules.
* **Auto-discovery** of modules via `AssetManifest.json`.
* **Global ID index** so any item can be resolved by its `id` (lesson/part/tool) regardless of which module file it lives in.
* **Paths drive sequencing**: the path defines the exact order of lessons/parts/tools by **IDs**, and the detail screens follow that order (not module order).
* **Spreadsheet-friendly workflow**: content teams can edit CSVs, convert to JSON, drop in `assets/json/...`, and be done.

---

## 2) Directory Layout

```
assets/
  json/
    lessons/
      <module>.json           # e.g., "terminology.json", "knots.json"
    parts/
      <module>.json           # e.g., "deck.json", "rigging.json"
    tools/
      <module>.json           # e.g., "vhf.json", "colregs.json", "checklists.json"
    paths/
      <pathkey>.json          # e.g., "competent_crew.json"
```

* **Module files**: one per module; each file contains an array under a type-specific key (`lessons`, `parts`, `tools`).
* **Path files**: one per learning path (e.g., `competent_crew.json`).

---

## 3) JSON Schemas

### 3.1 Lesson module file (`assets/json/lessons/<module>.json`)

```json
{
  "module": "terminology",
  "lessons": [
    {
      "id": "lesson_term_1.00",
      "title": "Basic Nautical Terms",
      "content": [ { "type": "text", "content": "..." }, { "type": "image", "src": "..." } ],
      "flashcards": [
        {
          "id": "flashcard_lesson_term_1.00",
          "title": "Term Drill",
          "sideA": [ { "type": "text", "content": "..." } ],
          "sideB": [ { "type": "text", "content": "..." } ]
        }
      ]
    }
  ]
}
```

### 3.2 Parts module file (`assets/json/parts/<module>.json`)

```json
{
  "module": "deck",
  "parts": [
    {
      "id": "part_deck_1.00",
      "title": "Cleats & Fairleads",
      "content": [ { "type": "text", "content": "..." } ],
      "flashcards": []
    }
  ]
}
```

### 3.3 Tools module file (`assets/json/tools/<module>.json`)

```json
{
  "module": "vhf",
  "tools": [
    {
      "id": "tool_vhf_1.00",
      "title": "Making a Mayday Call",
      "content": [ { "type": "text", "content": "..." } ],
      "flashcards": []
    }
  ]
}
```

### 3.4 Path file (`assets/json/paths/<pathkey>.json`)

```json
{
  "path": "competent crew",
  "chapters": [
    {
      "id": "path_competentCrew_1.00",
      "title": "Home: Before You Board",
      "showFlashcardEnding": true,
      "items": [
        { "id": "lesson_safe_1.11" },
        { "id": "lesson_safe_1.12" },
        { "id": "tool_colregs_1.00" },
        { "id": "part_deck_1.00" }
      ]
    }
  ]
}
```

**Notes**

* `items[].id` must match an **item ID** present in lessons/parts/tools JSON files.
* IDs are **globally unique** across all content types.

---

## 4) ContentCatalog (runtime index)

**Purpose**: On first use, scan `AssetManifest.json` to discover all module files, load them on demand, and build an **ID → (type, modulePath, rawJson)** index.

**Responsibilities**

1. **Asset discovery**
   Find all module files:

   * `assets/json/lessons/*.json`
   * `assets/json/parts/*.json`
   * `assets/json/tools/*.json`
   * `assets/json/paths/*.json` (for paths UI)
2. **Lazy loading + caching**
   When asked for an item by `id`, load the owning module file if needed and cache the parsed results.
3. **Global lookup**
   `getById(String id) → ContentRecord?` where `ContentRecord` includes:

   * `type: lesson | part | tool`
   * `id`, `title`
   * `content` blocks
   * `flashcards`
   * `originPath` (the module file path that contained it)
4. **List APIs for branch UIs**

   * `listModules(type)` → `['vhf', 'colregs', ...]`
   * `listItemsInModule(type, module)` → `[ {id, title}, ... ]`

**Edge cases**

* If duplicate IDs are found, log a warning and keep the **first** (or fail fast in debug).
* If an ID is requested that doesn’t exist, return `null` (callers decide to skip or show a toast).

---

## 5) Path repository

**JsonPathRepository**

* Reads `assets/json/paths/*.json`.
* `getPaths()` → `['competent crew', ...]`
* `getChaptersForPath(path)` → `List<LearningPathChapter>`
* `getChapterById(path, chapterId)` → `LearningPathChapter?`
* `getNextChapter(path, currentChapterId)` → `LearningPathChapter?`

**LearningPathChapter model**

```dart
class PathItemRef { final String id; const PathItemRef({required this.id}); }

class LearningPathChapter {
  final String id;
  final String title;
  final List<PathItemRef> items;       // preserves ORDER
  final bool showFlashcardEnding;
  const LearningPathChapter({ required this.id, required this.title, required this.items, this.showFlashcardEnding = true });
}
```

---

## 6) Building screens from IDs

**buildRenderItems(List<String> ids)**

* For each `id`, resolve via `ContentCatalog.getById`.
* Convert `ContentRecord` → `RenderItem` (existing model).
* **Preserve order** of `ids`.
* Skip missing IDs (log with item number and chapter id).

**Detail screens (Lesson/Part/Tool)**

* Navigation **Next/Previous** just moves `currentIndex` inside the **current `renderItems` list**, which was built from the Path (or from the Branch UI list).
* At the **end of a chapter**, “Next” asks `JsonPathRepository.getNextChapter(...)`, then calls `buildRenderItems(nextChapter.items.map((i)=>i.id))`.
* At the **end of a module (branch browsing)**, “Next” gets the **next module** from `ContentCatalog.listModules(type)` and then lists its items.

---

## 7) Developer workflow (CSV → JSON)

**Spreadsheet columns**

* `path` — e.g., `competent crew`
* `chapter_id` — e.g., `path_competentCrew_1.00`
* `chapter_title` — e.g., `Home: Before You Board`
* `show_flashcard_ending` — `true/false` (optional; default true)
* `item_order` — integer (1..N)
* `item_id` — e.g., `lesson_safe_1.11`, `tool_colregs_1.00`, `part_deck_1.00`

**Conversion (one simple approach)**

* Sort rows by `(path, chapter_id, item_order)`.
* Group by `(path, chapter_id, chapter_title, show_flashcard_ending)`.
* Emit one `paths/<pathkey>.json` per `path`, with the `chapters` array assembled in CSV order.
* **Path key** is a filesystem-friendly slug of `path` (e.g., `competent_crew`).

**Module content spreadsheets**

* Each module (lessons/parts/tools) can have its own CSV with columns matching the JSON fields (`id`, `title`, content block definitions, flashcards). The converter outputs the module JSONs—drop them into the `assets/json/<type>/` folder.

> We can add a tiny dev-script later (Node/Python) to produce these JSONs from CSVs. For now, the format is straightforward enough to assemble manually or via the team’s preferred tooling.

---

## 8) ID conventions & validation

* **Prefix by type** to avoid collisions:

  * `lesson_*`, `part_*`, `tool_*`, `flashcard_*`
* Keep a consistent module hint if desired (not required):
  `lesson_term_1.00`, `tool_vhf_2.10`, `part_deck_3.00`.
* **Uniqueness**: IDs must be unique across the entire app.
  During catalog build we can:

  * In debug: assert/fail on duplicates.
  * In release: log once and keep the first.

---

## 9) Error handling & logging

* **Missing asset file** → log `Could not load <path>`.
* **Malformed JSON** → log parse error with filename.
* **Unknown ID in Path** → log `Path references unknown id: <id>` and skip.
* **Empty chapter** → show friendly toast “This chapter has no items.”

---

## 10) Migration notes (legacy → JSON)

* Keep legacy repositories around temporarily as a **fallback** for unmatched IDs, if helpful. The new path flow only uses IDs; wherever an old ID format persists, add a small mapping table (optional) until all content is migrated.
* Once JSON coverage reaches 100%, remove legacy code paths.

---

## 11) Testing checklist

* ✅ App starts with **no hard-coded module names**.
* ✅ New module file appears automatically in Lessons/Parts/Tools screens.
* ✅ New path file appears in the Learning Paths list (if you show one).
* ✅ Path detail: “Start from beginning” renders the first chapter’s items in the exact **CSV order**.
* ✅ “Next” at end of item moves to the next item in the path sequence.
* ✅ “Next” at end of chapter loads the next chapter, preserving order.
* ✅ Missing or bad IDs don’t crash; they log and are skipped.
* ✅ Branch browsing (Lessons/Parts/Tools) still lists modules and items from files.
* ✅ Lints: no `use_build_context_synchronously`; async navigation guarded with `if (!mounted) return;`.

---

## 12) Future extensions

* **On-device cache** of parsed catalogs (rehydrate on app start).
* **Versioning**: `schemaVersion` and `contentVersion` fields for each file.
* **Analytics hooks**: centralize “completed item/chapter/path” events.
* **Localizations**: parallel `assets/json_<locale>/...` trees or i18n keys in content blocks.
* **Remote sync**: later replace asset files with a signed remote JSON feed (same schema) without code changes.

---

## 13) Minimal API Summary (for app code)

```dart
/// ContentCatalog
abstract class ContentCatalog {
  /// Scans AssetManifest and prepares indexes (lazy load is OK).
  static Future<void> init();

  /// Resolve an item by ID across lessons/parts/tools.
  static Future<ContentRecord?> getById(String id);

  /// Lists module names for a type ("lessons"|"parts"|"tools").
  static Future<List<String>> listModules(String type);

  /// Lightweight rows for a module: [{id, title}, ...]
  static Future<List<Map<String, String>>> listItems(String type, String module);
}

/// Path repository
abstract class JsonPathRepository {
  static Future<List<String>> getPathKeys();                   // e.g. ['competent crew']
  static Future<List<LearningPathChapter>> getChapters(String pathKey);
  static Future<LearningPathChapter?> getChapterById(String pathKey, String id);
  static Future<LearningPathChapter?> getNextChapter(String pathKey, String currentId);
}

/// Build in-order render items from IDs (path or module list)
Future<List<RenderItem>> buildRenderItems({required List<String> ids});
```

---

## 14) Quick “How to add content” for devs

1. **Add/Update modules**
   Drop new or updated JSON files into:

   * `assets/json/lessons/<module>.json`
   * `assets/json/parts/<module>.json`
   * `assets/json/tools/<module>.json`

2. **Define/Update a path**
   Convert your path spreadsheet to `assets/json/paths/<pathkey>.json` using the schema above.

3. **Run the app**

   * The branch UIs (Lessons/Parts/Tools) auto-discover modules.
   * Paths screens read `paths/<pathkey>.json`.
   * Detail screens walk items **in the order provided by the path**.

---

If you want, I can follow up with the **exact Dart stubs** for `ContentCatalog` and `JsonPathRepository` (drop-in, with your existing models) plus a tiny CSV→JSON converter script.
