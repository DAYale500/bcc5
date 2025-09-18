# Lesson Studio — Future To-Do Plan (Authoring App)

## 1) Goal & Non-Goals

**Goal:** A separate, laptop-friendly authoring tool to create/edit lessons/parts/tools with a live preview that mirrors the BCC5 app, then export clean JSON for injection into the app.

**Non-Goals (for MVP):**

* No in-app editing in the learner app.
* No multi-user collab/auth; local only.
* No backend CMS (can be added later).

---

## 2) MVP Feature Checklist

* [ ] **Split view**: left = editor, right = live preview matching `LessonDetailScreen` layout.
* [ ] **Add/reorder content blocks**: `text` and `image` types.
* [ ] **Flashcard editor**: title + A/B sides (text), show-A-first, paid toggle.
* [ ] **Module/lesson navigator**: sidebar list (module → lessons).
* [ ] **JSON export**: produces current app schema (`{ module, lessons: [...] }`) with **schema version tag**.
* [ ] **Import JSON**: load existing module JSON and round-trip edits.
* [ ] **Local autosave drafts** (e.g., `~/.bcc5_studio/drafts/`).
* [ ] **Validation**: required fields, duplicate IDs, missing images.

**Nice-to-have (post-MVP):**

* [ ] CSV importer (your authoring spreadsheet → Studio).
* [ ] Image helper (drag-drop, copy to `assets/images/`).
* [ ] Download file (web build) / Save As (desktop).
* [ ] Multi-module packaging/export.

---

## 3) Schema Versioning Strategy

* Embed at top level:
  `{"schemaVersion": 1, "module": "docking", "lessons": [...] }`
* **Adapter registry** in Studio:

  * `v1 ↔ internal model` (MVP)
  * Future: `v2 → v1` (down-convert) or `v1 → v2` (up-convert).
* Keep an **internal canonical model** (`AuthorLesson`, `AuthorFlashcard`, `AuthorBlock`) separate from on-disk schema; mappers handle changes.

---

## 4) Data Model (internal)

```text
AuthorModule {
  id: string
  title?: string
  lessons: AuthorLesson[]
}

AuthorLesson {
  id: string
  title: string
  blocks: AuthorBlock[]        // ordered
  keywords: string[]
  isPaid: bool
  flashcards: AuthorFlashcard[]
}

AuthorBlock { type: 'text'|'image'; content: string }
AuthorFlashcard {
  id: string; title: string;
  sideA: string; sideB: string;
  showAFirst: bool; isPaid: bool
}
```

**Mappers**:

* `AuthorModule → AppJsonV1` and reverse.
* Keep them in `/lib/mappers/` with unit tests.

---

## 5) UX Layout

* **Left panel**:

  * Module/lesson list (search, add, duplicate).
  * Lesson meta (id, title, keywords, paid).
  * Reorderable **Blocks** list:

    * Each row: Type dropdown, TextField (multiline) or Image path field.
    * Add Text / Add Image, drag handle, delete.
  * **Flashcards**: collapsible card list with A/B text fields, toggles, reorder, add/delete.
* **Right panel (Preview)**:

  * Renders with **the same widgets** your app uses (`ContentBlockRenderer`, typography, spacing).
  * Preview updates live on edit.

---

## 6) Tech & Project Structure

* **Flutter desktop** (macOS/Windows) and **web** (Chrome).
* State mgmt: simple `ChangeNotifier` or Riverpod.
* File structure:

```
lib/
  main.dart
  studio_app.dart
  models/author_*.dart
  mappers/json_v1_mapper.dart
  editors/
    lesson_editor.dart
    flashcard_editor.dart
    blocks_editor.dart
  preview/lesson_preview.dart
  services/
    storage_service.dart    // local file pick/save, autosave dir
    image_helper.dart
  validators/lesson_validator.dart
```

---

## 7) Import/Export & Storage

**Import**

* JSON file → detect `schemaVersion` → use appropriate mapper.
* Normalize smart quotes and stray encodings.

**Export**

* Generate `{schemaVersion, module, lessons}` (V1).
* Options:

  * Copy to clipboard.
  * Save to a chosen path.
  * Web: trigger download.

**Autosave**

* On change (debounced), write draft JSON to `~/.bcc5_studio/drafts/<module>.json`.
* “Restore from autosave” prompt on open if diff exists.

---

## 8) Validation Rules (MVP)

* Unique `lesson.id` within module.
* `lesson.title` non-empty.
* Block list non-empty; each block has valid content.
* Each flashcard has Title, Side A, Side B.
* Image blocks reference an existing file (optional warning in MVP; strict in export).
* No duplicate `flashcard.id` within a lesson.

---

## 9) Image Handling

**MVP**: user provides asset paths (relative to BCC5 repo), preview attempts to load (ok if fails).
**Later**:

* Drag-drop image → copy into a configured `assets/images/` dir.
* Auto-rewrite path and maintain a media library list.

---

## 10) Integration with BCC5 App

* Agree a staging folder in learner app (e.g., `assets/json/lessons/<module>.json`).
* Keep `pubspec.yaml` asset glob (`assets/json/**`).
* Add a tiny **pre-commit script** (optional) to validate JSON against a JSON Schema before pushing.

---

## 11) Milestones & Timeboxes

**M1 – Skeleton (day 1–2)**

* Project bootstrapped, split UI, static preview stub, internal models.

**M2 – Editing Core (day 3–4)**

* Blocks editor (text/image, reorder).
* Flashcards editor.
* Live preview.

**M3 – I/O + Validation (day 5–6)**

* Import/export JSON (V1 mapper).
* Autosave drafts.
* Basic validator.

**M4 – Polish (day 7)**

* Usability (keyboard shortcuts, duplication, warnings).
* Web download; desktop save dialog.

**Stretch**: CSV import, image drag-drop pipeline, JSON schema tests.

---

## 12) Risks & Mitigations

* **Schema churn**: abstract with mappers + `schemaVersion`. Keep internal model stable.
* **Preview drift** from learner app: import and reuse the same render widgets where possible; otherwise snapshot styles (fonts/sizes) and track changes as a dependency.
* **Image paths**: clarify a single convention early; add warnings not hard errors in MVP.

---

## 13) Definition of Done (MVP)

* Can author a module with ≥5 lessons, mixed text/image blocks, and flashcards.
* Preview visually matches learner app well enough (spacing/typography).
* Exported JSON **loads in your app without code changes**.
* Import round-trips without data loss.
* Basic validation blocks bad exports.

---

## 14) Quick Start (later, when implementing)

1. `flutter create bcc5_lesson_studio`
2. Add packages (if using): `riverpod`, `file_picker`, `path_provider`.
3. Scaffold editors & preview; wire mappers.
4. Point Studio to a working module; export; run learner app to verify.

---

## 15) Parking Lot (future ideas)

* Parts/Tools authoring tabs (simpler schemas).
* Quiz/interactives as new block types.
* Theming sync from app (design token file).
* Git integration (commit message + write to repo path).
* Multi-module export bundle + index generator.

---

If you want, I can later turn this into a ready-to-run `main.dart` + skeleton files that compile and show the split view with fake data, and leave the mappers as TODOs.
