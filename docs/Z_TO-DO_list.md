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
