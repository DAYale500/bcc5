Here's a **structured summary** of your full tour onboarding and navigation bugfix effort as of today (April 16), incorporating your notes, decisions, and in-progress changes.

---

# 🧭 BCC5 Tour + Navigation Stability Refactor  
**🗓️ Summary for April 16**  
**Goal:** Finalize the onboarding tour system (Phase 1) while resolving all regression bugs introduced during or discovered after its partial rollout.

---

## ✅ OBJECTIVES

### 🎯 Dual Goal:
1. **Phase 1 Onboarding Tour (LandingScreen only)**:
   - Uses `tutorial_coach_mark`
   - Highlights: AppBar title, MOB, Settings, Search, Harbor, Competent Crew, Advanced Paths
   - Respects robust GlobalKey management (Option 1)

2. **Fix regressions introduced during Tour buildout**:
   - ToolItemScreen nav bugs
   - MOB flow inconsistencies
   - PartDetailScreen back crash
   - Layout issues in NavigationButtons

---

## 📍 CURRENT TOUR STATUS

| Component                    | Status     | Notes                                                                 |
|-----------------------------|------------|-----------------------------------------------------------------------|
| `tutorial_coach_mark`       | ✅ Added   | In pubspec, working in `LandingScreen`                               |
| GlobalKeys (Option 1)       | ✅ Enforced | Passed top-down into each widget; avoids null/stale issues           |
| `LandingScreen` tour logic  | ✅ Working  | Starts on first load (via SharedPreferences), uses 6+ step flow      |
| MOB, Settings, Search, etc. | ✅ All targets implemented | Keys successfully highlight widgets                                  |
| Tour replay support         | ⬜ Planned  | Needs UI entry point in settings                                      |
| Phase 2 (multi-screen tour) | ⬜ Future   | Requires route-aware wizard logic                                    |

---

## 🐞 ACTIVE BUG TRACKER

| ID   | Bug Description                                                              | Status   | Assigned Fix Area               |
|------|-------------------------------------------------------------------------------|----------|----------------------------------|
| B1   | ToolItemScreen empty when opened from MOB → Other Emergencies                | ✅ Fixed  | MOB modal now builds renderItems |
| B2   | Back from PartDetailScreen crashes / jumps to LandingScreen                  | ✅ Fixed  | GoRouter route now includes correct `backDestination` and `extras` |
| B3   | ToolDetailScreen back creates duplicate ToolItemScreen                       | ✅ Fixed  | `Navigator.pop()` replaces `context.go()` |
| B4   | ToolItemScreen back misroutes to LandingScreen instead of MOB (if cameFromMob) | ✅ Fixed  | Uses `cameFromMob` with PopScope |
| B5   | Layout bug: overlapping containers around NavigationButtons                  | ⬜ Pending | Check DetailScreen & ItemScreen layout |
| B6   | `CustomAppBarWidget` back button override inconsistency                      | ✅ Resolved | Your fallback logic is correct; `onBack` works per-screen as override |

---

## ✨ PLANNED FEATURE TRACKER

| Feature ID | Description                                                               | Status     | Notes                                                        |
|------------|---------------------------------------------------------------------------|------------|--------------------------------------------------------------|
| F1         | Add "Previous Chapter" button on first item of group                      | ⬜ Planned  | Symmetrical to “Next Chapter” logic                         |
| F2         | Add Group Picker Dropdown to *ItemScreens*                                | ⬜ Planned  | Matches dropdown behavior in *DetailScreens*                |
| F3         | Add "Restart Tour" button in Settings                                     | ⬜ Planned  | Toggles `TourManager.resetLandingTour()`                    |
| F4         | Expand tour to PathItemScreen, PathChapterScreen, LessonDetailScreen, etc | ⬜ Phase 2 | Will require tour checkpointing and router integration       |

---

## 🧠 REASONING CHECKPOINT

- ✅ Your current `CustomAppBarWidget` logic with:
  ```dart
  onPressed: onBack ?? defaultBackLogic,
  ```
  is optimal. We override per-screen (like in `ToolDetailScreen`) only when needed.

- ✅ Replacing `context.go(...)` with `Navigator.of(context).pop()` is crucial to avoid pushing duplicate screens or flattening the nav stack.

- ✅ The root causes of tool/part back navigation bugs were primarily due to:
  - Losing extras when calling `.go()`
  - Navigating *into* a screen with full context, but then navigating *out* without full back context

- ✅ GlobalKey reuse must be **avoided** (e.g., reusing same keys across screens causes them to disappear). You correctly switched to `GlobalKey(debugLabel: ...)` fresh for each transition.

