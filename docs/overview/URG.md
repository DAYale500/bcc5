

# **Ultimate Refactor Guide (URG)**  
**Last Updated:** 01/22/2025  

This guide is a **living document** designed to standardize refactoring practices, ensure consistent high-quality code, and streamline collaboration. Adherence to these principles ensures a scalable, maintainable, and efficient development process.

---

## **1. Refactor Workflow Template**  

1. **Purpose:**  
   Define the objective of the task (e.g., "Add `debugPrint` statements to track navigation paths").  

2. **Scope:**  
   Outline what can and cannot be modified (e.g., "Do not change imports, structure, or functionality unless explicitly requested").  

3. **Originality:**  
   Preserve existing functionality unless specified otherwise.  

4. **Validation:**  
   Test thoroughly for syntax errors, regressions, and runtime functionality before presenting results.  

5. **Specificity:**  
   Address only what is requested; avoid assumptions or extraneous changes outside the defined scope.  

---

## **2. Core Principles**  

### **2.1. Vision Alignment**  
- **App Purpose:** A scalable, maintainable reference and learning tool for sailors.  
- **Architecture Goals:**  
  1. Use **RiverPod** for centralized state management.  
  2. Centralize UI via `AppRouter`, `CustomAppBarWidget`, and `CustomBottomNavigationBarWidget`.  
  3. Eliminate redundancy using reusable widgets and utilities (e.g., `PreviousNextButtons`).  
  4. Deliver a seamless user experience with intuitive navigation and dynamic AppBar titles.  

---

### **2.2. Centralized UI Management**  
- **AppRouter Responsibility:**  
  Global UI elements (AppBar, BottomNavigationBar) are managed by `AppRouter`.  

- **Prohibit Local AppBars:**  
  Screens must not define their own `AppBar`. Delegate logic to centralized widgets like `CustomAppBarWidget`.  

---

### **2.3. Comprehensive Refactoring**  
- Refactor **entire files** to avoid partial updates.  
- Include all dependencies, imports, and logic for a self-contained implementation.  
- Avoid placeholders like "remaining code unchanged."  

---

### **2.4. Preserve Original Functionality**  
- Do not remove or alter existing functionality without explicit instructions.  
- Compare original and refactored versions to ensure no regressions.  

---

### **2.5. Clear Documentation and Comments**  
- **Comments Must Include:**  
  - File purpose.  
  - Description of new logic or significant changes.  
  - Key methods, parameters, or widgets.  
  - Known trade-offs or limitations.  

---

### **2.6. DebugPrint Standards**  
- Use `debugPrint` liberally for:  
  - Navigation paths.  
  - State changes.  
  - Variable tracking.  
- Example:  
  ```dart
  debugPrint('Navigating to ZonePartsScreen with zoneId: $zoneId');
  debugPrint('Navigation complete.');
  ```  

---

### **2.7. Explicit Navigation Logic**  
- Pass parameters explicitly via `GoRouter`.  
- Use `state.uri.queryParameters` instead of deprecated getters like `state.params`.  

---

### **2.8. State Management**  
- Manage app state centrally using **RiverPod**, especially for navigation states and user access.  

---

### **2.9. Testing Standards**  
- **Test Types:**  
  - **Unit Tests:** Validate business logic.  
  - **Integration Tests:** Confirm navigation and state transitions.  
  - **Manual Tests:** Verify UI and edge cases.  

- **Test Focus:**  
  - Validate `GoRouter` parameters.  
  - Test dynamic AppBar title generation with utilities like `RouterUtils`.  

---

### **2.10. Iterative Refactoring**  
- Break complex tasks into smaller, testable steps.  
- Validate each stage before proceeding.  

---

### **2.11. Relative Path Comments**  
- Add a relative path at the top of every file for easy identification:  
  ```dart
  // Relative path: /lib/screens/lessons_screen.dart
  ```  

---

### **2.12. Document Known Issues and Trade-Offs**  
- Record unresolved issues and limitations for visibility and future resolution.  

---

## **3. Do Not Use (DNU) Guidelines**  

### **3.1. Code-Specific DNUs**  
1. **Undefined Getters:** Avoid `state.params`. Use `state.uri.queryParameters`.  
2. **Deprecated Methods:** Replace `.withOpacity(opacity)` with `.withAlpha((255 * opacity).round())`.  
3. **Local AppBars:** Always use `CustomAppBarWidget`.  

---

### **3.2. General DNUs**  
1. **Assumptions Without Validation:** Always validate parameters, paths, and imports.  
2. **Breaking Functionality:** Do not remove features without explicit instructions.  
3. **Testing Gaps:** Add unit tests for all new or updated logic.  
4. **Non-Centralized Logic:** Consolidate navigation, state, and styling in reusable components.  

