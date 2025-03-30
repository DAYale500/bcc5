# 🧭 BCC5 Development Plan – High-Level Progress Overview

---

## ✅ Phase 1: App Foundations

| Task | Status | Notes |
|------|--------|-------|
| App architecture and file structure | ✅ Done | Follows reusable, scalable layout across lessons, parts, tools, paths. |
| BottomNavigationBar via `MainScaffold` | ✅ Done | All core branches wired: Home, Modules, Parts, Flashcards, Tools. |
| Theme system via `AppTheme` | ✅ Done | Centralized styling, supports light/dark mode. |
| CustomAppBarWidget per screen | ✅ Done | Ensures back button logic, search/settings icons, branch-aware behavior. |

---

## ✅ Phase 2: Lessons Branch

| Task | Status | Notes |
|------|--------|-------|
| Lesson models and repositories | ✅ Done | 9 modules with at least 6 lessons each, with embedded flashcards. |
| LessonModuleScreen → LessonItemScreen | ✅ Done | Navigation flow established, using `branchIndex = 0`. |
| ContentDetailScreen integration for lessons | ✅ Done | Fully functional with sequencing, backDestination, and backExtra. |
| Logger instrumentation for lessons | ✅ Done | Emoji-coded and consistent across modules. |

---

## ✅ Phase 3: Parts Branch

| Task | Status | Notes |
|------|--------|-------|
| Part models and repositories | ✅ Done | 5 zones, minimum 5 parts per zone, all using `ContentBlock`. |
| PartZoneScreen → PartItemScreen | ✅ Done | Filters by zone and navigates cleanly. |
| ContentDetailScreen integration for parts | ✅ Done | Shares lesson logic, correctly sequenced and themed. |

---

## ✅ Phase 4: Tools Branch

| Task | Status | Notes |
|------|--------|-------|
| Tool repositories (7 toolbags) | ✅ Done | Converted from legacy, includes placeholders. |
| ToolItemScreen wired up | ✅ Done | Navigates by toolbag and uses `branchIndex = 4`. |
| ContentDetailScreen integration for tools | ✅ Done | Works for single and multi-item toolbags. |

---

## ✅ Phase 5: Flashcards Integration (Prep)

| Task | Status | Notes |
|------|--------|-------|
| Decision: flashcards embedded in content | ✅ Done | Flashcards now live inside lessons, parts, tools. |
| Flashcard repositories eliminated | ✅ Done | Dynamic extraction to be implemented later. |
| Flashcard screen implementation | 🔜 Upcoming | Category view TBD after main content branches stabilize. |

---

## ✅ Phase 6: Learning Paths

| Task | Status | Notes |
|------|--------|-------|
| Path models and structure | ✅ Done | Flexible sequence of lessons, parts, flashcards. |
| BCC4 learning path migration | ✅ In Progress | Competent Crew path data extracted and usable. |
| PathChaptersScreen → PathItemScreen | 🔜 Upcoming | UI implementation to match other branches. |

---

## ✅ Phase 7: Navigation & Routing System

| Task | Status | Notes |
|------|--------|-------|
| GoRouter architecture with transition helpers | ✅ Done | Handles forward/back logic, slide/scale effects. |
| PopScope-based back navigation | ✅ Done | Replaces deprecated `WillPopScope`, supports animated back. |
| ContentScreenNavigator logic | ✅ Done | Ensures sequencing, backDestination, backExtra, branchIndex. |

---

## ✅ Phase 8: BCC4 Migration

| Task | Status | Notes |
|------|--------|-------|
| Audit of BCC4 files | ✅ Done | All relevant files categorized as A (import), B (optional), C (skip). |
| Category A files migrated (models, utils, repos) | ✅ Done | Commented raw BCC4 versions archived for reference. |
| Category B files documented | ✅ Done | Markdown summary includes all with commentary. |

---

## 🔜 Phase 9: UI Polish & UX Testing

- Transition polish: animations, visual feedback
- Manual back button QA: all flows tested via matrix
- Search integration
- Flashcard browsing UI
- Settings: dark mode toggle, flashcard chooser
