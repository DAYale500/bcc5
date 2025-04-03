Thanks for the full log and detailed breakdown. You’ve clearly isolated **two critical issues** in the navigation flow and behavior after refactoring:

---

### ✅ **What’s working**

1. **Flashcard tapped from PathItemScreen:**
   - You start from `flashcard_lesson_syst_1.00`
   - ✅ Loads in `FlashcardDetailScreen` with:
     - `index_card.png` UI
     - Flip button
     - Background image
     - Back button is **missing**, but navigation buttons work

---

### ❌ **Issue 1: Next button leads to wrong screen type**

#### Observation:
- Tapping **Next** from `flashcard_lesson_syst_1.00` tries to show `part_deck_1.00`
- But `FlashcardDetailScreen` expects a **flashcard**, not a part
- So it logs:

```
Exception: ⛔ FlashcardDetailScreen received non-flashcard type at index 2
```

#### Root Cause:
You're staying in `FlashcardDetailScreen`, but trying to show a `RenderItem` with `type = ContentType.part`, which it **cannot render**.

#### ✅ Expected Fix:
`goTo()` should **route to the correct screen type** depending on the next `RenderItem`.

```dart
final nextItem = renderItems[nextIndex];
switch (nextItem.type) {
  case ContentType.flashcard:
    context.pushReplacementNamed(
      AppRoute.flashcardDetail.name,
      extra: { ... },
    );
    break;
  case ContentType.lesson:
    context.pushReplacementNamed(
      AppRoute.lessonDetail.name,
      extra: { ... },
    );
    break;
  case ContentType.part:
    context.pushReplacementNamed(
      AppRoute.partDetail.name,
      extra: { ... },
    );
    break;
  case ContentType.tool:
    context.pushReplacementNamed(
      AppRoute.toolDetail.name,
      extra: { ... },
    );
    break;
}
```

We already have this logic pattern in `PathItemScreen`, just need to mirror it here in `goTo()`.

---

### ❌ **Issue 2: When navigating from `LessonDetailScreen`, flashcards appear broken**

#### Observation:
- Tap **Next** inside `LessonDetailScreen`
- It navigates to a flashcard
- But the screen:
  - **Doesn't show flip card**
  - **Doesn’t show background image**
  - **Feels like ContentDetailScreen** instead of `FlashcardDetailScreen`

#### Root Cause:
In `LessonDetailScreen`, your `goTo()` probably does not switch screens based on content type. It assumes the same screen will render the next item.

#### ✅ Expected Fix:
Refactor the `goTo()` method in **all DetailScreens** (`lesson`, `part`, `tool`, `flashcard`) to:

1. **Detect the type** of the next item in `renderItems`
2. **Route to the correct screen** accordingly (use `.pushReplacementNamed()` with correct extras)

---

### 🧪 Suggested Next Step: Refactor `goTo()` method

Let’s refactor `FlashcardDetailScreen.goTo()` and then do the same for the others. Here’s a preview of what to apply in `FlashcardDetailScreen`:

```dart
void goTo(int index) {
  if (index < 0 || index >= renderItems.length) return;
  final item = renderItems[index];
  final routeName = switch (item.type) {
    ContentType.flashcard => AppRoute.flashcardDetail.name,
    ContentType.lesson => AppRoute.lessonDetail.name,
    ContentType.part => AppRoute.partDetail.name,
    ContentType.tool => AppRoute.toolDetail.name,
  };
  context.pushReplacementNamed(
    routeName,
    extra: {
      'renderItems': renderItems,
      'currentIndex': index,
      'branchIndex': widget.branchIndex,
      'backDestination': widget.backDestination,
      'backExtra': widget.backExtra,
    },
  );
}
```

---

### 🔧 Bonus Fix: Missing Back Button on FlashcardDetailScreen

You're using `MainScaffold`, but not passing the `branchIndex = 4` correctly or the `CustomAppBarWidget` might not be injected.

Ensure:
```dart
MainScaffold(
  branchIndex: widget.branchIndex,
  child: ...
)
```

---

### ✅ Let's Track Fix Steps

Here's a mini checklist so we can resolve this cleanly:

| # | Task | Status |
|--|------|--------|
| 1 | Fix `goTo()` in `FlashcardDetailScreen` to route based on item type | ⏳ |
| 2 | Apply same `goTo()` logic in `LessonDetailScreen`, `PartDetailScreen`, `ToolDetailScreen` | ⏳ |
| 3 | Confirm AppRouter route names are correctly passed for each type | ⏳ |
| 4 | Ensure back button shows in `FlashcardDetailScreen` AppBar | ⏳ |
| 5 | Ensure all navigation sequences work (`lesson → flashcard`, `flashcard → part`, etc.) | ⏳ |

---

Want to start with the refactored `FlashcardDetailScreen` that includes the corrected `goTo()`?