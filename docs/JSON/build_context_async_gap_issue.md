Here’s a clean Markdown snippet you can add to your repo at `lint_guides/use_build_context_synchronously.md`:

---

````markdown
# `use_build_context_synchronously` Linter Error

## 🔍 What It Means

This Flutter linter rule prevents you from using a `BuildContext` after an `await` unless the context is **still valid**. Flutter wants you to *explicitly verify* that the widget associated with the context is still mounted.

---

## ⚠️ Common Trigger

Using `context` (or a local copy) across an `await` without checking:

```dart
final localContext = context;
await someAsyncOp();
// ❌ Still triggers: context might be stale!
Navigator.push(localContext, ...);
````

---

## ✅ Recommended Pattern

Instead, check `localContext.mounted` **inside** the async function where the context is used:

```dart
onPressed: () {
  final localContext = context;
  if (!localContext.mounted) return;

  _handleRestart(localContext);
}

Future<void> _handleRestart(BuildContext localContext) async {
  if (!localContext.mounted) return;

  final data = await someAsyncOp();

  if (!localContext.mounted) return;

  Navigator.push(localContext, ...); // ✅ Now safe
}
```

---

## 🧠 Key Points

* ✅ Use `final localContext = context;` before `await`
* ✅ Use `if (!localContext.mounted) return;` **both before and after** any `await`
* ❌ Don’t rely solely on `if (!mounted) return;` from the `State` class — that only applies to `this.context`
* ✅ This works even when passing `context` into another method

---

## 💬 Why This Matters

* Prevents crashes from using invalid `BuildContext`
* Ensures safe navigation, modal triggering, and rebuild logic
* Resolves persistent linter errors cleanly

---

## 🧩 Example Use Case

```dart
ElevatedButton(
  onPressed: () {
    final localContext = context;
    if (!localContext.mounted) return;

    _navigateToNextScreen(localContext);
  },
)

Future<void> _navigateToNextScreen(BuildContext localContext) async {
  if (!localContext.mounted) return;

  await Future.delayed(Duration(milliseconds: 500));

  if (!localContext.mounted) return;

  Navigator.of(localContext).push(...);
}
```

---

✅ This approach satisfies both runtime safety and linter correctness.

```

---

Let me know if you’d like a Dart code comment block version of this too for in-source documentation.
```







































Absolutely — here's a thorough, chronological documentation of this `use_build_context_synchronously` issue and how we finally resolved it.

---

## ✅ Summary: `use_build_context_synchronously` Linter Issue in Flutter

### 📌 **The Problem**

Flutter's linter flags use of a `BuildContext` after an `await` unless:

* The usage is **guarded** by `if (!mounted) return;` (or equivalent), **and**
* That guard is logically tied to the **actual context object** being used.

In your case:

* The linter flagged this code inside `onRestartAtFirstGroup`, even though you:

  * ✅ Captured `context` into a local variable: `final localContext = context;`
  * ✅ Checked `if (!mounted) return;` before any async operation
* But the warning **persisted** — and appeared in lines like:

```dart
final localContext = context;
...
await buildRenderItems(...);
...
goToFlashcardDetail(context: localContext, ...); // ❌ still flagged!
```

### 🤔 Why This Happened

Flutter's `use_build_context_synchronously` warning *tracks the specific context object* that crosses the `await` boundary. If you:

* Use `State.context` (i.e., `this.context`) directly after an `await` without **checking `mounted` first**, it will warn.
* Pass that context into another function (like `_handleRestart()`), it expects **`localContext.mounted`** to be checked explicitly inside that function.

Even if:

* You’ve done `if (!mounted) return;` already
* You’re using `localContext` instead of `context`
* You split logic into helpers

…it will still warn if there is **no `localContext.mounted` check inside the target function.**

---

## ❌ Strategies That Did *Not* Work

| Attempt                                                        | Description                              | Outcome                                                               |
| -------------------------------------------------------------- | ---------------------------------------- | --------------------------------------------------------------------- |
| ✅ `if (!mounted) return;` before `await`                       | Safe in many cases                       | ❌ Still flagged because `context` was passed into a separate function |
| ✅ `final localContext = context;` before `await`               | Standard practice                        | ❌ Linter still flagged because `localContext` was used later          |
| ✅ Used `Future.microtask(() { ... })`                          | Defers the navigation to avoid async gap | ❌ Still flagged — likely due to the closure carrying context          |
| ✅ Extracted navigation logic to `_handleRestart(BuildContext)` | Cleaner, modular                         | ❌ Still flagged unless `localContext.mounted` used inside             |

---

## ✅ The Solution That Worked

### 🔑 **Use `localContext.mounted` inside the function that uses it**

This satisfies the linter fully:

```dart
Future<void> _handleRestart(BuildContext localContext) async {
  if (!localContext.mounted) return;

  // await something
  final renderItems = await buildRenderItems(...);

  if (!localContext.mounted) return;

  // ✅ safe to use context now
  goToFlashcardDetail(context: localContext, ...);
}
```

### ✅ Why It Works

* `BuildContext` implements `mounted`, just like `State`.
* Checking `localContext.mounted` tells the analyzer: “Yes, I’ve verified this exact context is still valid.”
* This is **required** if you’re passing `context` into another method and using it *after an await* inside that method.

---

## 🔁 Reusable Pattern for the Future

Here's a reusable pattern that **avoids linter errors**:

```dart
onPressed: () {
  final localContext = context;
  if (!localContext.mounted) return;

  _safeAsyncHandler(localContext);
}

