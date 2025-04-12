I would like to build a Tour. The idea is that a (new) user is unfamiliar with the way the app operates, so the tour would show them how to make the most out of the app. 

That's a great idea — an interactive **Tour** is one of the most effective ways to onboard new users and help them understand both the structure and the hidden gems of your app. Here are a few thoughts to help you design and implement this:

---

### 🚀 GOALS OF THE TOUR

1. **Orientation**: Help users understand what the app is *for* and how it's organized.
2. **Navigation**: Teach them how to move between paths, parts, tools, flashcards, etc.
3. **Actionable Tips**: Show them where to tap and why (e.g., how to resume a voyage, flip a flashcard, update settings).
4. **Trust and Confidence**: Let them feel they won’t get lost — they can explore and always return to safe harbor.

---

### 🧭 TOUR DESIGN STRATEGY

#### 1. **Trigger Options**
- ✅ First-time only (using SharedPreferences to store completion flag)
- 📘 Optional restart from Settings (“Restart App Tour”)
- 📍 Optional prompt from LandingScreen (“Take a quick tour?”)

#### 2. **Tour Styles**
Choose one or more:
- 🫣 **Overlay Coach Marks** (e.g., package like `tutorial_coach_mark` or `showcaseview`)
  - Dim screen except around the thing you're highlighting
  - Good for buttons, tabs, or icons

- 🧭 **Step-based Guide Modal**
  - Full-screen overlay that walks user through concepts with "Next" buttons
  - Example: “This is the Learning Paths screen. Tap a chapter to get started.”

- 🗺️ **Narrated Walkthrough**
  - Actually *navigates* to screens (e.g., tap into a path, show how flashcards work)
  - Pros: more immersive
  - Cons: requires smart backtracking logic and possibly mock content in dev mode

---

### 🪄 EXAMPLE TOUR STEPS (suggested flow)

| Step | Screen | Highlight / Focus |
|------|--------|--------------------|
| 1 | LandingScreen | Explain bottom nav (Harbor, Courses, etc.) |
| 2 | Tap "Set Sail" → PathChapterScreen | “Tap a chapter to explore” |
| 3 | PathItemScreen | “Each chapter has bite-sized lessons, tools, and drills.” |
| 4 | Tap a lesson → LessonDetailScreen | Highlight nav buttons, group picker |
| 5 | Flashcard flip feature | “Tap to flip. Swipe to learn fast.” |
| 6 | MOB button | “Tap this if someone falls overboard!” (serious moment) |
| 7 | Settings modal | Show how to update vessel info, enable reminders |
| ✅ | End | “That’s it! Ready to explore. You can restart the tour any time from Settings.” |

---

### ⚙️ IMPLEMENTATION PLAN (in BCC5 style)

#### 1. **Track Tour Completion**
```dart
class TourManager {
  static const _hasCompletedTour = 'hasCompletedTour';

  static Future<bool> hasCompletedTour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCompletedTour) ?? false;
  }

  static Future<void> markTourComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedTour, true);
  }

  static Future<void> resetTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasCompletedTour);
  }
}
```

#### 2. **Choose a Tour Library or Build Custom**
Popular packages:
- [`tutorial_coach_mark`](https://pub.dev/packages/tutorial_coach_mark)
- [`showcaseview`](https://pub.dev/packages/showcaseview)
- Or, build a lightweight `TourOverlay` widget

#### 3. **Start Tour Logic**
```dart
void checkAndStartTour(BuildContext context) async {
  if (!(await TourManager.hasCompletedTour())) {
    Future.microtask(() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AppTourScreen(),
      ));
    });
  }
}
```

---

### ✅ OPTIONAL BONUS FEATURES
- 🎯 Resume where user left off if they quit mid-tour
- 💬 Voice narration or captions (for accessibility)
- 🧪 A/B test: users who take the tour vs those who don’t (retention metric?)

---

Would you like to:
1. Start by building a simple `AppTourScreen`?
2. Implement coach marks (step-by-step highlight overlays)?
3. Navigate the user through a guided path (scripted journey)?

Let me know how you’d like to begin and I can scaffold it with your existing architecture in mind.











update april 11 1300

Awesome — let’s start with a scaffolded implementation of `tutorial_coach_mark` in BCC5. Here’s what we’ll do step-by-step. This will only affect the UI when explicitly triggered (e.g., by a “Show Me Around” button), so we can develop it safely:

---

### ✅ Step 1: Add the dependency

In your `pubspec.yaml`, add:

```yaml
dependencies:
  tutorial_coach_mark: ^1.2.4
```

Then run:

```bash
flutter pub get
```

---

### ✅ Step 2: Choose targets

Let’s use **LandingScreen** for the first sample. We’ll highlight:

1. The bottom nav bar (Harbor icon)
2. The Courses branch
3. The “Set Sail on a New Course” button
4. The “Resume Your Voyage” button (if visible)

---

### ✅ Step 3: Scaffold the logic in `landing_screen.dart`

I’ll generate this for you in the next message. Want me to show you just the `LandingScreen` update first, or do both `LandingScreen` and `PathItemScreen` together?

re: 1
done

re: ✅ Step 2: Choose targets
Let’s use LandingScreen for the first sample. We’ll highlight:
The bottom nav bar (Harbor icon)
    what each means/does
Competent Crew button
MOB
Settings


<<below are not on landdingScreen, add them later>>
The Courses branch
The “Set Sail on a New Course” button
The “Resume Your Voyage” button (if visible) 




