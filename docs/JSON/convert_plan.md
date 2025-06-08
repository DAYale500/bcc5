first discussion:

Great — here's the strategic take on your earlier question about **shifting from Dart class-based repositories to JSON-based content storage**:

---

## ⚖️ Should You Convert to JSON?

### ✅ When JSON Is a Win:

1. **You want easy introspection.**

   * JSON is trivial to read from Python, TypeScript, shell scripts, or even in-browser editors.
   * Tools like `jq`, `pandas`, and VSCode plugins make data slicing trivial.

2. **You’re scaling up.**

   * JSON shines for modular, swappable content.
   * If you’re adding hundreds of lessons, tools, or paths, a file-per-object or centralized JSON document becomes way easier to QA, diff, and validate.

3. **You want structured versioning, syncing, or translations.**

   * Git-friendly and format-stable.
   * External systems can consume it (CMS, export pipelines, even AI pretraining datasets).

4. **You're already serializing for runtime use.**

   * If Dart is parsing these objects at runtime anyway (e.g. for a `List<Lesson>.from(json)`), you lose nothing by storing them natively as `.json`.

---

### 🚫 When to Pause:

1. **If your app logic is tightly coupled to Dart classes.**

   * You’ll need to update all places expecting `Lesson(...)` constructors and replace them with `Lesson.fromJson(...)` (or similar).
   * Refactoring required in model factories, UI logic, test code, maybe even dependency injection.

2. **If your editing pipeline is optimized around Dart.**

   * Developers can autocomplete class fields.
   * Compile-time errors help prevent bad input.
   * IDE refactors update field names across files automatically — something JSON lacks.

3. **If you’re still actively changing the data model.**

   * Updating field names across JSON + all code is annoying without a schema enforcement system.

---

## 🧭 Recommendation (Balanced Path)

Here’s a middle road to consider:

### ✅ Phase 1: Continue using Dart

* Maintain your current repo structure short term.
* Use the improved `y_extract_sailing_data.py` to generate centralized audit CSVs.
* Finish coverage, completeness, and quality assurance.

### ✅ Phase 2: Add JSON as a parallel output layer

* Start exporting finalized lessons/tools/paths to `.json` files per item.
* Gradually refactor your app to **support reading from JSON**, but don’t immediately remove Dart support.

### ✅ Phase 3: Transition core app logic

* Once your entire curriculum has JSON versions and the app reads them reliably, eliminate the Dart-encoded repos.

---

### 🛠 Bonus Option

Want to build a command like:

```bash
python3 convert_repos_to_json.py
```

...to auto-generate clean `lesson_x.json` files from your existing Dart files? I can help write that if you're ready to test a migration.

Let me know which way you’re leaning — I can support either path.



















You're absolutely right to pivot.

Your evaluation of the Dart-to-JSON transition is smart and strategic — especially the phased migration. JSON will make everything from content validation to AI-assisted editing **orders of magnitude easier**.

Here's a brief tactical evaluation of your plan, plus two strong enhancements to ensure your migration succeeds without introducing tech debt.

---

### ✅ What You Got Right

| ✔️ | Decision          | Why it’s right                                                |
| -- | ----------------- | ------------------------------------------------------------- |
| ✅  | Move to JSON      | Easier to introspect, QA, generate from tools, and keep clean |
| ✅  | Phase in support  | Avoids “big bang” rewrite risk                                |
| ✅  | Keep Dart for now | Gives flexibility while you validate JSON reads and formats   |

---

### 🔧 My Suggestions

#### 1. **Use One JSON File per Object**

Instead of one massive file, do:

```
assets/curriculum/lessons/lesson_dock_1.00.json
assets/curriculum/parts/part_hull_1.json
assets/curriculum/tools/tool_procedure_engine.json
```

This:

* Keeps Git diffs readable and modular
* Makes per-item editing or translation much easier
* Helps organize assets by namespace and topic

---

#### 2. **Define a Simple Schema + Linter Script**

Create a `lesson.schema.json` (or just a commented example) that defines:

```json
{
  "id": "lesson_dock_1.00",
  "title": "L1: Handling Dock Lines",
  "content": [
    { "type": "text", "value": "Learn how to..." },
    { "type": "image", "value": "assets/images/fallback.jpeg" }
  ],
  "keywords": [],
  "isPaid": false,
  "flashcards": [
    {
      "id": "...",
      "title": "...",
      "sideA": [...],
      "sideB": [...],
      "showAFirst": true
    }
  ]
}
```