Future<void> _safeAsyncHandler(BuildContext localContext) async {
  if (!localContext.mounted) return;

  final data = await someAsyncOp();

  if (!localContext.mounted) return;

  Navigator.push(localContext, ...);
}
```

Use this in:

* Navigation buttons
* Modal triggers
* Deep transition flows
* Any time you're deferring `context`-driven work across async calls

---

## 🧠 Lessons Learned

* ✅ Always **check `localContext.mounted`**, not just `mounted`, when `context` is passed into an async method.
* ✅ Avoid using `context` directly across async gaps, even if wrapped in `microtask`, closures, or helpers.
* ✅ When in doubt: assume the linter wants a guard **at the point of context usage**, not just before the async gap.

---

Would you like me to turn this into a Markdown snippet you can keep in your repo (`lint_guides/use_build_context_synchronously.md` or similar)?
































Excellent question — and the answer gets at the heart of **why the JSON conversion required a deep refactor** across your app.

### 🧩 Why So Many `use_build_context_synchronously` Errors?

#### 🔄 **Before (Dart Repository Approach)**

Your app loaded all content **synchronously** from in-memory Dart repositories like:

```dart
final lesson = LessonRepositoryIndex.getLessonById(id); // Fast and sync
```

This meant you could safely use `BuildContext` before/after without issues, because **there were no async calls**.

---

#### 🗂️ **After (JSON Repository Approach)**

Once you moved to loading from JSON:

```dart
final renderItems = await buildRenderItems(ids: [...]);
```

The logic became **asynchronous**, because:

* JSON files must be **read from disk** (via `rootBundle.loadString`)
* They must then be **parsed into Dart objects** (via `jsonDecode`)
* This can take **tens or hundreds of milliseconds**, depending on file size and device

---

### ⚠️ Why This Triggers the Error

Dart’s linter now **strictly flags** any time you use `BuildContext` *after* an `await` unless:

* You check `if (!context.mounted)` first
* Or you isolate the logic into a fresh synchronous context (like a closure)

This is meant to prevent bugs like:

* Navigating **after** a widget was disposed
* Calling `ScaffoldMessenger.of(context)` after the screen was popped
* Animating or focusing something that’s no longer mounted

---

### 💥 Why It Happened Everywhere

Because your `buildRenderItems()` became async, **any usage of it inside a callback or tap handler** now introduced an async gap. That **rippled through**:

* All GroupButton taps (tools, parts, lessons)
* The SearchModal `onTap`
* Chapter "Set Sail"
* Path detail screen transitions
* Tool navigation
* MOB override logic
* Custom onboarding transitions

Each of these had to be guarded or refactored to prevent illegal use of `context`.

---

### 🛠️ Summary of Root Cause

| Before (Dart Repo)         | After (JSON Loading)                |
| -------------------------- | ----------------------------------- |
| Synchronous access         | Asynchronous file loading           |
| `BuildContext` always safe | Now must **guard** with `.mounted`  |
| No `await` = no issues     | `await` = context must be validated |
| UI transitions simple      | Must protect all transitions        |

---

### ✅ Solution Pattern

To fix:

* Wrap `context` use in `if (!context.mounted) return`
* Or store it as a local `final` before `await`, and **guard all post-await usages**

---

Let me know if you want me to **audit all known `await` calls using `buildRenderItems()`** and provide a checklist for safe usage — happy to generate a quick report.




