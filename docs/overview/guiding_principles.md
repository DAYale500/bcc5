April 18, 2025 1312

Great — I’ll now synthesize a compact but powerful “Guiding Principles” memory set from your BCC5 codebase. This will replace scattered memories with a concise knowledge core that can be reliably referred to and updated as the app evolves.

---

### ✅ **BCC5 App – Guiding Principles (v1.0)**

#### 1. 🔁 Navigation & Transition Logic
- All navigation routes use `.pageBuilder:` with `TransitionManager.buildCustomTransition(...)` to ensure consistent transition behavior.
- `TransitionType` and `SlideDirection` govern the animation style, passed via `.extra`.
- Use `detailRoute: DetailRoute.path` for path-based navigation to support resume tracking.
- Always pass a unique `transitionKey` (via `UniqueKey().toString()`) to support correct routing logic and animations.

#### 2. 🧠 State & Routing Extras
- `renderItems`, `currentIndex`, `branchIndex`, `backDestination`, and `backExtra` must be passed explicitly to all detail screens.
- `backExtra` holds contextual info like `pathName`, `chapterId`, or `module` and is required for proper subtitle display, resume, and group switching.

#### 3. 🧭 Resume Functionality
- Resume logic (via `ResumeManager`) triggers **only after tapping “Next”** on a `DetailScreen`.
- Applicable only to `DetailRoute.path`. Saves: `pathName`, `chapterId`, `itemId`.

#### 4. 🔑 GlobalKey Handling
- All screens using `CustomAppBarWidget` must receive `mobKey`, `settingsKey`, `searchKey`, and `titleKey` as required parameters.
- Never reuse the same GlobalKey instance across routes. Always generate new ones at the route level.

#### 5. 🎛️ Group Switching
- `GroupPickerDropdown` is used in all *DetailScreens to switch modules/zones/toolbags/categories.
- Still to-do: integrate GroupPickerDropdown in *ItemScreens (currently static).

#### 6. 🧩 AppBar Layout Convention
- AppBar titles are:
  - Static for branch context (e.g., "Parts", "Drills").
  - Dynamic subtitle built from `backExtra` + current item title.
- *ItemScreens show:
  - AppBar with static title.
  - Subtitle = current group + instructional text (e.g., “Choose a Part”).

#### 7. 🆘 MOB Modal Behavior
- MOB button opens a full-screen modal (`MOBEmergencyScreen`) using `Navigator.push`.
- “Other Emergencies” button in MOB modal navigates to ToolItemScreen with a `cameFromMob` flag.
- When `cameFromMob` is true, ToolItemScreen's back button returns to the MOB modal, not the previous screen.

#### 8. 🛠️ Flashcard-Specific Logic
- FlashcardDetailScreen uses flip animation, inline rendering, and supports `RenderItemType.flashcard` routing.
- Must preserve this unique logic even while following the shared `LessonDetailScreen` pattern.

#### 9. 🧪 Refactor Protocol
- All code change instructions must:
  - Name the file clearly.
  - Quote exact code blocks to be replaced and their replacements.
  - Avoid vague phrases like "add before X" or summaries.
  - Require all fixes to be permanent, holistic, and fully explained.

---

Would you like this saved as the **official working memory** now? And should I also generate a markdown version for GitHub or personal documentation?














update april 18, 2025 1409
Absolutely — here is the **full and current** `✅ BCC5 App – Guiding Principles (v1.0)` including the full **Section 10** as we agreed:

---

### ✅ BCC5 App – Guiding Principles (v1.0)

---

**1. 🔁 Navigation & Transition Logic**  
- All routes use `.pageBuilder:` with `TransitionManager.buildCustomTransition(...)`.  
- `TransitionType` and `SlideDirection` are passed via `.extra` to control animations.  
- `detailRoute: DetailRoute.path` enables resume tracking.  
- Use a unique `transitionKey` for each transition to ensure correct animations.

---

**2. 🧠 State & Routing Extras**  
- Must pass `renderItems`, `currentIndex`, `branchIndex`, `backDestination`, `backExtra` into detail screens.  
- `backExtra` includes context (e.g. `pathName`, `chapterId`, `module`) for subtitle logic and resume support.

---

**3. 🧭 Resume Functionality**  
- Resume logic only triggers after tapping "Next", not on screen entry.  
- Applies only when `detailRoute == DetailRoute.path`.

---

**4. 🔑 GlobalKey Handling**  
- All screens using `CustomAppBarWidget` must receive `mobKey`, `settingsKey`, `searchKey`, and `titleKey`.  
- GlobalKeys must be regenerated for each route to avoid conflicts.

---

**5. 🎛️ Group Switching**  
- `GroupPickerDropdown` is integrated into all *DetailScreens.  
- Not yet implemented in *ItemScreens, but planned.

---

**6. 🧩 AppBar Layout Convention**  
- AppBar titles are static by branch, subtitles are dynamic (based on `backExtra` + item).  
- *ItemScreens display static title, dynamic subtitle, and instructional text.

---

**7. 🆘 MOB Modal Behavior**  
- MOB opens a full-screen modal using `Navigator.push`.  
- "Other Emergencies" uses `cameFromMob` to modify back behavior.  
- ToolItemScreen honors `cameFromMob` to return to modal.

---

**8. 🛠️ Flashcard-Specific Logic**  
- FlashcardDetailScreen has unique flip logic and inline rendering.  
- Must preserve these even while following shared detail screen structure.

---

**9. 🧪 Refactor Protocol**  
- All instructions must be:
  - File-specific  
  - Quote exact replacement blocks  
  - Avoid vague or summarized edits  
  - Require permanent, holistic solutions.

---

**10. 🔂 Refactor & Collaboration Workflow**  
- All file changes must follow this workflow unless explicitly agreed otherwise:
  - Specify the filename being worked on before changes.  
  - Quote the exact block of code being replaced.  
  - Provide the full replacement block clearly and precisely.  
  - Never assume where code goes — show it in context or ask.  
  - Work on one fix or feature at a time before moving on.  
  - All fixes must be permanent, holistic, and aligned with architectural intent.  
- Omissions, inventions, and assumptions are to be avoided:
  - ❌ Do not omit unrelated functionality.  
  - ❌ Do not invent logic beyond what was agreed upon.  
  - ❌ Do not assume — ask if something is unclear or ambiguous.  
- Do not use the canvas feature. It is buggy and undermines confidence in output integrity.  
- Use a **numbered structure** (e.g., 1, 1.1, 1.2...) for tasks, instructions, and discussions to maintain clarity.  
- Maintain a **progress tracker** with nested numbering for refactor and feature efforts to avoid drift and ensure structured advancement.

---

Let me know if you'd like a downloadable version (Markdown, PDF, etc.) or if anything needs polishing.