---

## 📌 QUESTIONS TO CLARIFY BEFORE CONTINUING

1. 🔄 **Do you want to address layout bug B5 next?**
   - It's visible as a double container around NavigationButtons — easy to fix now.

2. 🔽 **Do you want to implement the Group Picker Dropdown on all *ItemScreens* next?**
   - This would bring them up to the gold standard of the *DetailScreens*.

3. 🧭 **Should I proceed with wiring Tour Phase 1 Replay Trigger into the Settings modal?**
   - This will give you a dev/test hook without resetting SharedPrefs manually.

4. 🧪 **Should we prepare a mini-tour for the next screen (e.g., PathItemScreen)?**
   - Would follow same model, and we’d reuse Option 1 key-passing.

---

## ✅ YOUR NEXT DECISION POINT

Choose any (or all) of the following to proceed:

- 🧹 Fix B5: Navigation layout padding
- 🔽 Start F2: Add Group Picker to ItemScreens
- 🔁 Add "Restart Tour" toggle in Settings
- 🗺️ Begin Phase 2 tour steps (PathItemScreen or beyond)

Let me know how you’d like to proceed, and I’ll supply exact instructions or full file diffs where needed.












Thanks — based on a full review of the uploaded codebase (`Z_bcc5_all_others_20250417_092933.txt`), I’ve traced the cause of the back button **crashes** (black or grey screen) on both `ToolDetailScreen` and `FlashcardDetailScreen` when returning after a chapter change. Here's a clean summary:

---

## 🧨 ROOT CAUSE: MISSING `transitionKey` & GLOBALKEYS ON BACK NAVIGATION

Both `ToolDetailScreen` and `FlashcardDetailScreen` generate “Next Chapter” transitions correctly using `TransitionManager.goToDetailScreen(...)`, but they do **not** include a valid `transitionKey`, and they **omit GlobalKeys in backExtra**.

That breaks the back button because:

1. `transitionKey` is required for keyed `PageTransitionSwitcher` rendering.
2. The `backDestination` exists, but the `backExtra` doesn’t include required GlobalKeys.
3. When the user taps the system back button, it calls `GoRouter.of(context).go(backDestination, extra: backExtra)` — but if `backExtra` is missing keys or transition data, the destination screen **crashes or fails to render properly**.

---

## ✅ WHAT WORKS (Lesson + Part Branches)

In those branches, you **always** pass:
- `transitionKey: UniqueKey().toString()` or equivalent
- `mobKey`, `settingsKey`, `searchKey`, `titleKey` in `backExtra`

✅ This pattern is followed in `LessonDetailScreen` and `PartDetailScreen`, which is why they don’t crash.

---

## ❌ WHAT’S BROKEN (Tool + Flashcard)

### ❌ In `ToolDetailScreen`, the transition call after chapter switch:

```dart
TransitionManager.goToDetailScreen(
  ...
  backDestination: '/tools/items',
  backExtra: {
    'toolbag': nextToolbag,
    'branchIndex': widget.branchIndex,
  },
  ...
);
```

🚫 Does **not** pass:
- `transitionKey`
- `mobKey`, `settingsKey`, `searchKey`, `titleKey`

Same pattern in `FlashcardDetailScreen` after category/chapter switch.

---

## ✅ FIX PLAN

### 1. Add `transitionKey`:
Change:
```dart
transitionKey: widget.transitionKey,
```
to:
```dart
transitionKey: UniqueKey().toString(),
```
(or a similar non-colliding key per screen).

### 2. Add `mobKey`, `settingsKey`, `searchKey`, `titleKey` to both:
- Direct `TransitionManager.goToDetailScreen(...)` call
- The `backExtra` map passed to that call

### 3. Ensure `backExtra` gets passed fully:
```dart
backExtra: {
  'toolbag': nextToolbag,
  'branchIndex': widget.branchIndex,
  'mobKey': widget.mobKey,
  'settingsKey': widget.settingsKey,
  'searchKey': widget.searchKey,
  'titleKey': widget.titleKey,
},
```

### 4. Do this in **both**:
- ToolDetailScreen: “Next Chapter” and picker navigation
- FlashcardDetailScreen: “Next Chapter” and picker navigation

---

Would you like:

- 🔧 Full replacement code blocks for those buttons in both screens?
- 🧪 A scoped fix just for “Next Chapter” to test first?
- 📦 A reusable `buildBackExtra()` method to clean this up app-wide?

Let me know how you want to roll out the fix — and I’ll provide exact, file-accurate replacements.