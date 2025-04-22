Perfect — your comments refine the understanding beautifully. Let's consolidate everything into a **canonical UX flow and architecture spec** for the Learning Path branch, incorporating your notes and shaping this into something we can systematically audit, refactor, and enhance.

---

## 🧭 Finalized Learning Path UX + Architecture Spec

---

### ✅ Step 1: Entry Points — Landing Screen

From the **LandingScreen**, users can pick from:

- **“Competent Crew”** → beginner course
- **“Knock the Rust Off”** → one of 3 advanced refresher courses

➡️ Both options navigate to:

```
/learning-paths/:pathName → PathChapterScreen
```

---

### ✅ Step 2: Chapter Screen → PathChapterScreen

**User actions on this screen:**

| Action | Behavior |
|--------|----------|
| **Start** | Goes directly to the first item of the first chapter in the repository (e.g. `CompetentCrewRepository`) |
| **Continue** | Goes directly to the last item the user viewed but didn’t finish (`ResumeManager`) |
| **Tap a Chapter** | Opens `PathItemScreen` for that chapter |

➡️ Start and Continue should **skip `PathItemScreen`** and go straight to a detail screen (agreed).

---

### ✅ Step 3: Chapter Contents → PathItemScreen (optional)

Only used when the user explicitly selects a chapter.

Displays all items in that chapter:
- Mixed `RenderItem` types (lesson, tool, flashcard, part)
- User can tap to go to the corresponding detail screen

---

### ✅ Step 4: Item View → *DetailScreen

This is a type-specific screen (`LessonDetailScreen`, `PartDetailScreen`, etc.).

All must support:

| Behavior | Detail |
|----------|--------|
| 🔁 `DetailRoute.path` | Enables chapter/sequence awareness |
| 📍 `ResumeManager.saveResumePoint(...)` | On entry |
| ⬅️ Previous / ➡️ Next | Moves to adjacent item or next chapter |
| ⛔ End of Chapter | If no next chapter, show modal (currently only in `LessonDetailScreen`) |
| 📤 Back | Returns to `PathItemScreen` or `PathChapterScreen`, depending on origin |

---

## 🧩 Detail: Data Flow, Transitions, and Navigation

| Context | Destination | `backDestination` | `backExtra` |
|---------|-------------|-------------------|-------------|
| Landing → PathChapterScreen | `/learning-paths/:pathName` | N/A | N/A |
| PathChapterScreen → Start | `/<type>/detail` | `/learning-paths/:pathName` | `{ pathName, chapterId }` |
| PathChapterScreen → Continue | `/<type>/detail` | `/learning-paths/:pathName` | `{ pathName, chapterId }` |
| PathChapterScreen → Chapter | `/learning-paths/:pathName/items` | `/learning-paths/:pathName` | `{ pathName }` |
| PathItemScreen → Detail | `/<type>/detail` | `/learning-paths/:pathName/items` | `{ pathName, chapterId }` |
| Detail → Back | Uses `backDestination` and `backExtra` | — | — |

---

## 🔐 Architectural Rules Recap

- **No GlobalKeys** in `.extra` or `backExtra`
- Use `.go(...)` or `.push(...)` with:
  - `transitionKey: String`
  - `slideFrom: SlideDirection`
  - `transitionType: TransitionType`
- All `DetailScreens` implement `DetailRoute.path` behavior
- All screen wrappers use `MainScaffold(branchIndex: 0)`

---

## 🧭 Next Step Options

We can now proceed in one of three ways:

### **Option 1: Start at the Top**
- Audit `PathChapterScreen` for:
  - Internal key ownership
  - `Start` and `Continue` logic correctness
  - Transitions to detail screens

### **Option 2: Focus on Middle Layer**
- Refactor `PathItemScreen` to:
  - Match newer navigation architecture
  - Use transitionKey + backExtra cleanup
  - Clean layout logic

### **Option 3: Bottom-Up Verification**
- Audit and enhance each `DetailScreen` for:
  - PathMode logic
  - ResumeManager save
  - Prev/Next/Next Chapter handling

---

Would you like to start with **Option 1** (`PathChapterScreen` audit and polish), or go a different route?