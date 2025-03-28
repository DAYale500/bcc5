Original:

# 🧭 BCC5 Guiding Principles & Architecture Overview

> _This document defines the structural, functional, and pedagogical principles of the BCC5 sailing education app. It acts as a single source of truth for developers, educators, and designers. All terminology is explicit. No feature or behavior is left to inference._

---

## 📖 App Philosophy

### 🧑‍🎓 From the User's Perspective
The user enters the app with a **learning goal**. The app supports them in:
- Following a **structured learning path** (scaffolded, progressive)
- Exploring content freely (modules, parts, flashcards, tools)
- Reviewing flashcards based on current topic or weakness
- Quickly accessing **emergency procedures** in real-time
- Retaining long-term knowledge with search, visuals, and references

### 👨‍💻 From the Developer's Perspective
The app is designed for:
- **Ease of content updates**: add/modify/remove a lesson/part/tool/flashcard in a single repository file
- **Data-driven navigation**: every screen is constructed from data, not hardcoded transitions
- **Expandable sequences**: floating point IDs allow seamless insertions (e.g. step 5.5)
- **Centralization**: each type of content lives in its own repository with a central index
- **All style elements (colors, themes, light/dark mode)** live in `AppTheme.dart` — never hard-coded elsewhere

---

## 🗃️ Core Knowledge Types

| Type            | Description                                   | Format/Display |
|-----------------|-----------------------------------------------|----------------|
| **Lesson**      | Conceptual instructional content              | Text/image blocks |
| **Part**        | Boat components with images & functions       | Text/image blocks |
| **Flashcard**   | Recall learning, tied to lesson or part       | Question/Answer |
| **ToolItem**    | Procedural, visual, heuristic, or reference aid | Varies by type |
| **LearningPath**| Structured sequence of lessons, parts, tools, and flashcards | Multi-type list |

---

## 🧱 Repository Organization

### 📦 Repository Matrix

| Type     | Count | Description |
|----------|-------|-------------|
| Lessons  | 9     | One per module/topic |
| Parts    | 5     | One per boat zone |
| Tools    | 6     | One per Toolbag category |
| Paths    | Variable | Each defines a progression |

### 📂 Index Structure

| Index File                     | Description                                  |
|--------------------------------|----------------------------------------------|
| `lesson_repository_index.dart` | Returns all lesson modules and items         |
| `part_repository_index.dart`   | Returns all zones and part items             |
| `toolbag_repository_index.dart`| Returns all toolbags and their items         |
| `path_repository_index.dart`   | Returns all learning paths and their items   |

Each index:
- Returns group names
- Provides item lists per group
- Allows lookup by ID (e.g. `lesson_dock_1.00`)
- Supports reverse lookup (e.g. `getModuleForLessonId(...)`)

---

## 🔠 ID Convention

All content items follow this structure:

```text
<type>_<group>_<order>
```

### Example:
```text
lesson_dock_1.00
```

| Segment      | Meaning                    |
|--------------|----------------------------|
| `lesson`     | Content type (`lesson`, `part`, etc.) |
| `dock`       | Group/module/zone/category |
| `1.00`       | Float order (for easy insertion) |

### ✅ Pros:
- Human-readable
- Searchable
- Stable for references and learning paths
- Float order allows inserting new content (e.g. `1.50`)

---

## 🧰 Tools: Toolbags Structure

The **Tools branch** contains six “Toolbags,” each with its own repository:

| Toolbag            | Description                                                | Example Content |
|--------------------|------------------------------------------------------------|------------------|
| **Procedures**     | Checklists, Troubleshooting, Emergency Playbooks           | MOB, Reefing     |
| **References**     | Radio, Flags, Charts, Terminology                          | VHF Channels     |
| **Calculators**    | Formulas, Conversions, Anchoring Ratios                   | Hull speed calc  |
| **Visual Aids**    | Symbols, Signals, Clouds, Navigation Markers              | Buoy shapes      |
| **Cognitive Aids** | Rules of Thumb, Heuristics, Scenario Walkthroughs         | “Red Right Returning” |
| **Ditch Bag**      | Miscellaneous quick-access reference                      | Pre-departure steps |

### ✅ Editable Tool Items
Some tools (like checklists) must support user personalization:

