## ✅ REVISED TODO LIST (Numbered & Cleaned)

### 1. Learning Paths & Navigation UX

#### 1.1 Landing Flow
- 1.1 Add "New Crew? Start Here" button and wire it to first PathItem in repo — prioritize this as a key onboarding entry point for new users
- 1.2 Expand "Knock the Rust Off" picker: build real review learning path repositories, allow future expansion
- 1.3 After all PathItems in a chapter are complete, show a completion popup/modal with options:
  - Go to next chapter in sequence
  - Return to chapter selection screen

#### 1.2 Breadcrumbs & Flow
- 1.4 Add breadcrumb nav to item and detail screens
- 1.5 Omit group name (covered in BottomNavBar)
- 1.6 Breadcrumb should show Item > Detail, but omit detail when navigating back

#### 1.3 End-of-Chapter Flashcards
- 1.7 Include flashcards for each chapter's PathItems at the end of the chapter view — prioritize after core navigation flow since it reinforces learning without blocking progress

---

### 2. Navigation & Transition System

#### 2.1 Transition Refactor (COMPLETE)
- 2.1 Modular builders implemented and applied across routes

#### 2.2 Transition Polish (COMPLETE for existing screens)
- 2.2 Direction-aware transitions and `transitionKey` applied to existing routes
- 2.3 Ensure pattern maintained for future screens

---

### 3. App Features & Enhancements

#### 3.1 Content Interaction
- 3.1 Add loading spinner while content is being fetched — prioritize early for better user perception during network operations (improves polish and responsiveness)
- 3.2 Add scroll-to-top sidebar (auto-hide when not scrolling)

#### 3.2 User Tools
- 3.3 Bookmark/save for later
- 3.4 Track progress through PathItems
- 3.5 Build full theme control + support ThemeMode.system
- 3.6 Highlight/annotate content, with a saved highlights viewer screen/modal
- 3.7 Enable feedback on items (for beta testers only)
- 3.8 Add "Suggest an Edit" feature (accessed via Settings)

---

### 4. Data & Repo Management

#### 4.1 Repository Structure
- 4.1 Convert tool repositories to local JSON files
- 4.2 Add many more tools (incl. Colregs, signals, emergency steps)

#### 4.2 Learning Path Persistence
- 4.3 Implement persistent storage for path progress (e.g., Riverpod `StateNotifier`, SharedPreferences, Hive) — essential for user experience continuity, prioritize as a top-priority backend task
- 4.4 Auto-resume: restore last visited pathItem or chapter

---

### 5. Flashcards

#### 5.1 Navigation & Options
- 5.1 Change "All" button to bypass FlashcardItemScreen and go directly to FlashcardDetailScreen
- 5.2 Change "Random" to "Custom" → open FlashcardRandomPickerScreen — more complex than 5.1 but valuable for power users, prioritize after core flashcard navigation is solid:
  - Choose number of cards
  - Filter by category (checkboxes)
  - Crew/skipper level
  - Choose order: sequential or random

---

### 6. UI & Styling

#### 6.1 Theming
- 6.1 Finalize AppTheme text styles
- 6.2 Ensure style access via clear naming (e.g., TextAboveDetailScreenButtonsLightTheme)
- 6.3 Pick themes that work well in bright outdoor light

---

### 7. Emergency Features

#### 7.1 Man Overboard (MOB)
- 7.1 Add lifering button (FAB): consider placement (top right below appBar?) — could be a high-impact feature for emergency response, consider early prototyping if GPS support is feasible
- 7.2 Capture GPS on tap, display it permanently until canceled
- 7.3 Route to MOB procedure screen (steps/checklist)

---

### 8. Advanced / Experimental

- 8.1 Interactive Checklists:
  - 8.1.1 Toggle done/undone
  - 8.1.2 Reset all
  - 8.1.3 Show incomplete only
  - 8.1.4 Support custom checklist variants

- 8.2 Polish & expand search feature
- 8.3 Add hover highlight to `PartZoneScreen` with visual feedback

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


## ✅ REVISED TODO LIST (Numbered & Cleaned)

### 1. Learning Paths & Navigation UX

#### 1.1 Landing Flow
- 1.1 Add "New Crew? Start Here" button and wire it to first PathItem in repo — prioritize this as a key onboarding entry point for new users
- 1.2 Expand "Knock the Rust Off" picker: build real review learning path repositories, allow future expansion
- 1.3 After all PathItems in a chapter are complete, show a completion popup/modal with options:
  - Go to next chapter in sequence
  - Return to chapter selection screen

#### 1.2 Breadcrumbs & Flow
- 1.4 Add breadcrumb nav to item and detail screens
- 1.5 Omit group name (covered in BottomNavBar)
- 1.6 Breadcrumb should show Item > Detail, but omit detail when navigating back

#### 1.3 End-of-Chapter Flashcards
- 1.7 Include flashcards for each chapter's PathItems at the end of the chapter view — prioritize after core navigation flow since it reinforces learning without blocking progress

---

---

### 3. App Features & Enhancements

#### 3.1 Content Interaction
- 3.1 Add loading spinner while content is being fetched — prioritize early for better user perception during network operations (improves polish and responsiveness)
- 3.2 Add scroll-to-top sidebar (auto-hide when not scrolling)

