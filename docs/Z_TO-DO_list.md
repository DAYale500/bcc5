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