Then build `validate_json_repos.py` that:

* Checks required fields are present
* Warns if `id` doesn't match filename
* Validates `content[].type` is one of `text`, `image`, `heading`, etc.

---

### 🏁 Recommended Next Step

Ask me to generate a `convert_dart_to_json.py` that:

* Parses existing Dart repositories
* Outputs clean, per-object JSON files
* Preserves content, IDs, titles, flashcards, etc.

You could run it repo-wide with:

```bash
python3 convert_dart_to_json.py
```

Let me know and I’ll prep it with minimal dependencies and good logging.

---

You’ve got the right instinct here — JSON is the future of your curriculum backend. And I’m ready to help make the transition sharp and smooth.
















NEXT DISCUSSION several weeks later:

Yes, I remember that discussion well. You've transitioned your lesson content from Dart class-based repositories to a more streamlined JSON format that mirrors the structure of your lessons, parts, tools, flashcards, and paths. You're now revisiting **how to best manage this content across the dev team**, ensure **consistency and correctness**, and provide a **bird's-eye view** of what’s included and how it interrelates.

Let’s walk through:

---

### ✅ GOAL RECAP

You want a system where:

1. All **content is clearly structured** and viewable/editable by non-developers.
2. The team can **verify required fields**, **track interlinking** (e.g., paths → lessons → flashcards), and **detect duplicates**.
3. Content updates can be made safely and re-integrated into the app.
4. You can eventually **automate validation** and **code generation** from this single source of truth.

---

## ✅ Why JSON Works Well for This

### ✅ Pros

| Feature                      | Benefit                                                                          |
| ---------------------------- | -------------------------------------------------------------------------------- |
| **Human-readable**           | Developers and non-devs (using spreadsheet editors or visual tools) can view it. |
| **Structured**               | JSON naturally maps to objects like `Lesson`, `PathItem`, `Flashcard`.           |
| **Tool-friendly**            | Easily imported/exported from Excel, Google Sheets, or programmatic tools.       |
| **Version-controllable**     | Stored in Git; diffs show exactly what changed.                                  |
| **Validatable**              | You can build a schema or script to validate required fields (like `id`).        |
| **Interlinking is explicit** | A `path` references lesson `id`s; no magic or implicit wiring.                   |
| **Flexible for scaling**     | New types (e.g. “quizzes” or “drills”) can follow same pattern.                  |

### ❌ Cons

| Issue                          | Mitigation                                                                     |
| ------------------------------ | ------------------------------------------------------------------------------ |
| **Manual sync risk**           | Use a validation script to check if every `id` used in a path actually exists. |
| **Harder for rich UX editing** | You might need to build a lightweight internal CMS or Google Sheet bridge.     |
| **No runtime enforcement**     | Until imported into app or validated via script, errors may sneak in.          |

---

## ✅ Best Practice Structure (JSON Directory Layout)

```
/content/
  lessons/
    lesson_safe_1.00.json
    lesson_dock_1.00.json
  parts/
    part_knots_1.00.json
  tools/
    tool_vhf_1.00.json
  paths/
    path_competent_crew.json
```

Each file follows a strict format, e.g.:

### 📄 `lesson_safe_1.00.json`

```json
{
  "id": "lesson_safe_1.00",
  "title": "Packing List and Clothing",
  "content": [
    {
      "type": "text",
      "content": "What to pack for sailing..."
    },
    {
      "type": "image",
      "content": "assets/images/safety.png"
    }
  ],
  "keywords": ["gear", "clothing"],
  "isPaid": false,
  "flashcards": [
    {
      "id": "flashcard_lesson_safe_1.00",
      "title": "Packing List",
      "sideA": [{"type": "text", "content": "What should you pack?"}],
      "sideB": [{"type": "text", "content": "Layers, waterproofs, and safety gear."}],
      "isPaid": false
    }
  ]
}
```

### 📄 `path_competent_crew.json`

```json
{
  "id": "path_competent_crew",
  "title": "Competent Crew",
  "description": "Introductory lessons for crew members.",
  "items": [
    {"pathItemId": "lesson_safe_1.00"},
    {"pathItemId": "lesson_dock_1.00"}
  ]
}
```

---

## ✅ Workflow: Dev Team + Content Team Collaboration

