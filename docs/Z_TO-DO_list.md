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