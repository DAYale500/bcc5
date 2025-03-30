## 🧱 BCC5 Coding Rules & Architecture Conventions

### ✅ Enforced Rules

#### Architecture & Layout
- **All screens must use `MainScaffold`** unless explicitly designed otherwise (e.g. modals).
- **`CustomAppBarWidget` must be used per screen**, not injected globally.
- `MainScaffold` must wrap only the core screen (no nested MainScaffolds).
- All screens must pass **explicit `branchIndex`** to `MainScaffold`.
- Use **reusable UI components** like `GroupButton`, `ItemButton` — not branch-specific variants.

#### UI & Theming
- **All styles (color, typography, layout) must come from `AppTheme`.**
- Centralized theme includes AppBar, BNB, button radius/padding, typography, etc.
- `CustomAppBarWidget` must reference AppTheme only.
- Hex `#163FE8` is the official `primaryBlue`.

#### Navigation
- **Use `GoRouter` (`context.push` / `context.go`)** for all navigation.
- Use `PopScope` instead of deprecated `WillPopScope`.
- Always pass `backDestination`, `backExtra` for consistency.
- Centralized `NavigationContext` helpers define transitions.

#### Logic & Models
- **Parse all IDs via `id_parser.dart`** (e.g., to get module/zone/type).
- Do not duplicate fields (e.g., no `.module` if derivable from `lesson.id`).
- Repositories must validate IDs with assert (e.g., prefix check).

#### Repositories & Structure
- Models: `lesson_model.dart`, `part_model.dart`, etc.
- Repos: `lesson_docking_repository.dart`, `part_rigging_repository.dart`, etc.
- Index files: `lesson_repository_index.dart`, etc.
- Each index must provide:
  - `.getItemsForGroup(...)`
  - `.getItemById(...)`
  - `.getGroupNames()`

#### Dev & Debug
- **Use `logger.i(...)`** for screen entry, user actions, and debug flow.
- Logger tags must be emoji-coded by screen: 🟦, 🟥, 🟩, etc.

---

### ⚠️ Proposed Rules / Pending Enforcement

- `MainScaffold` should also enforce route guarding / redirect logic centrally.
- Add dark mode toggle in Settings screen.
- Repository validation should be run as part of CI/linter.
- Enforce absence of hardcoded colors/styles in linter.

---

### ✅ Tracking Matrix

| Rule Area          | Rule Description                                     | Status         | Notes                                  |
|--------------------|------------------------------------------------------|----------------|----------------------------------------|
| AppBar Usage       | AppBar defined per screen, not inside MainScaffold  | ✅ Approved     | Partially rolled out                   |
| MainScaffold       | Wrapped once per screen                            | ✅ In Progress  | Duplication bug under active fix       |
| branchIndex Naming | Used instead of selectedIndex                       | ✅ Done         |                                          |
| Theming            | All styles in AppTheme                              | ✅ Done         | Expansion complete                     |
| ID Parsing         | All IDs parsed via id_parser.dart                   | ✅ Done         |                                          |
| Navigation         | Use GoRouter only                                   | ⚠️ In Progress  | Still some Navigator.push in use       |
| Logger Use         | Screen entries, taps, and flows traced              | ✅ Partial      | Some screens still lack coverage       |
| Repository IDs     | Prefix assertions on load                           | ⚠️ Incomplete   | Only implemented in Parts so far       |

---

Would you like an HTML/printable version exported, or for this to be added to your GitHub project README in future?























# BCC5 Coding Rules & Architecture Conventions

## 1. Navigation

1.1 All screen-to-screen transitions must go through `GoRouter` and respect `app_router.dart` transition definitions.  
1.2 Back navigation must use `PopScope` + `context.go(...)` to ensure left-slide animations and back stack consistency.  
1.3 `CustomAppBarWidget` must be added per-screen, not through `MainScaffold`, to preserve back button logic.

## 2. Screen Architecture

2.1 All primary screens must be wrapped in `MainScaffold`.  
2.2 BottomNavigationBar index must be passed as `branchIndex`, not `selectedIndex`.  
2.3 All screens must include a custom `AppBar` using `CustomAppBarWidget`.  
2.4 Screens must support optional `showBackButton`, `showSettingsIcon`, and `showSearchIcon` flags.

## 3. Theming

3.1 All color and style values must be defined in `AppTheme`. No inline styling is allowed.  
3.2 Light and dark themes must be supported.  
3.3 AppBar and BottomNavigationBar must derive their styles from `AppTheme.lightTheme` and `AppTheme.darkTheme`.

## 4. Model Structure