| Step | Role         | Tool         | Output                                         |
| ---- | ------------ | ------------ | ---------------------------------------------- |
| 1    | Content team | Excel/Sheets | Edits lessons/paths using structured rows      |
| 2    | Script       | Python       | Converts spreadsheet to JSON files             |
| 3    | Validation   | Script       | Ensures IDs are unique and referenced properly |
| 4    | Dev team     | Git          | Uses JSON in app repo                          |
| 5    | App          | Dart         | Loads JSON via repository pattern              |

---

## ✅ Key Checks for Consistency

You’ll want a validator (we can write a simple Python script or use a JSON Schema approach) that checks:

| Rule                          | Description                                                                  |
| ----------------------------- | ---------------------------------------------------------------------------- |
| **ID Uniqueness**             | No two items should share the same `id`.                                     |
| **Required Fields**           | All lessons must have `id`, `title`, `content`, etc.                         |
| **Path ID Validity**          | Every `pathItemId` must correspond to an existing lesson, part, or tool.     |
| **Flashcard ID Compliance**   | Each flashcard must have a valid `id`, `title`, and both sides.              |
| **No orphaned lessons/tools** | Lessons/tools should either be in a path or explicitly marked as standalone. |

---

## ✅ Recommendation: Master Spreadsheet

Use a **master spreadsheet** to track:

| ID                 | Type   | Title                     | Keywords       | In Path               | Flashcards |
| ------------------ | ------ | ------------------------- | -------------- | --------------------- | ---------- |
| lesson\_safe\_1.00 | Lesson | Packing List and Clothing | gear, clothing | path\_competent\_crew | ✅          |
| tool\_vhf\_1.00    | Tool   | VHF Radio                 | communication  | path\_tools           | ❌          |

Then script the conversion to JSON from CSV using a Python script.

---

### ✅ Summary

JSON **is the right move** for:

* Transparency across teams
* Tooling support (editors, validation, import/export)
* Avoiding code duplication and manual syncing

But to truly scale it:

1. Build a validator.
2. Maintain a master sheet.
3. Automate CSV → JSON and JSON → CSV as needed.
4. Enforce ID conventions across all content.

Would you like me to:

* Generate a sample validator script?
* Draft a schema for the spreadsheet?
* Show the CSV→JSON pipeline in action?

Let me know where you want to pick up.




















Yes, you can absolutely implement a **gradual migration strategy** from Dart-based repositories to JSON-based content **without breaking the app**. The key is to support **both formats side by side** during the transition period and progressively shift your data source logic to favor JSON when available.

Here's a step-by-step migration plan with best practices:

---

## ✅ High-Level Strategy: "Dual-Format Fallback"

### ➤ Key Principle:

> **If a lesson/path/tool exists as JSON, use it. Otherwise, fall back to the Dart repository.**

---

## ✅ Step-by-Step Migration Plan

### **Step 1: Create a central content loader**

Create a `ContentLoader` class with static methods like:

```dart
class ContentLoader {
  static Future<Lesson?> loadLessonById(String id) async {
    final jsonLesson = await JsonLessonRepository.loadLesson(id);
    if (jsonLesson != null) return jsonLesson;

    return LegacyLessonRepository.findById(id); // fallback to Dart
  }
}
```

This will:

* Check for a JSON lesson first.
* Fallback to the Dart repository if the JSON file doesn’t exist.

You can repeat the same for tools, parts, and paths.

---

### **Step 2: Convert a few lessons to JSON**

* Pick 2–3 simple lessons and move them to `assets/lessons/`.
* Write corresponding `.json` files.
* Confirm they render correctly in-app via your `ContentLoader`.

**Tip:** Start with `isPaid: false` lessons with no flashcards.

---

### **Step 3: Update your `PathItem` logic**

If your paths are still defined in Dart, update your `PathItem` logic to load lessons via `ContentLoader`. That way, they will "just work" whether the content is in Dart or JSON.

```dart
Future<Widget> buildLesson(String lessonId) async {
  final lesson = await ContentLoader.loadLessonById(lessonId);
  if (lesson == null) return NotFoundWidget();
  return LessonScreen(lesson: lesson);
}
```

---

### **Step 4: Slowly phase out Dart files**

* Once a JSON file is working, **delete** its Dart counterpart.
* Validate using your test suite (or a custom script).
* Gradually convert other lessons, parts, tools, and paths.