```dart
class ChecklistStep {
  final String text;
  final bool isChecked;
  final bool isHidden;
}
```

These are stored locally and persist user edits (add, delete, reorder steps). Source content remains unchanged.

---

## 📐 Content Models

### 🔄 Shared ContentItem (for Lessons, Parts, Tools)

```dart
class ContentItem {
  final String id;
  final String title;
  final List<ContentBlock> content;
  final List<String> flashcardIds;
  final List<String> keywords;
  final bool isPaid;
}
```

- `Lesson`, `Part`, and `ToolItem` models wrap or extend this base.
- `ContentBlock` contains interleaved structured text/images.

---

### 🧠 Learning Path Model

```dart
enum ContentType { lesson, part, flashcard, tool }

class LearningPathItem {
  final ContentType type;
  final String itemId;
}
```

Paths can mix and match all four types.

---

## 🧭 Navigation Flow (User Perspective)

| Route                 | Action/Entry                                      |
|-----------------------|--------------------------------------------------|
| **HomeScreen**        | Landing screen; shows progress, path buttons, flashcards |
| **LearningPath Buttons (on Home)** | Navigate directly to `PathChapterScreen`       |
| **Chapter → Item**    | Shows items from `pathRepository`                |
| **Modules (BNB)**     | Lesson modules → lesson items → content          |
| **Parts (BNB)**       | Zones → part items → content                     |
| **Flashcards (BNB)**  | Categories → flashcard items → content           |
| **Tools (BNB)**       | Toolbags → tool items (checklists, references)   |
| **Search**            | Keyword → sorted results by type (deep links)    |
| **Emergency FAB**     | Immediate access to editable emergency checklists|

### 🔁 Back Navigation Rule
- **Previous/Next buttons** on `ContentDetailScreen` move through a list.
- **Back button always returns to the screen that initiated navigation** (e.g., returns to `LessonItemScreen`, not previous/next item).
- Implemented using `PopScope` and `context.go(...)` with explicit `backDestination`.

---

## 🆘 Emergency Button

A floating red triangle icon with an `!` is **always visible**, linking directly to:
- The most relevant **Emergency Procedure checklist**
- These checklists are boilerplate but **user-editable** (steps can be reordered, hidden, checked)

---

## ✨ App Theme System

All colors, typography, and mode support (light/dark) must be defined in `AppTheme.dart`.
- No hard-coded `Colors.*` or inline styles allowed
- Themes can be switched in Settings later
- Typography scale also lives in the theme file

---

## 🧠 Flashcard System

Flashcards are:
- Linked to originating lesson, part, or tool
- May specify a **preferred front side**; others are randomized
- Support **tap to flip** and swipe-through navigation
- Track user performance:
  - Flashcard-level strength (e.g. weak/moderate/strong)
  - Category-level performance (for adaptive review)
- Accessible from:
  - Learning Path sequence
  - Flashcards tab
  - Lesson/Part detail screens (via link or bottom section)

---

## ✅ Outstanding Decisions (Finalized)

| Area                   | Answer |
|------------------------|--------|
| **Checklist Customization** | ✅ Allow add/delete/reorder with local storage |
| **Flashcard Review**        | ✅ User flips actively, with strength tracking |
| **Paid Gating**             | ✅ Per-item or per-path; toggle in Settings |
| **Offline Assets**          | ✅ All content and images fully offline; fallback image required |
| **Onboarding Tour**         | ✅ First-time popups per screen/function; introduce app flow |

---

## 🧱 BottomNavigationBar Order

Final order (left to right):
```
Home | Modules | Parts | Flashcards | Tools
```

---

## 🚧 Phased Build Plan

| Phase | Focus Area         | Outcome                                                   |
|-------|--------------------|-----------------------------------------------------------|
| 1     | Navigation Skeleton| Clean structure, transitions, MainScaffold + BNB         |
| 2     | Models + Repos     | Real content repositories and data parsing               |
| 3     | Detail Screens     | Interleaved content layout and content browsing          |
| 4     | Smart Navigation   | Prev/Next, backTracking, flashcard integration           |
| 5     | Polish + Expansion | Tour, Settings, personalization, paid gating             |

---

> This document will be updated as architecture or features evolve. All team members are encouraged to surface ambiguity or drift from these principles so we can resolve it centrally.

