## 📘 BCC4 App: Onboarding & Architecture Guide

### 🧭 Project Goal
The BCC4 app helps new sailing crew become more self-sufficient and competent by providing structured, navigable access to key training materials: lessons, parts, flashcards, and learning paths.

---

### 🧱 App Architecture

#### 🔹 Primary Branches (Consistent Pattern):
Each branch follows a top-level category ➝ item detail pattern.

1. **Modules ➝ Lessons**
2. **Parts ➝ Zones**
3. **Flashcards ➝ Categories**
4. **Learning Paths ➝ Chapters ➝ Items (Lessons, Parts, Flashcards)**

#### 🔹 Shared Screen Layout
- **Top Section:** FilterButtons (e.g., modules, zones)
- **Bottom Section:** DetailButtons (e.g., lessons, parts)
- **Filtering Behavior:**
  - Tap a filter ➝ filters detail list
  - Tap Clear Filter ➝ resets view
- **Navigation:**
  - Tap detail ➝ navigates to detail screen with scale transition
  - Tap back ➝ returns with left-slide transition

---

### 🎨 UI/UX Consistency

#### 🔸 FilterButtons
- 60% screen width
- `primaryBlue` color
- Vertically stacked

#### 🔸 DetailButtons
- 35% screen width
- `primaryRed` color
- Grid layout with 2 columns
- Rectangular with rounded corners
- Compact height using `childAspectRatio: 2.8`

#### 🔸 Navigation Transitions
- **Scale:** Drilling down (e.g., Lessons ➝ Detail)
- **Left-slide:** Back navigation
- **No animation:** Filtering in place
- Navigation handled via `NavigationContext` helper

---

### 📚 Content Design

#### 🔸 Lessons and Parts
- Each has structured `content`:
  - Interleaved text and images
  - Default fallback image: `assets/images/fallback_image.jpeg`

#### 🔸 Flashcards
- Linked to lessons and parts
- Categorized by source and tagged by level (Crew, Skipper, Master)

#### 🔸 Learning Paths
- Predefined sequence of lessons, parts, and flashcards
- Includes free path: **Competent Crew** (18 lessons from 9 modules)
- Navigation reflects learning path order (Previous/Next/Next Chapter)

---

### 🔄 Navigation & Back Button System

#### 🔸 Transition Control
- Centralized in `app_router.dart`
- Uses `NavigationContext.scaleTransition`, `.backNavigation`, etc.

#### 🔸 Back Navigation
- Unified via `CustomAppBarWidget`
- Uses `PopScope` to override system back button
- Explicit `context.go(...)` to reset stack and trigger left-slide animation

#### 🔸 Special Cases
- From Part ➝ Lesson via keyword ➝ Back returns to originating part
- BottomNavigationBar resets stack when switching branches
- HomeScreen hides back button unless navigated from deeper screen

---

### 🛠 Developer Practices

#### ✅ File Structure
- Models: `*_model.dart`
- Repositories: Inside `/data/repositories/`
- Widgets: Reusable buttons, layout, app bar, transitions helpers

#### ✅ Naming Consistency
- `FilterButton`, `DetailButton` used across all branches
- Repos imported with full path (e.g., `package:bcc4/data/repositories/lessons/module_repository.dart`)

#### ✅ Logging
- All taps and navigation are logged for debugging
- Can be easily toggled off later

---

### 🚧 Current Tasks
1. **Lesson Detail Enhancements**: Display interleaved text/images
2. **Path Item Enhancements**: Handle all path content types
3. **Verify Back Behavior**: Screen-by-screen validation
4. **Polish Navigation Flow**: Improve transitions, clean stack
5. **Document Everything**: This guide will evolve with the app

---

### 🧪 Testing Templates
Prefilled forms are used to manually test:
- Entry Point
- Tap Sequence
- Expected vs. Actual Back Behavior
- Transition Animation
- Back Button Visibility

---

### 📎 Notes
- All screens use `MainScaffold`.
- App should avoid deprecated Flutter APIs (e.g., prefer `PopScope`).
- No swipe-back gesture on iOS (custom back only).
- Future feature: Flashcard integration in LessonDetails.

---

### 🔮 Future Enhancements
- NMEA 2000 support for navigation data
- Random flashcard chooser in Settings
- Paid/unpaid content toggle
- Final structured rebuild guide

---

For questions or changes, refer to this document before editing navigation, layout, or content structure.

