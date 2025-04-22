Here’s a comprehensive sweep and documentation of **where `_stripGlobalKeys(...)` should be applied** throughout your BCC5 codebase, based **only on the uploaded project files**. The goal is to ensure no `GlobalKey` survives across transitions via `extra` to prevent `Duplicate GlobalKey` errors like the one you're currently battling.

---

## 🔎 **Current Usage Summary**
You are already applying `_stripGlobalKeys(...)` in `TransitionManager.goToDetailScreen`, like so:

```dart
'backExtra': _stripGlobalKeys(backExtra),
```

This is ✅ good. But **other `.go()` and `.push()` calls still pass raw GlobalKeys**. That creates risk.

---

## ✅ **Recommended `_stripGlobalKeys()` Patch Locations**

### 1. **LandingScreen navigation buttons**
```dart
context.go(
  '/learning-paths/competent-crew',
  extra: {
    'slideFrom': SlideDirection.right,
    'transitionType': TransitionType.slide,
    'detailRoute': DetailRoute.path,
    'mobKey': mobKey,
    'settingsKey': settingsKey,
    'searchKey': searchKey,
    'titleKey': titleKey,
  },
);
```
🔧 **Patch:** Wrap `extra:` with a helper like:

```dart
extra: _stripGlobalKeys({
  ... // keys here
})
```

This appears **twice** in the same file: once for a button and once for a popup menu. Both must be patched.  
**Location:** `lib/screens/landing_screen/landing_screen.dart`

---

### 2. **LessonDetailScreen back button (commented example)**
```dart
// context.go(
//   widget.backDestination,
//   extra: {
//     ...widget.backExtra,
//     'transitionKey': UniqueKey().toString(),
//     'slideFrom': SlideDirection.left,
//     'transitionType': TransitionType.slide,
//   },
// );
```
🔧 If this block is ever uncommented: ensure `...widget.backExtra` is sanitized.

```dart
extra: {
  ...(TransitionManager._stripGlobalKeys(widget.backExtra) ?? {}),
  ...
}
```

**Location:** `lesson_detail_screen.dart`

---

### 3. **PathChapterScreen back button**
```dart
onBack: () {
  context.go(
    '/',
    extra: {
      'slideFrom': SlideDirection.left,
      'transitionType': TransitionType.slide,
      'detailRoute': DetailRoute.path,
    },
  );
},
```

🔧 This example is “safe” only because it omits keys. But if you later pass any keys in `extra`, you **must sanitize**. Add a comment like:

```dart
// ⚠️ If passing GlobalKeys in extra here, sanitize via _stripGlobalKeys()
```

**Location:** `lib/screens/paths/path_chapter_screen.dart`

---

### 4. **Unidentified switch-case navigation**
```dart
switch (result.type) {
  case RenderItemType.lesson:
    context.go('/lessons/detail', extra: extra);
```

🔧 You must ensure `extra` is passed through `_stripGlobalKeys()` before this `switch`.

**Location:** Unknown class, but visible in:
```dart
case RenderItemType.flashcard:
  context.go('/flashcards/detail', extra: extra);
```

**Location:** Likely a search result handler or content dispatcher

---

## 🧪 Safe Drop-In Sanitizer

For any `extra` that may contain `GlobalKey`s:

```dart
Map<String, dynamic>? _stripGlobalKeys(Map<String, dynamic>? input) {
  if (input == null) return null;
  final copy = Map.of(input);
  copy.removeWhere((_, value) => value is GlobalKey);
  return copy;
}
```

---

## ✅ Summary Table

| Location                                      | Action Needed                    | File                                                   |
|----------------------------------------------|----------------------------------|--------------------------------------------------------|
| LandingScreen → Path Button                  | wrap `extra` in `_stripGlobalKeys` | `landing_screen.dart` |
| LandingScreen → Popup Path Picker            | wrap `extra` in `_stripGlobalKeys` | `landing_screen.dart` |
| LessonDetailScreen (commented go call)       | sanitize `backExtra` if used      | `lesson_detail_screen.dart` |
| PathChapterScreen onBack                     | currently safe, add warning       | `path_chapter_screen.dart` |
| Search/tap-based dispatcher with `context.go`| sanitize `extra` before use       | unidentified handler |

---

## 🧱 Optional: Central Helper

You could also wrap `.go(...)` and `.push(...)` in your own methods:

```dart
void safeGo(BuildContext context, String path, Map<String, dynamic>? extra) {
  context.go(path, extra: _stripGlobalKeys(extra));
}

void safePush(BuildContext context, String path, Map<String, dynamic>? extra) {
  context.push(path, extra: _stripGlobalKeys(extra));
}
```

Then globally replace `context.go(` and `context.push(` with `safeGo(` / `safePush(`.

---

Would you like help generating these patches in-place across your repo now?











update to debug 

Thanks for the detailed logs — and yes, the issue still persists due to **GlobalKey reuse** between `LessonModuleScreen` and `LessonItemScreen`. Despite the recent changes, the root problem remains:

---

### 🔥 Root Cause:
You're still passing **the same `mobKey`, `searchKey`, `settingsKey`, and `titleKey`** from `LessonModuleScreen` to `LessonItemScreen`.

That means:
- When the user taps a module in `LessonModuleScreen`, it pushes `LessonItemScreen`.
- `LessonItemScreen` now has **the exact same GlobalKeys**.
- When Flutter tries to build the new widget tree, it **detects those GlobalKeys already exist in the old screen**, violating its rule: _GlobalKeys must be unique in the widget tree_.
- Even if the previous screen is not visible, **it still exists in memory**, so key reuse crashes the app.

---

### ✅ Fix: Stop Passing Keys from `LessonModuleScreen`

You already fixed `LessonDetailScreen` to **own its own keys internally** — do the same for `LessonItemScreen`.

---

### 🔧 Step-by-Step Fix

#### 1. **Update `LessonModuleScreen`**

Remove `mobKey`, `searchKey`, `settingsKey`, and `titleKey` from the `.push()` call:

```dart
context.push(
  '/lessons/items',
  extra: {
    'module': moduleName,
    'transitionKey': 'lesson_items_${index}_$timestamp',
    'transitionType': TransitionType.slide,
    'slideFrom': SlideDirection.right,
    'detailRoute': DetailRoute.branch,
  },
);
```

#### 2. **Update the GoRoute for `/lessons/items`**

Remove the fallback logic for mob/search/settings/titleKey — just create fresh ones inline in the `LessonItemScreen` constructor:

```dart
child: LessonItemScreen(
  module: module,
  mobKey: GlobalKey(debugLabel: 'MOBKey'),
  settingsKey: GlobalKey(debugLabel: 'SettingsKey'),
  searchKey: GlobalKey(debugLabel: 'SearchKey'),
  titleKey: GlobalKey(debugLabel: 'TitleKey'),
),
```

---

### 🧪 Bonus Debugging Tip:
You can prove the keys are clashing by searching for lines like:
```
├─ mobKey: [GlobalKey#14c25 MOBKey]
```
If that same key ID shows up **again later**, that's your duplicate.

---

Once you remove shared keys between module and item screens, this crash should stop happening. Want help checking for other spots where keys are being reused across screens?