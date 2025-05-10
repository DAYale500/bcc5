# 🧭 BCC5 Onboarding Tour System – Developer Guide

This document explains how the BCC5 onboarding tour is currently implemented, how different components interact, and how to extend the system with new steps and screens. It is intended to help onboard new developers to the tour system.

---

## 📁 File Structure Overview

```text
lib/
├── screens/
│   └── landing_screen/landing_screen.dart      # LandingScreen logic, keys, state
├── widgets/
│   ├── tour/
│   │   └── landing_screen_tour.dart            # Landing tour registration & restart logic
│   └── settings_modal.dart                     # UI and triggers to start/reset the tour
```

---

## 🧠 Key Concepts

### 🎯 1. Centralized Tour Logic per Screen

Each screen with a tour has its own tour file (`landing_screen_tour.dart`). This file defines:

* When to start the tour
* What keys to highlight
* How to restart from the Settings modal

### 🧩 2. GlobalKeys for Targeting UI Elements

Each target element in a screen’s UI is assigned a `GlobalKey`. For example:

```dart
final GlobalKey _keyMOBButton = GlobalKey();
```

Public getters expose these safely:

```dart
GlobalKey get mobKey => _keyMOBButton;
```

### 📌 3. Singleton-like State Access

To allow external triggers (like a settings modal) to restart the tour, `LandingScreen` exposes its state:

```dart
static LandingScreenState? _state;
static LandingScreenState? getState() => _state;
```

This is set in `initState()`:

```dart
LandingScreen._state = this;
```

⚠️ This assumes only one instance of `LandingScreen` is active. If multiple instances ever exist, a registry or state management approach will be required.

### 🪄 4. Triggering the Tour

The tour auto-starts only on first app launch, or can be manually triggered from the Settings modal.

```dart
if (await LandingScreenTour.shouldStart()) {
  LandingScreenTour.start(...);
}
```

From settings:

```dart
LandingScreenTour.restartNow(...);
```

---

## 🔗 File Relationships

### `landing_screen.dart`

* Owns private `GlobalKey`s for UI widgets
* Exposes public getters to access them externally
* Stores its `State` in `LandingScreen._state`
* Triggers the tour in `initState()`

### `landing_screen_tour.dart`

* Contains `shouldStart()` logic (first launch only)
* `start()` builds the steps with `TutorialCoachMark`
* `restartNow()` allows manual tour triggering

### `settings_modal.dart`

* Calls `LandingScreen.getState()`
* Uses `LandingScreenTour.restartNow(...)`
* Uses `Future.delayed(...)` to wait until the modal closes before triggering

---

## ➕ How to Add a New Tour Step

### 1. Add a `GlobalKey`

In your screen’s State class:

```dart
final GlobalKey _keyExampleButton = GlobalKey();
GlobalKey get exampleKey => _keyExampleButton;
```

### 2. Wrap Target Widget

```dart
KeyedSubtree(
  key: _keyExampleButton,
  child: ElevatedButton(...),
)
```

### 3. Add Step to `landing_screen_tour.dart`

```dart
TutorialCoachMark(...
  targets: [
    TargetFocus(..., keyTarget: mobKey, ...),
    TargetFocus(..., keyTarget: exampleKey, ...),
  ]
)
```

### 4. Add Getter to LandingScreenState

If you didn’t already:

```dart
GlobalKey get exampleKey => _keyExampleButton;
```

---

## ➕ How to Add a New Screen Tour

1. **Create `screen_name_tour.dart`**

   * Follow the `landing_screen_tour.dart` pattern
   * Export `start()`, `restartNow()`, `shouldStart()`

2. **Expose State from `screen_name.dart`**

```dart
static ScreenNameState? _state;
static ScreenNameState? getState() => _state;
```

Set this in `initState()`.

3. **Expose keys via public getters**

```dart
GlobalKey get someKey => _somePrivateKey;
```

4. **Wrap target widgets with keys**
   Use `KeyedSubtree` or assign key directly depending on the widget type.

5. **Update Settings modal**
   Optionally add a button in `settings_modal.dart` to trigger this tour using `.getState()` and the `.restartNow()` method.

---

## 🧠 Gotchas & Non-obvious Notes

* ✅ **Don’t access context after async gaps** unless you’ve checked `mounted`.
* ✅ **Defer triggering tours with `Future.delayed`** after a modal closes, to avoid timing issues.
* ⚠️ `TutorialCoachMark` requires the widget to be laid out and rendered to compute its position.
* ✅ The tour overlay is non-modal; make sure the app state isn’t lost if the user taps away.
* ⚠️ If you later modularize or lazily load screens, you’ll need to rework the `.getState()` pattern.

---

## 🧼 Future Refactor Ideas

* ✅ Replace manual `LandingScreen._state` pattern with a `TourController` using Riverpod
* 🧠 Move all tour step descriptions to a centralized `tour_descriptions.dart` file
* 🧪 Add integration tests for tour step visibility and step sequencing

---

## ✅ Summary

This system is cleanly scoped, avoids race conditions, and is extendable without modifying core logic. As long as screen states are singleton-like, the current implementation is stable. Adding new steps or screens is straightforward with the existing pattern.

> For further improvement, consider consolidating tour management into a shared `TourManager` that can handle all screens uniformly.
