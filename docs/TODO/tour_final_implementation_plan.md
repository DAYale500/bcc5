Great question — now that all detail screens are tour-ready (thanks to the refactors and infrastructure we put in place), the **Tour Overlay** work can focus solely on UX execution, overlay logic, and state tracking. Below is a breakdown of what’s left, categorized by **decisions**, **tasks**, and **any remaining refactors** you might want to consider:

---

## ✅ **STATUS: We Are Ready To Start Tour Overlay Implementation**

We have:
- Clean `GlobalKey`s on all highlightable widgets (AppBar icons, title, etc.).
- Navigation behavior stable and reusable.
- GroupPicker removed (no longer a source of complexity).
- All major screens using consistent `TransitionManager` patterns.

---

## 🧠 DECISIONS TO MAKE

### 1. **Triggering the Tour**
- ✅ Manual: button/tap starts the tour (easiest).
- 🔲 Automatic: first visit to screen or first-time user (requires persistent state).
- 🔲 Admin/QA toggle: activated via special build flag or gesture?

### 2. **Tour Progression**
- ✅ One step at a time with “Next” / “Skip” controls?
- 🔲 Autoplay mode that progresses every few seconds?
- 🔲 Tooltip style vs. full-screen darkened overlay?

### 3. **Tour Content**
- ✅ Tooltip text per element?
- 🔲 Title + subtitle per step?
- 🔲 Link to help page, or embedded video in last step?

---

## ✅ REQUIRED TASKS (TOUR INFRASTRUCTURE)

| Task | Description |
|------|-------------|
| **1. Create TourOverlay Widget** | Shows a tooltip/overlay near a `GlobalKey`, dims background. |
| **2. Build Step Controller** | Manages state: which step is active, when to advance, when to close. |
| **3. Hook into GlobalKeys** | Resolves `key.currentContext?.findRenderObject()` for positioning. |
| **4. Display Controls** | "Next", "Back", "Skip", "Got it" etc. within overlay. |
| **5. Optionally: Persist Tour State** | `SharedPreferences` or `Hive` for "hasSeenTour" per screen. |

---

## ✳️ OPTIONAL REFACTOR CONSIDERATIONS

| Area | Why Consider |
|------|--------------|
| ✅ **Wrap screen body in `Stack`** | We already do this! Required for tour overlays. |
| 🔲 Use `TourStepConfig` model | Define steps with: label, GlobalKey ref, alignment, etc. |
| 🔲 Abstract tour entry point | Consistent entry for all detail screens — `TourManager.launch(context, steps)` |
| 🔲 Modular tour buttons | So we don’t duplicate “Next/Skip” logic everywhere. |

---

## 🧩 SAMPLE TOUR OVERLAY STRUCTURE

```dart
class TourOverlay extends StatelessWidget {
  final GlobalKey targetKey;
  final String title;
  final String description;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    // Overlay entry logic here
  }
}
```

---

## 🚀 NEXT STEPS

If you’re ready to begin, we can proceed with:

1. Creating a reusable `TourOverlay` widget
2. Defining tour steps for one screen (e.g. `LessonDetailScreen`)
3. Mounting the overlay and progressing through each element

Would you like to begin with the `TourOverlay` widget and controller first? I can walk you through that implementation next.