---

### **Step 5: Final cleanup**

* Remove fallback Dart repositories once 100% converted.
* Remove any legacy code paths (e.g., `LegacyLessonRepository`).
* Convert all paths to JSON.
* Validate app state with tests, QA, or user testing.

---

## ✅ Benefits of This Strategy

| Advantage                          | Explanation                                        |
| ---------------------------------- | -------------------------------------------------- |
| **Zero app breakage**              | JSON loads only replace Dart content when present. |
| **Test-as-you-go**                 | You can validate correctness lesson-by-lesson.     |
| **Quick rollback**                 | If a JSON file causes problems, just delete it.    |
| **No need to refactor core logic** | Only the loader logic changes initially.           |
| **Team-friendly**                  | Content and dev teams can move at their own pace.  |

---

## ✅ Optional Enhancements

* Use a **global registry** or cache to pre-load all available JSON files at startup for performance.
* Add a **validation screen** in dev builds that checks:

  * Missing `id`s
  * Missing referenced lessons
  * Duplicates across JSON and Dart
* Integrate **CSV → JSON tools** into your team’s pipeline.

---

## ✅ TL;DR

Yes — you can **safely implement JSON gradually** using a hybrid system:

* Build a `ContentLoader` that first checks for JSON.
* Fallback to legacy Dart repos.
* Replace lessons one by one.
* Remove legacy Dart once everything is migrated.

Would you like a concrete code sample of a `ContentLoader`, or a sample Flutter integration of this dual-source logic?



























Thanks for uploading your project structure and repositories. Based on a **comprehensive analysis** of the files you've shared, here's a complete review of your current architecture, migration readiness, and an implementation plan for a **safe, progressive shift to JSON-based content**.

---

## ✅ Summary of Findings

### 🧱 Current State

* Lessons, parts, paths, and tools are **defined via Dart static repositories** (e.g., `lesson_teamwork_repository.dart`, `competent_crew_repository.dart`) in `lib/data/repositories/`.
* Each repository returns a list of items (e.g., `List<Lesson>`), wired together via IDs for paths and flashcards.
* Render logic is separate and seems to rely on `PathItem`, `RenderItem`, etc., to dynamically route to correct screen/widget.
* You’ve already started JSON integration for tools (`tool_colregs_repository_expanded.json`) — great!

---

## ✅ Migration Compatibility

Yes — **your architecture is well-suited to dual-source loading**. Here’s why:

| Component                       | Supports Hybrid Mode? | Comments                                                                                                              |
| ------------------------------- | --------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `Lesson`, `Tool`, `Part` models | ✅                     | All defined in `lib/data/models/` as plain Dart objects, easily populated from JSON.                                  |
| Screens and rendering           | ✅                     | They depend on `Lesson`/`Part` instances, not their source — perfect for gradual migration.                           |
| Navigation logic                | ✅                     | Relies on `lessonId`/`pathItemId`, so can resolve dynamically via loader.                                             |
| Flashcard integration           | ✅                     | Flashcards are embedded in lessons, and modeled consistently.                                                         |
| Repository usage patterns       | ✅                     | You’ve modularized by topic (e.g., `lesson_knots_repository.dart`), which makes them easy to phase out incrementally. |

---

## 🔍 Areas Needing Attention

| Area                              | Concern                                       | Recommendation                                                                                 |
| --------------------------------- | --------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| 🔧 `lesson_repository_index.dart` | Hardcoded list of all lesson repos            | Refactor to allow optional JSON override on load                                               |
| 🧩 `path_repository_index.dart`   | Uses static Dart paths only                   | Replace with loader that can read JSON path definitions too                                    |
| 🧪 Flashcard lookup               | Some flashcards exist in their own files      | Normalize all flashcards to live inside lesson JSON objects (or reference lesson ID if needed) |
| 🚥 `RenderItem` system            | Some routing may assume lessons exist in Dart | Update routing to go through new `ContentLoader` to resolve item by ID                         |

---

## 🧰 Design: `ContentLoader` Pattern

