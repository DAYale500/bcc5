Thanks David. Yes, this is *exactly* the kind of deep-dive I can and will do. Here’s the **first structured stage** of what I found — starting with **suspected incomplete `.push(...)` or `.go(...)` calls** that **may not be passing required `GlobalKeys`** or other `extra` payload values that can cause:

> `_TypeError: type 'Null' is not a subtype of type 'GlobalKey<State<StatefulWidget>>'`

---

## ✅ Summary: Phase 1 Analysis Complete

We’ve now scanned the full uploaded source for all direct uses of:

- `GoRouter.of(context).push(...)`
- `GoRouter.of(context).pushNamed(...)`
- `context.push(...)`
- `context.pushNamed(...)`
- `context.go(...)`

We’re auditing each of them for **missing extras**, especially:
- `transitionKey`
- `mobKey`
- `settingsKey`
- `searchKey`
- `titleKey`

---

## 🔍 1. Confirmed Uses of `context.push(...)`

### ✅ **`/parts/items` push** — **complete**
Found in `PartZoneScreen`:
```dart
context.push(
  '/parts/items',
  extra: {
    'zone': zone,
    'transitionKey': 'part_items_${zone.toLowerCase()}_$timestamp',
    'slideFrom': SlideDirection.right,
    'transitionType': TransitionType.slide,
    'detailRoute': DetailRoute.branch,
  },
);
```
✔ Includes `transitionKey`, `slideFrom`, `transitionType`, and `detailRoute`. No issue here.  
🟨 **But it does *not* pass GlobalKeys** — we’ll trace how `/parts/items` then routes to `/parts/detail`.

---

## 🔍 2. Confirmed Uses of `context.go(...)`

### ⚠️ **[MISSING EXTRAS]** in `context.go(...)` inside `onBack` callbacks  
Found in multiple screens:
```dart
context.go(
  widget.backDestination,
  extra: {
    ...?widget.backExtra,
    'transitionKey': UniqueKey().toString(),
    'slideFrom': SlideDirection.left,
    'transitionType': TransitionType.slide,
  },
);
```

🟨 This pushes with a `transitionKey`, but **may omit** `mobKey`, `settingsKey`, etc., depending on what’s in `widget.backExtra`.  
→ **Back routing is potentially unsafe if `backExtra` doesn't carry those keys**, which **would result in the `_TypeError`** you're seeing.

---

## 🔍 3. Confirmed Uses of `TransitionManager.goToDetailScreen(...)`

Found in:
- `PartDetailScreen`
- `ToolDetailScreen`
- `LessonDetailScreen`

They push using:
```dart
TransitionManager.goToDetailScreen(
  context: context,
  screenType: ...,
  renderItems: ...,
  currentIndex: ...,
  branchIndex: ...,
  backDestination: ...,
  backExtra: {...},
  detailRoute: ...,
  direction: SlideDirection.right,
);
```

🟢 This method is good **as long as `backExtra` includes the four GlobalKeys**.  
→ This needs **manual audit**: does the caller include these keys?

🟠 **Most calls pass only `zone`, `toolbag`, etc. — not the keys.**

---

## ✅ Plan to Proceed

### 🔧 Step 1: Add Logger Tap into `TransitionManager.buildCustomTransition`

We’ll instrument a trace like this:
```dart
logger.i('🧪 transitionKey: $transitionKey | extras: ${state.extra}');
```

Let’s check what `state.extra` includes **at time of screen build**, especially in:
- `/parts/detail`
- `/lessons/detail`
- `/tools/detail`

That will reveal if the GlobalKeys are present or `null`.

---

### 🧪 Step 2: Add a GlobalKeyVerifierWidget

To place at the top of each *DetailScreen*, which logs:

```dart
logger.i('🔍 mobKey: ${widget.mobKey?.currentWidget}');
logger.i('🔍 settingsKey: ${widget.settingsKey?.currentWidget}');
```

This will verify *at runtime* what’s being received.

---

### 📜 Step 3: Prepare Report of All `.go()` or `.push()` Into Each Detail Screen

We’ll explicitly enumerate:
- `/lessons/detail`
- `/tools/detail`
- `/parts/detail`

And whether each push includes the GlobalKeys.

---

### 🧭 Step 4: Prepare a Global Debug Wrapper for All Routes

This wrapper intercepts *all* `.push(...)` or `.go(...)` calls and logs:
```dart
logger.i('🧭 push to: $route with extras: $extra');
```

We can add this to `GoRouter.of(context).push(...)` by wrapping or subclassing `GoRouter`.

---

## ✅ Ready to Execute

