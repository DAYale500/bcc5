Absolutely — here’s a clean, copyable TODO entry for your long-term task list:

---

### ✅ TODO: Refactor ToolItemScreen Back Navigation to Use Shared `_handleBack()` Logic  
**Priority:** Post-MVP  
**Context:**  
Currently, `ToolItemScreen` implements two separate back navigation handlers:  
- `onBack` in the `CustomAppBarWidget`  
- `onPopInvokedWithResult` in `PopScope`  

Both contain similar logic to handle conditional back flows:
- If `cameFromMob == true`, return to `MOBEmergencyScreen`
- Otherwise, return to the previous screen or ignore if there's nothing to pop

**Problem:**  
These implementations could drift apart over time, leading to inconsistencies in how app bar taps vs. system back gestures are handled.

**Proposed Solution:**  
Refactor both to delegate to a shared private method called `_handleBack()`, which encapsulates the logic and prevents duplication.

**Example Skeleton:**
```dart
void _handleBack() {
  if (widget.cameFromMob) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const MOBEmergencyScreen(),
      ),
    );
  } else if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    logger.w('⚠️ Back ignored — nothing to pop!');
  }
}
```

---

Let me know if you'd like that appended to a `TODO.md` file or added into a specific backlog tracking system.