```dart
class ContentLoader {
  static Future<Lesson?> loadLessonById(String id) async {
    // Try JSON first
    final jsonLesson = await JsonLessonRepository.loadById(id);
    if (jsonLesson != null) return jsonLesson;

    // Fallback to legacy Dart repos
    return LegacyLessonRepository.findById(id);
  }

  static Future<List<PathItem>> loadPathById(String id) async {
    // Try JSON path with IDs
    final jsonPath = await JsonPathRepository.loadById(id);
    if (jsonPath != null) return jsonPath.items;

    // Fallback
    return LegacyPathRepository.findById(id)?.items ?? [];
  }
}
```

You’d implement similar loaders for tools, parts, flashcards.

---

## ✅ Recommended Migration Plan

### **🟢 Phase 1: Foundation (No app breakage)**

1. **Create `/assets/json/lessons/`, `/parts/`, `/tools/`, `/paths/`** structure.
2. Build `JsonLessonRepository`, `JsonPartRepository`, etc. that read `.json` files from `assets/`.
3. Add `ContentLoader` class that always tries JSON first.
4. Update all screens that accept an `id` to use `ContentLoader.loadLessonById(...)`.

✅ At this point, the app behavior is unchanged unless a JSON file is present — 100% safe.

---

### **🟡 Phase 2: Progressive Migration**

5. Convert 1–2 lessons to JSON format and test loading.
6. Delete corresponding Dart entry from the lesson repo file (e.g., `lesson_safe_1.00` from `lesson_safety_repository.dart`).
7. Validate that lesson appears in path via `ContentLoader`.
8. Repeat for a few more lessons, then parts, tools, and flashcards.

✅ Paths can still point to both JSON and Dart items.

---

### **🔴 Phase 3: Sunset Legacy**

9. Once all lessons/parts/tools/paths are migrated:

   * Delete old Dart repositories.
   * Remove `Legacy*Repository` classes.
10. Optionally write a dev-only screen or script to:

* List all known items by ID.
* Report duplicates or unresolved references.

✅ Now your entire content stack is JSON-driven and versionable.

---

## 🛠 Next Steps

Would you like me to provide:

* ✅ `ContentLoader` Dart implementation stub?
* ✅ A sample `JsonLessonRepository` implementation?
* ✅ JSON schema validator / CLI tool?
* ✅ CSV-to-JSON converter workflow to aid team content editing?

You’ve laid a great foundation — this plan is entirely feasible, safe, and aligns with your goals of maintainability, transparency, and team collaboration. Let me know which piece you want first.













































Absolutely — here's a full recap of what we’ve accomplished, the architectural decisions made, and the proposed next steps to complete your transition from Dart-based lesson repositories to JSON-based content that’s scalable, maintainable, and editor-friendly.

---

## ✅ **GOAL**

To replace your hard-coded Dart repositories with a system that:

* Loads lessons, tools, and parts from structured **JSON files**
* Supports **editor-friendly CSV workflows**
* Ensures **interlinking and consistency**
* Allows a **safe, gradual migration**
* Remains fast, modular, and developer-onboardable

---

## ✅ **PROGRESS + DECISIONS MADE**

### ✅ 1. 🔄 **JSON Directory Format Chosen**

We decided to store one lesson per file, inside topic folders like:

```
assets/json/lessons/
├── docking/
│   ├── lesson_dock_1.00.json
│   ├── lesson_dock_1.10.json
│   └── ...
```

**🧠 Rationale:**
This matches your existing mental model (e.g. `lesson_docking_repository.dart`) and scales without cognitive overload. Folders = topics. Files = individual lessons.

---

### ✅ 2. 📘 **Index File for Dev/Editing**

Each folder contains an `index.json` and optionally a `.csv` for easier human use.

**🧠 Rationale:**
Facilitates navigation, editing, filtering, and inclusion in learning paths without opening 30+ files.

---

### ✅ 3. 🔍 **Hybrid Loader Implemented**

Your new `ContentLoader` will:

* First try to load a lesson from its JSON file.
* Fallback to the Dart-based `LessonRepositoryIndex` if the JSON doesn’t exist.

✅ This means you don’t have to refactor all at once.

---

### ✅ 4. 🧪 Test Widget Built

You now have a working test UI that:

* Loads any lesson by ID
* Renders its blocks via `ContentBlockRenderer`

✅ Confirmed JSON integration works in-app!

---

### ✅ 5. 🧰 Supporting Tools Delivered

You now have:

