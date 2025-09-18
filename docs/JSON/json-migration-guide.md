
# ✅ Migration Complete — JSON-Only Repos (Authoring & Integration Guide)

**Date:** 2025-09-18  
**Audience:** App devs, content authors

This guide documents the now fully JSON-backed architecture for Lessons, Parts, Tools, Flashcards, and Paths. It also captures the contracts needed so future edits remain **drop-in** (no code changes).

---

## 1) What’s JSON-backed (and stays that way)

- **Lessons** – `JsonLessonRepository`
- **Parts** – `JsonPartRepository`
- **Tools** – `JsonToolRepository`
- **Flashcards** – `JsonFlashcardRepository`
- **Paths** – `JsonPathRepository`
- **Search** – scans `AssetManifest.json`
- **Content blocks** – `ContentBlockRenderer` (+ `gpsConverter` block)
- **Detail screens** – `LessonDetailScreen`, `PartDetailScreen`, `ToolDetailScreen`, `FlashcardDetailScreen`  
- **Nav helpers** – `LastGroupButton`, `LearningPathProgressBar`

> **Lint pattern:** Await/compute first, then **guard UI** with `if (!mounted) return;` before using `context`.

---

## 2) JSON Contracts (minimal, stable)

### 2.1 Paths (`assets/json/paths/<slug>.json`)
- File location uses the slug (e.g., `"competent_crew"` → `assets/json/paths/competent_crew.json`).
- Top-level **either** `"chapters"` **or** `"groups"` (same shape).
- Each chapter/group:
  - `id` (string, canonical ID)
  - `title` (string)
  - `items` (array of item refs; any of:)
    - `"some_id_string"`
    - `{ "id": "some_id_string" }`
    - `{ "pathItemId": "some_id_string" }`
- Chapter and path matching is **loose**:
  - Path accepts raw name **or** slug (case/spacing tolerant)
  - Chapter accepts `id` **or** its slug

**Path APIs**
```dart
Future<List<PathChapter>> getChaptersForPath(String pathNameOrSlug)
Future<PathChapter?> getNextChapter(String pathNameOrSlug, String currentChapterId)
Future<String?> getChapterTitleForPath(String pathNameOrSlug, String chapterId)
```

**Example** (either `chapters` or `groups`)
```json
{
  "title": "Competent Crew",
  "chapters": [
    {
      "id": "getting_started",
      "title": "Getting Started",
      "items": [
        "flashcard_nav_basics",
        { "id": "lesson_navigation_intro" },
        { "pathItemId": "tool_vhf_basics" }
      ]
    }
  ]
}
```

### 2.2 Lessons / Parts / Tools (module files)
- Repos read from `assets/json/<type>/<module>.json`.
- Provide **module names** + **items per module**.

**Lesson APIs**
```dart
Future<List<String>> getModuleNames()
Future<List<Map<String,String>>> getLessonsForModule(String moduleId) // each map has 'id'
```

**Part APIs**
```dart
Future<List<String>> getModuleNames()
Future<List<Map<String,String>>> getPartsForModule(String moduleId)
```

**Tool APIs**
```dart
Future<List<String>> getModuleNames()
Future<List<Map<String,String>>> getToolsForModule(String moduleId)
```

**Module file example**
```json
{
  "title": "Navigation",
  "items": [
    { "id": "lesson_navigation_intro" },
    { "id": "lesson_navigation_plotting" }
  ]
}
```

### 2.3 Flashcards
- Categories are JSON-driven.
- Special categories **`all`** and **`random`** are **terminal** — show back/start-over CTA instead of “Next Category”.

**Flashcard APIs**
```dart
Future<List<String>> getAllCategories()
Future<List<Flashcard>> getFlashcardsForCategory(String category)
Future<List<Flashcard>> getFlashcardsByIds(List<String> ids) // if needed
```

---

## 3) Authoring Workflow (zero code changes)

1. Drop/update JSON files in:
   - `assets/json/paths/` (new/updated path)
   - `assets/json/lessons/`, `assets/json/parts/`, `assets/json/tools/` (new/updated modules)
   - Flashcards as your repo expects (categories stay JSON-driven)
2. Ensure `pubspec.yaml` includes `assets/json/**` (already configured).
3. Build/run — search & screens discover content via `AssetManifest.json`.

---

## 4) UX / Navigation Rules

- **Breadcrumbs**
  - Path flow: `Path Name / <chapterTitle>` (title fetched async from JSON)
  - Standalone modules: `Courses / Module`, `Parts / Zone`, `Tools / Toolbag`
- **Next-group logic**
  - Path flows: next chapter via `getNextChapter`.
  - Module flows: next module from `getModuleNames()`.
- **Restart**
  - “Start Over” jumps to the first JSON module/chapter.
- **Safety**
  - All navigation after `await` uses `if (!mounted) return;`.

---

## 5) Sanity Checks

```bash
# Legacy path index (should be none)
grep -R "path_repository_index" lib | grep -v "^[[:space:]]*//"   || echo "✅ no active legacy PathRepositoryIndex imports"

# Curated mapping (should be none)
grep -R "competent_crew_flashards\|curatedChapterFlashcards" lib | grep -v "^[[:space:]]*//"   || echo "✅ no curated flashcard references"

# Analyzer
flutter analyze
```

---

## 6) Tips & Notes

- **IDs**: Use stable, lowercase, URL-safe IDs; path repo tolerates raw vs slug.
- **Performance**: Keep JSON files reasonably sized; repos read assets async.
- **Adding a new path**: Adding `assets/json/paths/<new>.json` is sufficient; no code changes.
- **Curated overrides removed**: “Test your knowledge” decks are derived from chapter items in JSON.

---

## 7) Change Log

- 2025-09-18: Initial publication of migration guide; project is fully JSON-backed.