Several hours of work later:
# 🗽 BCC5 Guiding Principles & Architecture Overview

> _This document defines the structural, functional, and pedagogical principles of the BCC5 sailing education app. It acts as a single source of truth for developers, educators, and designers. All terminology is explicit. No feature or behavior is left to inference._

---

## 📖 App Philosophy

### 🧑‍🏫 From the User's Perspective
The user enters the app with a **learning goal**. The app supports them in:
- Following a **structured learning path** (scaffolded, progressive)
- Exploring content freely (modules, parts, flashcards, tools)
- Reviewing flashcards based on current topic or weakness
- Quickly accessing **emergency procedures** in real-time
- Retaining long-term knowledge with search, visuals, and references

### 👨‍💻 From the Developer's Perspective
The app is designed for:
- **Ease of content updates**: add/modify/remove a lesson/part/tool/flashcard in a single repository file
- **Data-driven navigation**: every screen is constructed from data, not hardcoded transitions
- **Expandable sequences**: floating point IDs allow seamless insertions (e.g. step 5.5)
- **Centralization**: each type of content lives in its own repository with a central index
- **All style elements (colors, themes, light/dark mode)** live in `AppTheme.dart` — never hard-coded elsewhere

---

## 📃 Core Knowledge Types

| Type            | Description                                   | Format/Display |
|-----------------|-----------------------------------------------|----------------|
| **Lesson**      | Conceptual instructional content              | Text/image blocks |
| **Part**        | Boat components with images & functions       | Text/image blocks |
| **Flashcard**   | Recall learning, tied to lesson or part       | Question/Answer |
| **ToolItem**    | Procedural, visual, heuristic, or reference aid | Varies by type |
| **LearningPath**| Structured sequence of lessons, parts, tools, and flashcards | Multi-type list |

---

## 🧱 Repository Organization

### 📦 Repository Matrix

| Type     | Count | Description |
|----------|-------|-------------|
| Lessons  | 9     | One per module/topic |
| Parts    | 5     | One per boat zone |
| Tools    | 6     | One per Toolbag category |
| Paths    | Variable | Each defines a progression |

### 📂 Index Structure

| Index File                     | Description                                  |
|--------------------------------|----------------------------------------------|
| `lesson_repository_index.dart` | Returns all lesson modules and items         |
| `part_repository_index.dart`   | Returns all zones and part items             |
| `toolbag_repository_index.dart`| Returns all toolbags and their items         |
| `path_repository_index.dart`   | Returns all learning paths and their items   |

Each index:
- Returns group names
- Provides item lists per group
- Allows lookup by ID (e.g. `lesson_dock_1.00`)
- Supports reverse lookup (e.g. `getModuleForLessonId(...)`)

---

## 🐀 ID Convention

All content items follow this structure:

```text
<type>_<group>_<order>
```

### Example:
```text
lesson_dock_1.00
```

| Segment      | Meaning                    |
|--------------|----------------------------|
| `lesson`     | Content type (`lesson`, `part`, etc.) |
| `dock`       | Group/module/zone/category |
| `1.00`       | Float order (for easy insertion) |

### ✅ Pros:
- Human-readable
- Searchable
- Stable for references and learning paths
- Float order allows inserting new content (e.g. `1.50`)

---

## 🛠️ Tools: Toolbags Structure

The **Tools branch** contains six “Toolbags,” each with its own repository:

| Toolbag            | Description                                                | Example Content |
|--------------------|------------------------------------------------------------|------------------|
| **Procedures**     | Checklists, Troubleshooting, Emergency Playbooks           | MOB, Reefing     |
| **References**     | Radio, Flags, Charts, Terminology                          | VHF Channels     |
| **Calculators**    | Formulas, Conversions, Anchoring Ratios                   | Hull speed calc  |
| **Visual Aids**    | Symbols, Signals, Clouds, Navigation Markers              | Buoy shapes      |
| **Cognitive Aids** | Rules of Thumb, Heuristics, Scenario Walkthroughs         | “Red Right Returning” |
| **Ditch Bag**      | Miscellaneous quick-access reference                      | Pre-departure steps |

### ✅ Editable Tool Items
Some tools (like checklists) must support user personalization:

```dart
class ChecklistStep {
  final String text;
  final bool isChecked;
  final bool isHidden;
}
```

These are stored locally and persist user edits (add, delete, reorder steps). Source content remains unchanged.

---

## 📀 Content Models

### ♻️ Shared ContentItem (for Lessons, Parts, Tools)

```dart
class ContentItem {
  final String id;
  final String title;
  final List<ContentBlock> content;
  final List<String> flashcardIds;
  final List<String> keywords;
  final bool isPaid;
}
```

- `Lesson`, `Part`, and `ToolItem` models wrap or extend this base.
- `ContentBlock` contains interleaved structured text/images.

---

### 🧠 Learning Path Model

```dart
enum ContentType { lesson, part, flashcard, tool }

class LearningPathItem {
  final ContentType type;
  final String itemId;
}
```

Paths can mix and match all four types.

---

## 🗭 Navigation Flow (User Perspective)

| Route                 | Action/Entry                                      |
|-----------------------|--------------------------------------------------|
| **HomeScreen**        | Landing screen; shows progress, path buttons, flashcards |
| **LearningPath Buttons (on Home)** | Navigate directly to `PathChapterScreen`       |
| **Chapter → Item**    | Shows items from `pathRepository`                |
| **Modules (BNB)**     | Lesson modules → lesson items → content          |
| **Parts (BNB)**       | Zones → part items → content                     |
| **Flashcards (BNB)**  | Categories → flashcard items → content           |
| **Tools (BNB)**       | Toolbags → tool items (checklists, references)   |
| **Search**            | Keyword → sorted results by type (deep links)    |
| **Emergency FAB**     | Immediate access to editable emergency checklists|

### ♻️ Back Navigation Rule
- **Previous/Next buttons** on `ContentDetailScreen` move through a list.
- **Back button always returns to the screen that initiated navigation** (e.g., returns to `LessonItemScreen`, not previous/next item).
- Implemented using `PopScope` and `context.go(...)` with explicit `backDestination`.

---

## 🚨 Emergency Button

A floating red triangle icon with an `!` is **always visible**, linking directly to:
- The most relevant **Emergency Procedure checklist**
- These checklists are boilerplate but **user-editable** (steps can be reordered, hidden, checked)

---

## ✨ App Theme System

All colors, typography, and mode support (light/dark) must be defined in `AppTheme.dart`.
- No hard-coded `Colors.*` or inline styles allowed
- Themes can be switched in Settings later
- Typography scale also lives in the theme file

---

## 🧠 Flashcard System

Flashcards are:
- Linked to originating lesson, part, or tool
- May specify a **preferred front side**; others are randomized
- Support **tap to flip** and swipe-through navigation
- Track user performance:
  - Flashcard-level strength (e.g. weak/moderate/strong)
  - Category-level performance (for adaptive review)
- Accessible from:
  - Learning Path sequence
  - Flashcards tab
  - Lesson/Part detail screens (via link or bottom section)

---

## ✅ Outstanding Decisions (Finalized)

| Area                   | Answer |
|------------------------|--------|
| **Checklist Customization** | ✅ Allow add/delete/reorder with local storage |
| **Flashcard Review**        | ✅ User flips actively, with strength tracking |
| **Paid Gating**             | ✅ Per-item or per-path; toggle in Settings |
| **Offline Assets**          | ✅ All content and images fully offline; fallback image required |
| **Onboarding Tour**         | ✅ First-time popups per screen/function; introduce app flow |

---

## 📁 BottomNavigationBar Order

Final order (left to right):
```
Home | Modules | Parts | Flashcards | Tools
```

---

## 🚧 Phased Build Plan

| Phase | Focus Area         | Outcome                                                   |
|-------|--------------------|-----------------------------------------------------------|
| 1     | Navigation Skeleton| Clean structure, transitions, MainScaffold + BNB         |
| 2     | Models + Repos     | Real content repositories and data parsing               |
| 3     | Detail Screens     | Interleaved content layout and content browsing          |
| 4     | Smart Navigation   | Prev/Next, backTracking, flashcard integration           |
| 5     | Polish + Expansion | Tour, Settings, personalization, paid gating             |

---

> This document will be updated as architecture or features evolve. All team members are encouraged to surface ambiguity or drift from these principles so we can resolve it centrally.