4.1 No duplication of fields (e.g., `.module` should not appear if it can be parsed from `.id`).  
4.2 Use a shared utility (`id_parser.dart`) to extract type/group/sequence from any content ID.  
4.3 All models must be suffixed with `_model.dart`.

## 5. Repository Indexing

5.1 Each content category (lessons, parts, tools, etc.) must have an index file that lists available groups and items.  
5.2 Each index file must implement an `assertIdsMatchRepositoryPrefix()` method.  
5.3 Group identifiers (e.g., 'docking', 'hull') must be consistent with repository map keys.

## 6. Logging

6.1 Use `logger.i(...)` for all major navigation actions.  
6.2 Avoid `print` statements or unused loggers.  
6.3 Ensure logs include emojis or keywords for easy grep-based analysis.

## 7. File Structure

7.1 All files must follow the `lib/screens`, `lib/data/models`, `lib/data/repositories`, `lib/utils`, and `lib/widgets` structure.  
7.2 No top-level Dart files outside the approved directories.  
7.3 Match screen names to file names (e.g., `LessonItemScreen` in `lesson_item_screen.dart`).

## 8. Shared Widgets

8.1 Reusable UI components like buttons must be defined in `widgets/`.  
8.2 Avoid screen-specific widget definitions inline.  
8.3 Use `GroupButton` and `ItemButton` consistently.

## 9. Testing/Validation Rules

9.1 Each screen must be tested for: back button behavior, AppBar visibility, BottomNav index accuracy.  
9.2 Manual testing must include launching from home and from a deep link.

## 10. Naming Conventions

10.1 Use camelCase for variables and methods, PascalCase for classes.  
10.2 Navigation keys like `branchIndex`, `backDestination`, and `sequenceList` must be used consistently.

## 11. In-Progress Rules or Fixes (Tracked)

11.1 ⚠️ `CustomAppBarWidget` still missing from some screens.  
11.2 ⚠️ `MainScaffold` improperly duplicated in a few routes.  
11.3 ⚠️ `branchIndex` inconsistently used — some `selectedIndex` still remain.

---



📘 Pattern Reminder for All Screens
All GoRouter routes wrap the screen in MainScaffold.
All screen files define only:
AppBar (via CustomAppBarWidget)
Body (Column, ListView, GridView, etc.)
Optional PopScope if needed
This is now the official BCC5 screen pattern.

Rule: Route Structure & MainScaffold Wrapping
All primary screens (Landing, LessonModule, PartZone, etc.) must not return full Scaffolds themselves.
Instead, each screen should return a Column containing:
A CustomAppBarWidget
An Expanded body (e.g., ListView, GridView, etc.)
These screens will be wrapped in MainScaffold by the corresponding GoRoute in app_router.dart.
MainScaffold provides the BottomNavigationBar and accepts an optional AppBar via parameter.
This approach avoids duplicate BNB rendering and keeps logic centralized, reducing risk of layout inconsistencies.



## Route + Scaffold Pattern Rule

🧠 All primary content screens should follow this architecture pattern:

1. **Routing**  
   - Each screen is launched via a `GoRoute` in `app_router.dart`.
   - Dynamic data (e.g., `module`, `zone`, `category`, etc.) should be passed via `state.extra`.

2. **Screen Widget Structure**  
   - The screen widget (e.g., `LessonItemScreen`, `PartItemScreen`) should:
     - Be passed all necessary data via constructor.
     - Return a `Column` containing:
       - A `CustomAppBarWidget`
       - An `Expanded` child (typically `ListView`, `GridView`, etc.)

3. **MainScaffold Wrapping**  
   - `MainScaffold` should be applied **in the route**, not inside the screen itself.
   - This avoids double BottomNavigationBars (BNB) and ensures consistent `branchIndex` control.

✅ This enforces clean separation between layout and logic, enables smarter transitions, and keeps widgets reusable/testable.




🧱 Architecture Rule: AppBar and BNB Pattern
All screens should only return the AppBar + Body and be wrapped externally in MainScaffold by the route.
This ensures:

🧼 Clean separation of layout and logic

🚫 No accidental double BottomNavigationBar

🧭 Centralized control of transitions and navigation behavior

DO NOT: Nest a Scaffold inside a screen that's already wrapped in MainScaffold.
DO: Use CustomAppBarWidget inside the screen and pass it via appBar: to MainScaffold.






“If a widget might support custom back navigation (e.g. to maintain deep-link state), always expose an optional VoidCallback? onBack parameter.”





