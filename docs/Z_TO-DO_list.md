TO-DO
Implement dark mode toggle in Settings
Begin appRouter migration phase
Expand to Path, Flashcard, Tool branches (full feature flow)

🛠️ TODO: Modularize Transitions into transition_builders.dart
Create a lib/navigation/transition_builders.dart file to house reusable route transition styles.
Extract buildCustomTransition(...) from app_router.dart and refactor into multiple named builders:
buildSlideTransitionPage(...)
buildScaleTransitionPage(...)
buildFadeTransitionPage(...)
Update each route in app_router.dart to use the correct transition method.

✅ Benefits:
Centralized management of all animations.
Cleaner app_router.dart.
Easy reuse in future branches (flashcards, paths, tools, etc.).



📌 TODO: Expand /content route to support full ContentScreenNavigator behavior
Once sequencing and dynamic back navigation are required, update the /content route and context.push(...) calls to support:
✅ sequenceTitles: full list of content item titles
✅ contentMap: a map of titles → content blocks
✅ startIndex: index of the selected item in the sequence
✅ onBack logic: allow returning to a specific screen like /lessons/items with contextual extras (module, branchIndex, etc.)
This will allow ContentDetailScreen to act as a full ContentScreenNavigator, supporting:
🔁 Previous / Next navigation
🔙 Correct backDestination handling

// 🟠 TODO: Add `onBack` parameter to ensure correct back navigation
// This screen should call `CustomAppBarWidget(onBack: ...)` with appropriate context.go(...) logic




//To-Do: grey out the unused previous/next button rather than it disappearing
// To-Do: add a loading spinner while the content is being fetched
// To-Do: handle the case where there are no items in the chapter
// To-Do: consider adding a scroll to top button if the list is long
// To-Do: add error handling for when the chapter is not found
// To-Do: consider adding a refresh button to reload the content
// To-Do: add a feature to bookmark or save the current item for later
// To-Do: add a feature to track progress through the items
// To-Do: consider adding a search feature to filter items by title or keyword
// To-Do: add a feature to share the current item with others
// To-Do: add a feature to provide feedback on the item (e.g., like, dislike, comment)
// To-Do: consider adding a feature to download the content for offline viewing
// To-Do: add a feature to adjust the font size or style for better readability
// To-Do: add a feature to toggle between light and dark mode for the content display
// To-Do: add a feature to highlight or annotate the content for personal use
// To-Do: add a feature to export the content as a PDF or other formats for easy sharing
// To-Do: add a feature to integrate with external services (e.g., note-taking apps, cloud storage)
// To-Do: add a feature to sync progress across devices if the user is logged in
// To-Do: add a feature to notify the user of updates or new content in the path
// To-Do: add a feature to allow users to rate the items and provide reviews
// To-Do: add a feature to allow users to suggest edits or contribute additional content
// To-Do: add a feature to allow users to follow or subscribe to specific paths or chapters for updates
// To-Do: add a feature to allow users to create custom paths or collections of items
//


move tools to left of flashcards?

pathItem = flashcard, doesn't navigate to flashcardDetailScreen

Option to add darkTheme + themeMode: ThemeMode.system when ready.

Excellent prompt. Let's break this down with precision. We'll conduct a full audit of **`.go()` vs `.push()` usage** across your codebase (based on the latest uploaded file `Z_bcc5_all_others_20250405_195841.txt`), then offer:

1. **A complete file-by-file usage table**  
2. **Explanations for each case**: Why `.go()` or `.push()` was used, and if it needs to be changed  
3. **A task checklist**: Clear list of proposed refactor tasks (mergeable when appropriate)

---

## ✅ Audit: `.go()` vs `.push()` Usage

| **File** | **Method** | **Usage Context** | **Should Be** | **Notes** |
|---------|-------------|------------------|----------------|----------|
| `landing_screen.dart` | `.go()` | Navigating to `/learning-paths/...` | ✅ `.go()` | ✅ Correct: top-level branch/tab nav |
| `flashcard_category_screen.dart` | `.push()` | Navigating to `/flashcards/items` | ✅ `.push()` | ✅ Correct: keeps stack inside flashcards |
| `flashcard_item_screen.dart` | `.push()` | Navigating to `/flashcards/detail` | ⚠️ `.go()` preferred | ❗ Needs `.go()` + `transitionKey` to match detail screen behavior |
| `flashcard_item_screen.dart` | `.go()` | Returning to `/flashcards` via AppBar | ✅ `.go()` | ✅ Correct: replaces stack when backing to parent screen |
| `main_scaffold.dart` | `.go()` | BottomNavBar routing | ✅ `.go()` | ✅ Correct: resets stack per branch/tab |
| `navigation_buttons.dart` | `.go()` | Navigating to next/prev detail screens | ✅ `.go()` | ✅ Correct: detail-level, same-stack swap |
| `flashcard_detail_screen.dart` | `.go()` inside `onBack()` | Returns to `backDestination` | ✅ `.go()` | ✅ Correct, given MainScaffold wraps screen |
| `lesson_module_screen.dart`, `part_zone_screen.dart`, `tool_bag_screen.dart` | `.go()` (assumed) | Nav to `/items` screen | ⚠️ Missing `transitionKey` | 🛠 Needs `.go()` audit for `transitionKey` injection |

---

## 💬 Clarifying Guidelines

### When to Use `.go()`
Use when:
- You're switching top-level tabs (BNB)
- You're **replacing** the current screen entirely (not nesting deeper)
- You want to **reset** the navigation stack

### When to Use `.push()`
Use when:
- You're going **deeper** into a navigation hierarchy (like opening an item from a list)
- You want to **preserve** the current screen in the back stack
- You’re showing a modal or a drill-down detail (like flashcard detail from a list)

---

## 🔧 Recommended Tasks (Grouped)

### 📂 `flashcard_item_screen.dart`
- [ ] ✅ Convert `.push('/flashcards/detail')` → `.go('/flashcards/detail')`
- [ ] ✅ Add `transitionKey` to all `.go()` calls

### 📂 `lesson_module_screen.dart`, `part_zone_screen.dart`, `tool_bag_screen.dart`
- [ ] 🛠 Audit `.go()` usage for missing `transitionKey`
- [ ] 🧼 Add `transitionKey` when navigating to `/items` routes

### 📂 `main_scaffold.dart`
- [ ] ✅ Already uses `.go()` for tab navigation — **no changes needed**

### 📂 `landing_screen.dart`
- [ ] ✅ All `.go()` calls are appropriate — **no changes needed**

---

## 🧭 Final Task Checklist

| **File** | **Task(s)** |
|----------|-------------|
| `flashcard_item_screen.dart` | Convert `.push()` to `.go()` for detail, inject `transitionKey` |
| `lesson_module_screen.dart` | Ensure `.go()` to `/lessons/items` includes `transitionKey` |
| `part_zone_screen.dart` | Ensure `.go()` to `/parts/items` includes `transitionKey` |
| `tool_bag_screen.dart` | Ensure `.go()` to `/tools/items` includes `transitionKey` |
| `navigation_buttons.dart` | Already OK — `.go()` for forward/back item nav |
| `main_scaffold.dart` | Already OK — `.go()` for BNB |
| `landing_screen.dart` | Already OK — `.go()` for learning paths |

---

Ready to begin the refactors?  
If yes, I recommend we start with `flashcard_item_screen.dart` — it has the most immediate impact and is the only file currently misusing `.push()` where `.go()` is required. Shall I start there?