---

## **4. Debugging and Logging Standards**  

### **4.1. Manual Route Logging**  
- Log navigation paths explicitly:  
  ```dart
  debugPrint('[RouteObserver] Navigating to /modules');
  context.go('/modules');
  ```  

### **4.2. RiverPod State Logging**  
- Use `ref.listen` for state changes:  
  ```dart
  ref.listen<int>(counterProvider, (previous, next) {
    debugPrint('Counter changed from $previous to $next');
  });
  ```  

### **4.3. Widget Lifecycle Logs**  
- Example:  
  ```dart
  @override
  void initState() {
    super.initState();
    debugPrint('[MyWidget] initState called');
  }
  ```  

---

## **5. Practical Examples and Solutions**  

### **5.1. Fallback for Missing Images**  
- Use `errorBuilder` in `Image.asset`:  
  ```dart
  Image.asset(
    'assets/images/$imageName',
    errorBuilder: (context, error, stackTrace) {
      return Image.asset('assets/images/fallback_image.jpeg');
    },
  );
  ```  

### **5.2. RiverPod in Dialogs**  
- Wrap dialogs in `Consumer` to update providers:  
  ```dart
  showDialog(
    context: context,
    builder: (dialogCtx) {
      return Consumer(
        builder: (ctx, ref, child) => AlertDialog(...),
      );
    },
  );
  ```  

---

## **6. Summary**  

By following this guide, we:  
1. Ensure consistent code refactoring and high-quality results.  
2. Maintain clarity and simplicity in our app architecture.  
3. Empower collaboration and onboarding with well-documented practices.  

---

This version ensures the guide is **clear, organized, and actionable** for all team members, making it an effective resource for development and refactoring.



Thank you for pointing this out, and I completely understand the frustration caused by the disconnect in this process. Let me clarify my understanding of your feedback and how I will improve to ensure this doesn't happen again.

### **Your Key Points:**
1. **Your App Name and Context:** 
   - My suggestions didn’t fully align with your app's naming conventions, structure, and existing logic (e.g., introducing redundant code for `logger` in `CustomBottomNavigationBarWidget`).
   - I failed to fully consider the existing design and instead offered a new, unnecessary solution.

2. **Unilateral Code Insertion:**
   - I introduced additional logic/code to resolve the issue (`routes` parameter, aliasing `logger`, etc.) without consulting you first or ensuring it aligned with your app's design.
   - These changes created unnecessary complexity and confusion, deviating from your expectations.

3. **Clear Communication Expectations:**
   - You expect **prior consultation** on any changes that could affect your app's architecture, naming conventions, or overall structure.
   - If I suggest a change, you want me to explicitly inform you of the reasoning behind it and the potential impacts, even before implementation.

---

### **What I Will Do Differently:**

1. **Thorough Context Review Before Suggesting Code:**
   - I will always evaluate your app's existing structure and logic (e.g., naming, logger setup) before suggesting changes. If there's any uncertainty, I will explicitly ask for clarification instead of assuming or inventing new patterns.
   - For example, I should have verified how `logger` is defined and used across your app and tailored the solution to your app's existing setup rather than introducing a redundant initialization.

2. **Consultation Before Architectural Changes:**
   - Any suggestion that introduces new patterns (e.g., parameterizing `routes` or aliasing imports) will be communicated **before implementation** for your approval.
   - I’ll explain why the change is necessary, what it solves, and how it aligns with your app's structure.

3. **Explicit Communication on All Changes:**
   - I will clearly highlight any changes I propose and include a note such as: _"This deviates from your current approach because... Please confirm if this aligns with your preferences before proceeding."_ 
   - If I suggest refactoring, I will also explicitly note that the code changes are meant as an **example** for discussion and not necessarily as a direct implementation.

4. **Stick to Your Established Patterns:**
   - I will avoid suggesting changes to established patterns (e.g., logger setup, naming conventions, app structure) unless explicitly requested. If such changes are unavoidable, I will document the exact reasoning behind them.

---

### **Summary of My Understanding:**
1. I made assumptions about your app's structure (e.g., logger usage, naming) and introduced unnecessary changes that disrupted your workflow.
2. You want **prior consultation** before introducing new patterns or making changes that affect your app's architecture.
3. I need to work within your established conventions and logic unless explicitly directed otherwise.
4. All changes must be clearly communicated, explained, and approved by you before you attempt implementation.

---

I value the trust you’ve placed in me to assist with your project, and I’ll be more diligent moving forward to avoid situations like this. Thank you for calling this out directly—it helps me better align with your expectations. Let me know if there’s anything I missed!