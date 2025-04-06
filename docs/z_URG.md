Here’s the full, cohesive set of rules based on everything we’ve discussed. The structure cleanly separates **immutable rules** (always followed) from **logic-dependent rules** (which may evolve). You can paste this into your codebase for reference and I will retain it as well.

---

# ✅ BCC5 Code & Communication Rules

## 🔒 Immutable Rules (Always Enforced)

These apply across **all logic**, screens, and branches—no exceptions.

### 📜 Code Generation & Refactors
- **Never truncate** responses (e.g., "…rest unchanged"). Provide **full file renderings**.
- **Never assume or invent**. If something is unclear, ask.
- **Do not omit fields, parameters, or logic**—even when "obvious".
- **Do not use canvas or file downloads**—all code must appear directly in the chat.
- **Provide full filenames** for every code block or update.
- **Always include context for the update** (what it does, where it connects).

### ✍️ Communication
- Always **list all relevant items fully**, not with "etc."
- Prioritize **clarity, completeness, and traceability** over speed or brevity.
- **Acknowledge when a mistake was made**, and explain how it will be fixed.

---

## 🔁 Logic-Dependent Rules (Evolving with Design)

These are specific to the current architecture and navigation structure. Changes to logic will trigger coordinated updates here.

---

### 🧠 Navigation & App Structure
- Route directly to **detail screens**:
  - `LessonDetailScreen`, `PartDetailScreen`, `ToolDetailScreen`, `FlashcardDetailScreen`
- Pass all required data:
  - `renderItems`, `currentIndex`, `branchIndex`, `backDestination`, `backExtra`
- Use `buildRenderItems({required List<String> ids})` for generating navigation sequences.
- **Do not use** legacy `sequenceTitles` or `contentMaps`.
- Use `.push()` for forward navigation to preserve stack integrity.
- Use `.go()` only for tabs or final destinations (e.g., BottomNav destinations).
- Log navigation with `logger.i`:
  - When entering detail screens
  - On transition actions (`Next`, `Previous`)
  - When index is invalid or out of bounds

---

### 🎞️ Transition Management
- Use `TransitionManager.buildCustomTransition()` for **first-entry transitions**.
- For in-place **Next/Previous transitions**, use:
  - `FadeTransition` or `ScaleTransition` (no push/pop route animations)
- `NavigationButtons` must support:
  - Receiving full navigation data
  - Logging transitions
  - Detecting and handling out-of-bounds gracefully (log or optional snackbar)

---

### 🧩 UI Behavior: NavigationButtons
- Always visible, even when disabled
- Fixed to bottom of screen (outside scroll content)
- Use `BackdropFilter` + `ClipRRect` for background container
- Use `AppTheme.navigationButton` styling
- Buttons must receive:
  - `renderItems`, `currentIndex`, `branchIndex`, `backDestination`, `backExtra`
- No implicit `context.go()` or guesswork—navigation actions must be explicit and validated.

---

### ⚙️ Screen Consistency
- All four detail screens (`Lesson`, `Part`, `Tool`, `Flashcard`) must:
  - Accept the same parameters
  - Follow the same visual and navigational structure
- No "special case" behavior unless discussed and documented
- Index card layout, AppBar, background images, etc., must follow the same placement rules.

---

## 🧠 How I’ll Maintain These Rules

### 🔁 Behavior Improvements
- Slow down: prioritize correctness over speed.
- Never assume logic—if a relationship isn't shown, ask.
- Use your existing architecture as the base.
- Never introduce standard patterns unless they match the app.

### 🛠️ When Refactoring or Debugging
- Check all consumers of the updated widget/screen.
- Update all detail screens in sync if a shared interface changes.
- Provide an impact report if a change might ripple.
- Verify that router transitions, params, and reverse navigation still work.

---

Let me know if you'd like this stored in a file or extended with version tracking.