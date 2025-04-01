Perfect — thanks for clarifying. Here's your **📋 Major Refactor Progress Tracker** for the navigation overhaul and downstream cleanup:

---

### ✅ PHASE 1: Navigation Refactor – `/content` Route

1. **[✅] Implement mixed content support via `/content` route**
   - Use `sequenceIds` + `buildRenderItems()` + `ContentScreenNavigator`
   - Screens rendered: `ContentDetailScreen` or `FlashcardDetailScreen`

2. **[✅] Refactor `ContentScreenNavigator` to support RenderItem + index tracking**
   - Show proper screen based on RenderItemType (lesson, part, tool, flashcard)
   - Handle `onBack`, `onPrevious`, `onNext`
   - Insert full `logger.i` diagnostics

3. **[✅] Update `/content` route in `app_router.dart`**
   - Extract extras: `sequenceIds`, `startIndex`, `branchIndex`, `backDestination`, `backExtra`
   - Remove legacy `sequenceTitles` + `contentMap` usage
   - Build `renderItems` using helper and route to `ContentScreenNavigator`

4. **[✅] Refactor all navigation entry points (3 total):**
   - [✅] `LessonItemScreen` – uses `sequenceIds` now
   - [✅] `PartItemScreen` – uses `sequenceIds` now
   - [✅] `ToolItemScreen` – uses `sequenceIds` now

---

### 🧹 PHASE 2: Remove Legacy Navigation Logic

5. **[✅] Remove legacy `sequenceTitles` and `contentMap` usage**
   - From all `ItemScreen`s (lesson, part, tool)
   - Confirmed navigation uses only `sequenceIds`

6. **[✅] Remove legacy parameters from `ContentScreenNavigator`**
   - Old `renderItems` parameter removed

7. **[✅] Confirm `ContentDetailScreen` no longer used directly**
   - All content now routed via `/content` and rendered via `ContentScreenNavigator`

8. **[✅] Confirm no direct pushes to `ContentDetailScreen`**
   - All `context.push('/content')` calls checked

---

### 🚧 PHASE 3: Repository Consistency + Validation

9. **[✅] Validate all `getLessonById`, `getPartById`, `getToolById` usage**
   - Returns null for invalid IDs → caught by `getContentObject()`
   - Log warnings for unknown or missing content

10. **[🟡] Add missing `getFlashcardById()` if needed**
   - [🔍] Currently only used during `RenderItemType.flashcard`
   - Confirm each repository implements it

---

### 🔜 PHASE 4: Final Cleanups + Improvements

11. **[🟡] Move `buildRenderItems()` and `getContentObject()` to a shared helper file**
   - Possibly split: `render_item_helpers.dart` → `content_helpers.dart` + `flashcard_helpers.dart`

12. **[🟡] Confirm or remove old `contentMap` fields from any unused files**
   - Search entire repo for `.push('/content', extra: { 'contentMap'... })`

13. **[🟢] Add unit tests or integration test scaffolds for `/content` navigation**
   - Useful for debugging regression in learning paths, tools, parts, and flashcards

---

Let me know if you'd like to start with item **11** or go straight to **13** for forward momentum.