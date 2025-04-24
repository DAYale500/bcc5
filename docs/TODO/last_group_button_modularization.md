Here’s a clear and concise **TODO** you can save for your records to guide future modularization of the `LastGroupButton` feature:

---

### ✅ TODO: Modularize `LastGroupButton` Feature Across Detail Screens

**Goal:**  
Extract and reuse the `LastGroupButton` logic currently duplicated across `LessonDetailScreen`, `PartDetailScreen`, `ToolDetailScreen`, and `FlashcardDetailScreen`.

---

#### 📦 Create a shared widget:
**File path:** `lib/widgets/navigation/last_group_button.dart`

```dart
// Required params:
final RenderItemType type;
final DetailRoute detailRoute;
final Map<String, dynamic>? backExtra;
final int branchIndex;
final BuildContext context;
final String backDestination;
final VoidCallback onNoNextGroup;

// Optional: pass function to get renderItems from new group
final Future<List<RenderItem>> Function()? getNextRenderItems;
```

---

#### 📥 Inputs should cover both:
- `DetailRoute.branch` → uses `RepositoryIndex.getNextZone/getNextToolbag/etc.`
- `DetailRoute.path` → uses `PathRepositoryIndex.getNextChapter(...)`

---

#### 🧠 Considerations:
- Inject logic via `callback` or `enum` for which index to use (Tool, Part, Lesson, Flashcard).
- Use `toTitleCase()` + `pluralize()` helpers internally to render fallback modal.
- Return a fully styled `ElevatedButton` wrapped in `NavigationButtons.customNextButton`.

---

#### 🔄 Rollout Plan:
- [ ] Migrate `LessonDetailScreen` to shared `LastGroupButton`
- [ ] Migrate `PartDetailScreen`
- [ ] Migrate `ToolDetailScreen`
- [ ] Migrate `FlashcardDetailScreen`
- [ ] Add tests to validate edge cases:
  - No next group
  - Next group exists but has no items
  - Successful transition

---

Let me know if you'd like the initial skeleton stub file for the widget when you're ready to build it.




















Here’s the initial skeleton for the shared `LastGroupButton` widget, ready to drop into:

> 📄 `lib/widgets/navigation/last_group_button.dart`

```dart
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LastGroupButton extends StatelessWidget {
  final RenderItemType type;
  final DetailRoute detailRoute;
  final Map<String, dynamic>? backExtra;
  final int branchIndex;
  final String backDestination;
  final String label; // e.g. "module", "zone", "toolbag", "chapter", etc.
  final Future<List<RenderItem>?> Function() getNextRenderItems;
  final void Function(List<RenderItem> renderItems)? onNavigateToNextGroup;

  const LastGroupButton({
    super.key,
    required this.type,
    required this.detailRoute,
    required this.backExtra,
    required this.branchIndex,
    required this.backDestination,
    required this.label,
    required this.getNextRenderItems,
    this.onNavigateToNextGroup,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        logger.i('⏭️ LastGroupButton tapped ($label mode)');

        final renderItems = await getNextRenderItems();

        if (renderItems == null || renderItems.isEmpty) {
          logger.i('⛔ No next $label or it contains no renderable items');
          _showEndOfGroupModal(context);
          return;
        }

        onNavigateToNextGroup?.call(renderItems);
      },
      style: AppTheme.navigationButton,
      child: Text('Next ${label.toTitleCase()}'),
    );
  }

  void _showEndOfGroupModal(BuildContext context) {
    final labelCapitalized = label.toTitleCase();
    final labelPlural = _pluralize(labelCapitalized);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🎉 You’ve reached the final $label!',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Great job making it through this $label. You can review or return to the full list of $labelPlural.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go(backDestination);
              },
              style: AppTheme.navigationButton,
              child: Text('Back to $labelPlural'),
            ),
          ],
        ),
      ),
    );
  }

  String _pluralize(String word) => word.endsWith('s') ? word : '${word}s';
}
```

---

### 🧭 How to use it

Here's how you'd drop it in:

```dart
customNextButton: currentIndex == renderItems.length - 1
  ? LastGroupButton(
      type: RenderItemType.part,
      detailRoute: widget.detailRoute,
      backExtra: widget.backExtra,
      branchIndex: widget.branchIndex,
      backDestination: '/parts',
      label: 'zone',
      getNextRenderItems: () async {
        final nextZone = PartRepositoryIndex.getNextZone(...);
        if (nextZone == null) return null;
        return buildRenderItems(ids: ...);
      },
      onNavigateToNextGroup: (renderItems) {
        TransitionManager.goToDetailScreen(...);
      },
    )
  : null,
```

Let me know when you're ready for full integration instructions for one of the screens, or want to add optional helper methods or unit tests.

















Perfect summary — this is super clean and should get any new dev up to speed fast. Here’s a quick version of how to onboard them smoothly based on your structure:

---

## 👋 Onboarding Summary for New Developer

### 🔧 Your Immediate Focus
You’re joining mid-refactor of the BCC5 app's `DetailScreen` UX. Your first mission is to **standardize the “Next Chapter/Group” behavior** across all content types:

- **Goal:** Replace ad-hoc “Next” buttons with a shared `LastGroupButton` widget and show an `EndOfGroupModal` when the user reaches the end of a group or branch.
- **Screens Done:** `LessonDetailScreen`, `PartDetailScreen`
- **Screens To Do:** `ToolDetailScreen`, `FlashcardDetailScreen`

---

### 📦 Key Files
- `lib/widgets/navigation/last_group_button.dart` – shared button widget
- `lib/widgets/end_of_group_modal.dart` – reusable bottom modal
- Each `DetailScreen` will drop in `LastGroupButton` using:
  - `getNextRenderItems` → function to look up the next group
  - `onNavigateToNextGroup` → calls `TransitionManager.goToDetailScreen(...)`

---

### 📌 Patterns to Copy
Look at the `LessonDetailScreen` integration:
- `customNextButton: currentIndex == renderItems.length - 1 ? LastGroupButton(...) : null`
- Use `backExtra` for current module/zone/toolbag
- `getNextRenderItems()` uses correct RepositoryIndex
- `onNavigateToNextGroup(...)` does the actual `TransitionManager` navigation

---

### 🛠 Dev Notes
- Use `TransitionManager` for **all** navigation between detail items
- Use `backDestination` and `backExtra` for consistent back behavior
- Stick to the app’s defined `DetailRoute.branch` vs `DetailRoute.path` logic
- Stick to existing `AppTheme` and transition types

---

Let me know when you're ready to refactor the next file (ToolDetailScreen or FlashcardDetailScreen) — I can walk through it line by line and convert it to use `LastGroupButton` cleanly.