Which of these would you like me to start with:
1. Add **instrumentation** to `TransitionManager.buildCustomTransition(...)`?
2. Provide a **GlobalKeyVerifierWidget** to inject into all *DetailScreens?
3. Enumerate **every route push** into `/lessons/detail`, `/tools/detail`, etc. to audit missing keys?
4. Wrap `GoRouter` globally to intercept and log all `push()` and `go()`?

Let me know where you want to start and I’ll execute precisely and completely.






Perfect — let's begin our **clear, structured debugging workflow**.

---

## ✅ PHASE 1.1: Add logging inside `buildCustomTransition()`
**File**: `lib/utils/transition_manager.dart`  
**Goal**: Log the `.extra` passed into every navigation transition.

---

### 🔧 Step 1 — Locate the method:

Search for this method in `transition_manager.dart`:

```dart
static Page<dynamic> buildCustomTransition({
```

---

### 🔁 Step 2 — Paste this block **immediately after**:

```dart
final extras = state.extra as Map<String, dynamic>? ?? {};
```

Replace:

```dart
final extras = state.extra as Map<String, dynamic>? ?? {};
```

With this:

```dart
final extras = state.extra as Map<String, dynamic>? ?? {};

logger.i(
  '🧪 [TransitionManager] buildCustomTransition extras dump:\n'
  '  ├─ transitionKey: $transitionKey\n'
  '  ├─ slideFrom: ${extras['slideFrom']}\n'
  '  ├─ transitionType: ${extras['transitionType']}\n'
  '  ├─ detailRoute: ${extras['detailRoute']}\n'
  '  ├─ mobKey: ${extras['mobKey']?.debugLabel ?? extras['mobKey']}\n'
  '  ├─ settingsKey: ${extras['settingsKey']?.debugLabel ?? extras['settingsKey']}\n'
  '  ├─ searchKey: ${extras['searchKey']?.debugLabel ?? extras['searchKey']}\n'
  '  └─ titleKey: ${extras['titleKey']?.debugLabel ?? extras['titleKey']}',
);
```

---

## ✅ PHASE 2.1: Add Key Verifier in `LessonDetailScreen`

**File**: `lib/screens/lessons/lesson_detail_screen.dart`  
**Goal**: Confirm that all GlobalKeys were received.

---

### 🔧 Step 3 — Open `LessonDetailScreen` and locate `initState()`:

Inside `_LessonDetailScreenState`, find:

```dart
@override
void initState() {
  super.initState();
```

---

### 🔁 Step 4 — Add this block **after `super.initState();`**:

```dart
logger.i(
  '🧪 LessonDetailScreen GlobalKeys:\n'
  '  ├─ mobKey: ${widget.mobKey.debugLabel}\n'
  '  ├─ settingsKey: ${widget.settingsKey.debugLabel}\n'
  '  ├─ searchKey: ${widget.searchKey.debugLabel}\n'
  '  └─ titleKey: ${widget.titleKey.debugLabel}',
);
```

---

## ✅ Summary of Changes to Make Now

| File                                      | Location                        | Action                         |
|-------------------------------------------|----------------------------------|--------------------------------|
| `lib/utils/transition_manager.dart`       | Inside `buildCustomTransition`  | Log all extras incl. keys      |
| `lib/screens/lessons/lesson_detail_screen.dart` | `initState()` of `_LessonDetailScreenState` | Log all received GlobalKeys |

---

Once added, **run the app**, trigger the crash, and check the logs.

Reply with the log output from:
- `🧪 [TransitionManager] buildCustomTransition extras dump:`
- `🧪 LessonDetailScreen GlobalKeys:`

Then I’ll move on to PartDetailScreen and ToolDetailScreen (Phase 2.2, 2.3) or begin Phase 3 key enumerations.

Let’s hunt it down.



















logger.i(
  '🧪 [TransitionManager] buildCustomTransition EXTRAS DUMP\n'
  ' ├─ route: ${state.location}\n'
  ' ├─ transitionKey: $transitionKey\n'
  ' ├─ detailRoute: ${extras['detailRoute']}\n'
  ' ├─ slideFrom: ${extras['slideFrom']}\n'
  ' ├─ transitionType: ${extras['transitionType']}\n'
  ' ├─ mobKey: ${_safeKey(extras['mobKey'])}\n'
  ' ├─ settingsKey: ${_safeKey(extras['settingsKey'])}\n'
  ' ├─ searchKey: ${_safeKey(extras['searchKey'])}\n'
  ' └─ titleKey: ${_safeKey(extras['titleKey'])}',
);