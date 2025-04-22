✅ TODO: Upgrade Final Zone UX in PartDetailScreen
Context:
Currently, when a user reaches the final zone in PartDetailScreen, the app shows a SnackBar with the message “You’ve reached the final zone.” This causes layout issues when embedded in a button and provides limited UX feedback.

Task:
Replace the SnackBar with a modal bottom sheet that gracefully informs the user they've reached the end, and offers a next logical step — such as a button to “Browse All Parts.”

Suggested Implementation:

Use showModalBottomSheet() instead of ScaffoldMessenger.of(context).showSnackBar(...).

Use rounded corners, centered text, and an action button (e.g., "Browse All Parts").

Mirror the UX used in LessonDetailScreen when the user reaches the final module.

Stretch Goal: Refactor into a reusable modal widget shared between LessonDetailScreen and PartDetailScreen.