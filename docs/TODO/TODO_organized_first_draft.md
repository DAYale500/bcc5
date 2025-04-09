## ✅ REVISED TODO LIST (Structured)

### 1. Learning Paths & Navigation UX

#### 1.1 Landing Flow
- 1.1.1 Add "New Crew? Start Here" button and wire it to first PathItem in repo
- 1.1.2 Expand "Knock the Rust Off" picker: build real review learning path repositories, allow future expansion
- 1.1.3 After all PathItems in a chapter are complete, show a completion popup/modal with options:
  - Go to next chapter in sequence
  - Return to chapter selection screen

#### 1.2 Breadcrumbs & Flow
- 1.2.1 Add breadcrumb nav to item and detail screens
- 1.2.2 Omit group name (covered in BottomNavBar)
- 1.2.3 Breadcrumb should show Item > Detail, but omit detail when navigating back

#### 1.3 End-of-Chapter Flashcards
- 1.3.1 Include flashcards for each chapter's PathItems at the end of the chapter view

---

### 2. Navigation & Transition System

#### 2.1 Transition Refactor (COMPLETE)
- All modular builders implemented and applied across routes

#### 2.2 Transition Polish (COMPLETE for existing screens)
- Direction-aware transitions and `transitionKey` applied to existing routes
- Ensure pattern maintained for future screens

---

### 3. App Features & Enhancements

#### 3.1 Content Interaction
- 3.1.2 Add loading spinner while content is being fetched
- 3.1.4 Add scroll-to-top sidebar (auto-hide when not scrolling)

#### 3.2 User Tools
- 3.2.1 Bookmark/save for later
- 3.2.2 Track progress through PathItems
- 3.2.4 Build full theme control + support ThemeMode.system
- 3.2.5 Highlight/annotate content, with a saved highlights viewer screen/modal
- 3.2.8 Enable feedback on items (for beta testers only)
- 3.2.10 Add "Suggest an Edit" feature (accessed via Settings)

---

### 4. Data & Repo Management

#### 4.1 Repository Structure
- 4.1.3 Convert tool repositories to local JSON files
- 4.1.4 Add many more tools (incl. Colregs, signals, emergency steps)

#### 4.2 Learning Path Persistence
- 4.2.1 Implement persistent storage for path progress (determine solution: Riverpod, Provider, etc.) → options include Riverpod `StateNotifier` with shared `SharedPreferences` or `Hive` for storage
- 4.2.2 Auto-resume: restore last visited pathItem or chapter

---

### 5. Flashcards

#### 5.1 Navigation & Options
- 5.1.2 Change "All" button to bypass FlashcardItemScreen and go directly to FlashcardDetailScreen
- 5.1.3 Change "Random" to "Custom" → open FlashcardRandomPickerScreen:
  - Choose number of cards
  - Filter by category (checkboxes)
  - Crew/skipper level
  - Choose order: sequential or random

---

### 6. UI & Styling

#### 6.1 Theming
- 6.1.1 Finalize AppTheme text styles
- 6.1.2 Ensure style access via clear naming (e.g., TextAboveDetailScreenButtonsLightTheme)
- 6.1.3 Pick themes that work well in bright outdoor light

---

### 7. Emergency Features

#### 7.1 Man Overboard (MOB)
- 7.1.1 Add lifering button (FAB): consider placement (top right below appBar?)
- 7.1.2 Capture GPS on tap, display it permanently until canceled
- 7.1.3 Route to MOB procedure screen (steps/checklist)

---

### 8. Advanced / Experimental

- 8.1 Interactive Checklists:
  - 8.1.1 Toggle done/undone
  - 8.1.2 Reset all
  - 8.1.3 Show incomplete only
  - 8.1.4 Support custom checklist variants

- 8.2 Polish & expand search feature
- 8.3 Add hover highlight to `PartZoneScreen` with visual feedback

---

## ❌ REJECTED UPGRADES
- 3.1.3 Handle case where chapter has no items (not needed)
- 3.1.6 Add error handling for missing chapter (not needed in prod)
- 3.2.3 Font style/size adjustment (not for users except via accessibility settings)
- 3.2.6 Export as PDF/offline (not necessary)
- 3.2.7 Sharing (not required)
- 3.2.9 Ratings & reviews (unclear value)
- 3.2.11 Subscribe/follow paths (not defined clearly)
- 3.2.12 Custom paths (possibly too complex)
- 3.2.13 Content update notifications (handled via app updates)
- 3.2.14 Cross-device sync (not needed)
- 3.2.15 External integrations (note apps, cloud storage) (not needed)

---

## ❓ EXPLANATION REQUESTS

- 3.1.5 Refresh chapter button → clarification needed: Is this to manually reload from repo/state?
- 4.2.1 Persistence for learning paths → options include Riverpod `StateNotifier` with shared `SharedPreferences` or `Hive` for storage
- 3.2.9 Ratings/reviews → Is this user-generated reviews per item? Public-facing or internal?
- 3.2.11 Follow/subscribe → Does this mean push updates or UI preference/favoriting?
- 3.2.12 Custom paths → What would UI + backend look like to allow custom chapter creation?

