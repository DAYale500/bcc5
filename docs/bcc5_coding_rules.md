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

Would you like this version exported or synced to a shared file?