✅ 2. Dev Guideline: AppBar Back Button Logic
Screen	Should pass onBack?	Reason
LessonItemScreen	✅ Yes	Needs to go back to LessonModuleScreen via context.go()
PartItemScreen	✅ Yes	Must return to PartZoneScreen
FlashcardItemScreen	✅ Yes	Returns to FlashcardCategoryScreen
PathItemScreen	✅ Yes	Returns to PathChapterScreen
ContentDetailScreen	✅ Yes (if from items)	Ensures backDestination is respected
ContentDetailScreen (Search)	❌ No (uses fallback)	No reliable origin screen
HomeScreen	❌ No	No back button needed
🧭 Policy:

If a screen was pushed via context.push(...) from a known origin, pass onBack explicitly using context.go(...) with the correct destination.

If origin is ambiguous (e.g. search), rely on fallback logic inside CustomAppBarWidget.

// TODO: Add `onBack` and `branchIndex` support for clean navigation.
// This ensures proper back behavior and bottom nav visibility in ContentDetailScreen.
// Refer to `LessonItemScreen` or `PartItemScreen` for the implementation pattern.








### 🧭 Rule: All Navigations to `/content` Must Include Sequencing Extras

To support `ContentScreenNavigator` and the shared `ContentDetailScreen`, all navigation to the `/content` route must include the following in `extra`:

- `sequenceTitles`: `List<String>` of item titles.
- `contentMap`: `Map<String, List<ContentBlock>>` keyed by title.
- `startIndex`: `int` — where to begin in the sequence.
- `branchIndex`: `int` — tab index for BottomNavigationBar.
- `backDestination`: `String` — GoRouter path to return to.
- `backExtra`: `Map<String, dynamic>` — extras required to rebuild previous screen.

Even if a screen only shows one item (e.g., a single part), wrap it in a one-item sequence.

#### ✅ Example:
```dart
context.push('/content', extra: {
  'sequenceTitles': ['Deck Cleats'],
  'contentMap': {'Deck Cleats': cleatContent},
  'startIndex': 0,
  'branchIndex': 2,
  'backDestination': '/parts/items',
  'backExtra': {'zone': 'Deck', 'branchIndex': 2},
});










✅ Got it! Here's the full rule formatted for your existing dev guide.

---

### 📘 `ContentScreenNavigator` Routing Rule

#### 🔐 Rule: All Navigations to `/content` Must Include Full Sequencing Extras

To maintain consistent behavior across all branches (Lessons, Parts, Flashcards, Tools, Paths), the `/content` route **must always receive** a complete set of sequencing extras. These extras are used by `ContentScreenNavigator` to determine which item to show, how to navigate between them, and how to return cleanly.

---

#### ✅ Required `extra` fields for `/content`:

| Key              | Type                           | Purpose                                                                 |
|------------------|--------------------------------|-------------------------------------------------------------------------|
| `sequenceTitles` | `List<String>`                 | Ordered list of all item titles in the sequence                        |
| `contentMap`     | `Map<String, List<ContentBlock>>` | Map of title → content blocks (same keys as in `sequenceTitles`)       |
| `startIndex`     | `int`                          | Which item to start displaying                                         |
| `branchIndex`    | `int`                          | Used to set the correct BottomNavigationBar tab                        |
| `backDestination`| `String`                       | GoRouter path to return to (e.g., `/lessons/items`)                    |
| `backExtra`      | `Map<String, dynamic>`         | All extras needed to rebuild the previous screen context               |

---

#### 🔁 Even for singleton content (e.g. single part or tool):

Wrap the item as a **single-item sequence** to maintain compatibility:

```dart
context.push('/content', extra: {
  'sequenceTitles': ['Deck Cleats'],
  'contentMap': {'Deck Cleats': cleatContent},
  'startIndex': 0,
  'branchIndex': 2,
  'backDestination': '/parts/items',
  'backExtra': {'zone': 'Deck', 'branchIndex': 2},
});
```

---

#### 💡 Why this rule exists:
- Enables Previous/Next navigation across branches.
- Centralizes back button logic inside `ContentDetailScreen`.
- Keeps all content flow uniform and scalable.

---









---

## ✅ New Rule for Dev Guide (Rule #12)

```md
## 12. Flashcard Architecture

12.1 All flashcards must be **embedded inside their source item** (`LessonItem`, `PartItem`, or `ToolItem`).  
12.2 Flashcards are **not stored in separate repositories**. They live within the same model and repository file as their source.  
12.3 A shared utility file (e.g., `flashcard_repository.dart`) may exist to extract and group flashcards for UX purposes only.  
12.4 All flashcards must follow the ID format: `flashcard_<sourceId>_<index>`.  
12.5 Every lesson, part, or tool must include at least one flashcard.  
12.6 Do not duplicate flashcards across models. If a concept is shared, create a shared utility flashcard object and reference it if needed.

✅ This rule guarantees content cohesion and simplifies review workflows.

