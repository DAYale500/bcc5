Great — you're shifting focus to the **Learning Paths** system, and want to build out UI navigation and structure for the upcoming **"Competent Crew"** experience.

---

### ✅ Summary of Request

#### 🎯 **Goal:**
Introduce a new *Learning Path system*, starting with the **Competent Crew** path, and update the home screen to surface this feature.

---

### 🧱 Tasks Breakdown

#### 1. 🏠 **Update `HomeScreen`** to show two new buttons:
- **Tour**: Launches a wizard/tutorial experience (placeholder for now).
- **Competent Crew**: Opens the path system (starts with `PathChapterScreen`).

---

#### 2. 📚 **Implement the Learning Path navigation flow**  
Mirroring the existing lesson and part structure:
```
HomeScreen → PathChapterScreen → PathItemScreen → ContentDetailScreen
```

#### 3. 📁 **Create the necessary screens and logic:**

- **`PathChapterScreen`**  
  - Shows buttons for each chapter in the `competentCrewRepository`
  - Navigation similar to `LessonModuleScreen` or `PartZoneScreen`

- **`PathItemScreen`**  
  - Shows buttons for each item in the selected chapter (lesson, part, flashcard, etc.)
  - Navigation similar to `LessonItemScreen` or `PartItemScreen`

- **`ContentDetailScreen`**  
  - Already built — reused for displaying path item content

---

#### 4. 📦 **Data Structure Requirements**
You'll need a new repo:
```dart
competentCrewRepository = List<PathChapter>
```
Each `PathChapter` contains:
```dart
class PathChapter {
  final String title;
  final List<PathItem> items;
}
```

And a `PathItem` contains:
```dart
class PathItem {
  final String id; // could be lesson_x, part_x, etc.
  final String title;
  final List<ContentBlock> content;
  final List<Flashcard> flashcards;
}
```

The `PathItem` model will reuse the already-updated content and flashcard structures you've established for lessons and parts.

---

Would you like to proceed by building:
1. The **HomeScreen UI update** first?  
2. The **Data model** (`PathChapter`, `PathItem`, etc.)?  
3. The **Path screens** (`PathChapterScreen`, etc.)?

Let me know the order you'd prefer to tackle them in.



Perfect. Here's a summary of what we'll do next to start wiring up the learning path flow:

---

### ✅ Step 1: Define the Learning Path Models

We’ll introduce two models that mirror how `Lesson` and `PartItem` currently work, but structured for paths:

#### `LearningPathChapter` (equivalent to a module or part zone)
- `id`: Unique chapter identifier (e.g. `"ch1"`)
- `title`: User-facing title (e.g. `"1: Prepare in Advance"`)
- `items`: List of `PathItem`s for this chapter

#### `PathItem` (analogous to Lesson or Part within the path)
- `referenceId`: e.g. `"lesson_dock_1.00"`, `"part_deck_3.00"`, or `"flashcard_lesson_emer_2.00"`
- Eventually we may add metadata (e.g. title override, isCompleted, notes, etc.)

---

### ✅ Step 2: Refactor `competent_crew_repository.dart`
- Use `LearningPathChapter` and `PathItem` models in a structure compatible with BCC5
- This will feed into our new `PathChapterScreen` and `PathItemScreen` UIs

---

### ✅ Step 3: Add PathChapterScreen
- Similar to `LessonModuleScreen`
- Lists chapters
- Taps push to `/path/items` with chapter id or object in `extra`

---

### ✅ Step 4: Add PathItemScreen
- Similar to `LessonItemScreen` or `PartItemScreen`
- Displays items inside the chapter
- Taps navigate to `ContentDetailScreen` using the same `ContentScreenNavigator` logic

---

Would you like me to go ahead and define the two new models (`LearningPathChapter`, `PathItem`) now?