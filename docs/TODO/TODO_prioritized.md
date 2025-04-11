Awesome — bundling your TODOs into **milestones** can help you:

- ✅ Focus on deliverables with clear outcomes  
- 🧭 Prioritize based on **value**, not just category  
- 🚢 Sequence work toward launches, releases, or testing phases  

Here's a milestone-based restructure of your TODO list:

---

## 🚀 **Milestone 1: MVP Polish & Launch Readiness**

> Focus on core functionality, UI clarity, and structural transitions to get the app stable, intuitive, and test-ready.

### 🔹 Navigation & Transitions
- [ ] 2.1.1 Modularize transition builders into `transition_builders.dart`
- [ ] 2.1.3 Refactor all routes to use named transitions
- [ ] 2.2.2 Audit all `.go()` calls for `transitionKey` inclusion
- [ ] 2.2.3 Fix `.push()` vs `.go()` (especially in `flashcard_item_screen`)
- [ ] 2.2.1 Add directional slide awareness in `MainScaffold`

### 🔹 UI Polish
- [ ] 3.1.1 Grey out inactive prev/next buttons
- [ ] 3.1.2 Add loading spinner during content load
- [ ] 3.1.3 Handle empty chapter gracefully
- [ ] 3.1.5 Add refresh button to content screens

### 🔹 Learning Path UX
- [ ] 1.1.1 Add “New Crew” and “Rusty Sailor” onboarding choices
- [ ] 1.2.1 Add breadcrumb trail for item/detail navigation
- [ ] 1.1.3 Wire up "Resume your voyage" logic

### 🔹 Flashcard Fixes
- [ ] 5.1.1 Ensure `flashcard` items in paths navigate to `FlashcardDetailScreen`

---

## 📦 **Milestone 2: Feature Expansion**

> Introduce richer capabilities for interaction, recall, and structure.

### 🔹 Flashcard Upgrades
- [ ] 5.1.2 Add "All" button → jump to `FlashcardDetailScreen`
- [ ] 5.1.3 Add "Random" flashcard picker → show one via detail screen

### 🔹 Checklist Interactions
- [ ] 8.1.1 Make checklists tappable (toggle completed)
- [ ] 8.1.2 Add “reset all” and “show incomplete”
- [ ] 8.1.4 Support custom checklists / editable copies

### 🔹 Repos & Tooling
- [ ] 4.1.1 Merge tool categories into:
  - Emergency Procedures (top priority)
  - Calculations
  - Checklists
  - References
- [ ] 4.1.3 Convert tool repos to local JSON format
- [ ] 4.1.4 Add more COLREGs + tool data

### 🔹 Emergency Feature
- [ ] 7.1.1 Add MOB lifering button
- [ ] 7.1.2 Log GPS on press
- [ ] 7.1.3 Route to MOB procedure checklist

---

## 🎯 **Milestone 3: User Personalization & Power Features**

> Add smart, user-centered functionality that improves long-term engagement.

### 🔹 Personalization
- [ ] 3.2.1 Bookmark/save items
- [ ] 3.2.2 Track progress through paths/items
- [ ] 3.2.14 Sync progress across devices
- [ ] 4.2.1 Implement learning path persistence
- [ ] 4.2.2 Auto-resume last location

### 🔹 Feedback & Interaction
- [ ] 3.2.7 Share content with others
- [ ] 3.2.8 Allow likes, comments, feedback
- [ ] 3.2.9 Ratings & reviews
- [ ] 3.2.10 Suggest edits / crowdsource content
- [ ] 3.2.11 Follow chapters/paths for updates

### 🔹 Visual & Accessibility
- [ ] 3.2.3 Font scaling
- [ ] 3.2.4 Toggle light/dark theme
- [ ] 3.2.5 Highlighting/annotation
- [ ] 3.2.6 Offline download (e.g., PDF export)

### 🔹 Enhanced Search
- [ ] 6.2 Polish search experience
- [ ] 3.2.12 Add search/filter to long lists

---

Would you like a **milestone progress tracker** generated in Markdown, or as a `.json`/`.csv` for a tool like Notion, Trello, or GitHub Projects? Or want a live Flutter UI component to visualize this in the app?












april 10 Update











Nice — and yes, several of the milestone items are **already complete** or partially addressed. Here's an audit:

---

## ✅ Already Complete

### 🔹 Navigation & Transitions
- ✅ 2.2.2 Audit all `.go()` calls for `transitionKey` inclusion  
  → Done across all *DetailScreens and *ItemScreens
- ✅ 2.2.3 Fix `.push()` vs `.go()` in `flashcard_item_screen`  
  → Confirmed use of `.push()` with full `extra`

### 🔹 UI Polish
- ✅ 3.1.3 Handle empty chapter gracefully  
  → All *DetailScreens check for empty `renderItems`
  
### 🔹 Learning Path UX
- ✅ Navigation from "Set Sail" now correctly sets `backExtra['pathName']`
- ✅ All branch detail screens display the path name with `LearningPathProgressBar`

---

## 🧭 Suggested Next Steps

The **highest leverage item** right now is:

### 🔹 1.1.3 Wire up "Resume your voyage" logic
- It's the last broken button in the current path experience.
- Unblocks deeper user continuity + onboarding UX.

**Would you like to tackle that next?**  
I can generate a `resumePathAtLastKnownLocation(pathName)` helper and wire it into the `PathChapterScreen`.

Alternately, if you prefer a **navigation polish sprint**, we could:

- 🧭 2.1.1 Modularize `transition_builders.dart`
- 🧭 2.1.3 Refactor all routes to use named transitions
- 🧭 2.2.1 Add directional awareness to `MainScaffold`

Let me know which way you want to go — or if you’d like the **milestone tracker** in Markdown, Trello JSON, or visual Flutter widget format.


repositories to json? (dis)advantages?