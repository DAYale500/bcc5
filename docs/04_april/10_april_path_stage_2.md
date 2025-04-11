Perfect — I’ve locked in those preferences. Here’s the revised plan based on your clarified direction for each screen type.

---

## ✅ Confirmed Standards

### 1. **PathChapterScreen**
- **AppBar title** → ✅ `"Orientation"` or similar path name
- **Subtitle / Body** → ✅ Already matches expectations
- ✅ No changes needed here unless new styling is desired

### 2. **PathItemScreen**
- **AppBar title** → ✅ Use learning path name (e.g. `"Orientation"`)
- **Subtitle** → ✅ Chapter title (e.g. `"Prepare Beforehand"`) followed by static instructions (e.g. `"Tap a topic to begin"`)
- ✅ Confirmed structure and layout good
- 🔧 *Ensure title uses `.toTitleCase()` and fallback gracefully if `pathName` is null*

### 3. **DetailScreens from Path**
- ❌ Do *not* modify AppBar title or subtitle
- ✅ Instead, add a **progress strip** below the AppBar:
  - Displays the full learning path name
  - Serves as a future progress bar container
  - Should be styled to allow dynamic background and text color based on progress
    - e.g. *Accomplished*: red background with white text  
    - e.g. *Yet to accomplish*: white background with red text

---

## 🧱 Updated Action Plan: Stage 2 for Path Branch

### 🔹 Refactor Path DetailScreens (Lesson, Part, Tool, Flashcard)
Each will:
- ✅ Keep current title + subtitle
- ➕ Add a colored strip underneath AppBar:
  ```dart
  Container(
    color: AppTheme.primaryRed,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Center(
      child: Text(
        pathName.toTitleCase(),
        style: AppTheme.scaledTextTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  ```
  - 🔧 Dynamically style this container in the future (progress bar, text shifts)

---

## ✅ Next Step
Which detail screen from the path branch should we start with?
- [ ] LessonDetailScreen (Path)
- [ ] PartDetailScreen (Path)
- [ ] ToolDetailScreen (Path)
- [ ] FlashcardDetailScreen (Path)

Or would you like me to refactor all 4 in one pass for your review?