| Tool                                                                       | Purpose                                                                            |
| -------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| [`dart_to_json_converter.py`](sandbox:/mnt/data/dart_to_json_converter.py) | Convert Dart lesson definitions into JSON                                          |
| [`json_csv_converter.py`](sandbox:/mnt/data/json_csv_converter.py)         | Convert JSON to/from a CSV index                                                   |
| [`json_lesson_validator.py`](sandbox:/mnt/data/json_lesson_validator.py)   | Check that all JSONs meet spec and have valid IDs                                  |
| [`json_to_dart_converter.py`](sandbox:/mnt/data/json_to_dart_converter.py) | Rebuild Dart `Lesson(...)` objects from JSON (for fallback, backup, or inspection) |

---

## 📋 **OUTSTANDING QUESTIONS (PAST + PRESENT)**

Here’s a list of questions you’ve been asked during this process that may still need action or decision:

### 🧩 Structure

* ❓ Do you want to organize *tools* and *parts* the same way as lessons (one per file, per folder, with index)?
* ❓ Should all content types (lessons, parts, tools) follow identical JSON schemas for easier reuse?
* ❓ Do you want a master index across all modules for quick global search?

---

### 🛠 Development & Editing Workflow

* ❓ Would you like a **combined JSON + CSV editor GUI** in Flutter/Web for lesson authors/editors?
* ❓ Do you want a script to **auto-generate `index.json` files** on save?
* ❓ Would you like CLI or IDE plugins to catch ID mismatches automatically?

---

### 🔜 Next Logical Steps

Here’s how I recommend proceeding in order of importance:

1. ✅ **Finish converting** all current Dart repositories into structured JSON files (`lessons`, `parts`, `tools`)

   * Use the Python converter if helpful
   * Store each set in its folder (`docking/`, `knots/`, `emergencies/`, etc.)

2. 🧪 **Validate** them using `json_lesson_validator.py`

   * This ensures no bad files get introduced before production use

3. ⚙️ **Gradually remove Dart modules** one-by-one when their content is fully migrated

4. 🔍 **Improve learning path/flashcard integration** by indexing JSON content with:

   * `id`, `title`, `description`, `tags`, `pathIn` fields

5. 📈 Optionally: Build a simple **in-app or web-based JSON/CSV lesson editor** if editing becomes too manual

---

## ✅ YOU ARE HERE

✅ JSON system proven
✅ Dart fallback working
✅ CSV, validator, and converter tools delivered
🧭 Ready to scale with confidence

---

Would you like me to:

1. Start converting another one of your Dart repositories?
2. Help build a central index or search system?
3. Scaffold a JSON-based **tool** or **part** repository next?

Let’s keep going while the pipeline is hot.





































Perfect — I’ve recorded all your decisions and ideas in a persistent list, so we can revisit or act on them at any time. Here's a concise summary of where we stand and what’s queued:

---

## ✅ CURRENT STATUS

**What’s live:**

* JSON lesson loading works via `ContentLoader`
* Dart fallback is wired in (`LessonRepositoryIndex`)
* Docking lessons are fully converted to JSON and ready
* Test widget verifies JSON load + render

**What to do next:**

* 🔍 Manually test both:

  * A standalone docking lesson via `TestJsonLessonViewer`
  * Any docking lesson **referenced from a learning path**

If the latter works, your fallback+JSON blend is proven.

---

## 📋 MASTER LIST: EXPANSION IDEAS (NOT YET DONE)

You’ve approved or expressed interest in these:

### 🧩 Structure & Content Architecture

* [ ] Apply **same JSON/folder/index structure** to tools and parts
* [ ] Use **shared schema** formats where practical
* [ ] Build a **master index across all modules** for global search

### 🛠 Editing & Dev Tools

* [ ] Create a **GUI JSON + CSV editor** (in Flutter/Web)
* [ ] Possibly implement **auto-generated `index.json`** on file save (e.g., with a Git hook or CLI tool)
* [ ] Add a **CLI/IDE validation tool** to flag ID or schema issues before commit

### 🚀 Migration & Features

* [ ] Convert another Dart lesson repository to JSON
* [ ] Scaffold the first JSON-based **tool** repository
* [ ] Scaffold the first JSON-based **part** repository
* [ ] Build a **search/index feature** using all modules (e.g., by `id`, `title`, `tags`, etc.)

---

Whenever you're ready, we can:

* Validate those docking lessons together
* Resume the next conversion
* Build any of the dev tools above

Want help writing a quick test route for a lesson in the learning path context next?
