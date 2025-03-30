# 📘 Flashcard Architecture: Embedded by Source

## ✅ Overview

All flashcards in BCC5 are embedded directly within their source content. This ensures tight coupling, easier maintenance, and cleaner logic for both development and user experience.

---

## 🧠 Source of Truth

Flashcards live **inside** the model of their origin:

- Lessons → `LessonItem.flashcards`
- Parts → `PartItem.flashcards`
- Tools → `ToolItem.flashcards`

---

## ✅ Benefits

### 1. **Strong Referential Integrity**
Every flashcard is directly associated with a lesson, part, or tool — no broken links, no guessing.

### 2. **Zero Maintenance Headaches**
No need to update separate repositories when new content is added — just add flashcards inside the item.

### 3. **Improved Scaffolding UX**
Flashcards appear in the correct learning context — and can be grouped for review (by module, zone, etc.).

### 4. **Cleaner Developer Logic**
All related data lives in one place — easier to parse, debug, and extend.

---

## 🔁 Central Aggregation (Optional Utility)

We may include a single `flashcard_repository.dart` that aggregates all embedded flashcards via utility functions:

```dart
List<Flashcard> getAllFlashcards();
List<Flashcard> getFlashcardsForLesson(String lessonId);
List<Flashcard> getFlashcardsForPart(String partId);