#### 3.2 User Tools
- 3.3 Bookmark/save for later
- 3.4 Track progress through PathItems
- 3.5 Build full theme control + support ThemeMode.system
- 3.6 Highlight/annotate content, with a saved highlights viewer screen/modal
- 3.7 Enable feedback on items (for beta testers only)
- 3.8 Add "Suggest an Edit" feature (accessed via Settings)

---

### 4. Data & Repo Management

#### 4.1 Repository Structure
- 4.1 Convert tool repositories to local JSON files
- 4.2 Add many more tools (incl. Colregs, signals, emergency steps)

#### 4.2 Learning Path Persistence
- 4.3 Implement persistent storage for path progress (e.g., Riverpod `StateNotifier`, SharedPreferences, Hive) — essential for user experience continuity, prioritize as a top-priority backend task
- 4.4 Auto-resume: restore last visited pathItem or chapter

---

### 5. Flashcards

#### 5.1 Navigation & Options
- 5.1 Change "All" button to bypass FlashcardItemScreen and go directly to FlashcardDetailScreen
- 5.2 Change "Random" to "Custom" → open FlashcardRandomPickerScreen — more complex than 5.1 but valuable for power users, prioritize after core flashcard navigation is solid:
  - Choose number of cards
  - Filter by category (checkboxes)
  - Crew/skipper level
  - Choose order: sequential or random

---

### 6. UI & Styling

#### 6.1 Theming
- 6.1 Finalize AppTheme text styles
- 6.2 Ensure style access via clear naming (e.g., TextAboveDetailScreenButtonsLightTheme)
- 6.3 Pick themes that work well in bright outdoor light

---

### 7. Emergency Features

#### 7.1 Man Overboard (MOB)
- 7.1 Add lifering button (FAB): consider placement (top right below appBar?) — could be a high-impact feature for emergency response, consider early prototyping if GPS support is feasible
- 7.2 Capture GPS on tap, display it permanently until canceled
- 7.3 Route to MOB procedure screen (steps/checklist)

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

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX





## ✅ REVISED TODO LIST (Sorted by Priority)

### 🔺 HIGH PRIORITY

#### 1. Onboarding & Navigation
- 1. Add "New Crew? Start Here" button and wire it to first PathItem in repo — prioritize this as a key onboarding entry point for new users

reorder competentCrewRepo to have FC's at end of chapters

#### 2. Persistence & Progress
- 2. Implement persistent storage for path progress (e.g., Riverpod `StateNotifier`, SharedPreferences, Hive) — essential for user experience continuity, prioritize as a top-priority backend task

#### 3. Navigation Feedback
- 3. Add loading spinner while content is being fetched — prioritize early for better user perception during network operations (improves polish and responsiveness)

#### 4. Emergency Safety
- 4. Add lifering button (FAB): consider placement (top right below appBar?) — could be a high-impact feature for emergency response, consider early prototyping if GPS support is feasible

---

### 🔸 MEDIUM PRIORITY

#### 5. Navigation Enhancements
- 5. After all PathItems in a chapter are complete, show a completion popup/modal with options:
  - Go to next chapter in sequence
  - Return to chapter selection screen
- 6. Add breadcrumb nav to item and detail screens
- 7. Breadcrumb should show Item > Detail, but omit detail when navigating back
- 8. Include flashcards for each chapter's PathItems at the end of the chapter view — prioritize after core navigation flow since it reinforces learning without blocking progress

#### 6. Flashcard UX
- 9. Change "All" button to bypass FlashcardItemScreen and go directly to FlashcardDetailScreen
- 10. Change "Random" to "Custom" → open FlashcardRandomPickerScreen — more complex than 9 but valuable for power users, prioritize after core flashcard navigation is solid:
  - Choose number of cards
  - Filter by category (checkboxes)
  - Crew/skipper level
  - Choose order: sequential or random

#### 7. Theme & Visuals
- 11. Build full theme control + support ThemeMode.system
- 12. Finalize AppTheme text styles
- 13. Ensure style access via clear naming (e.g., TextAboveDetailScreenButtonsLightTheme)
- 14. Pick themes that work well in bright outdoor light

---

### 🔹 LOW PRIORITY

#### 8. Remaining Navigation & Setup
- 15. Expand "Knock the Rust Off" picker: build real review learning path repositories, allow future expansion
- 16. Omit group name (covered in BottomNavBar)
- 17. Auto-resume: restore last visited pathItem or chapter
- 18. Add scroll-to-top sidebar (auto-hide when not scrolling)

#### 9. User Tools
- 19. Bookmark/save for later
- 20. Track progress through PathItems
- 21. Highlight/annotate content, with a saved highlights viewer screen/modal
- 22. Enable feedback on items (for beta testers only)
- 23. Add "Suggest an Edit" feature (accessed via Settings)

#### 10. Tools & Data
- 24. Convert tool repositories to local JSON files
- 25. Add many more tools (incl. Colregs, signals, emergency steps)

#### 11. Experimental
- 26. Toggle done/undone in checklists
- 27. Reset all checklist items
- 28. Show incomplete only
- 29. Support custom checklist variants
- 30. Polish & expand search feature
- 31. Add hover highlight to `PartZoneScreen` with visual feedback

