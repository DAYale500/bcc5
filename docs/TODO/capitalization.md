Here’s your cleanly formatted TODO note:

---

### 📝 TODO: Replace Hardcoded Pluralization with Utility Function

**Context:**  
In `_buildEndOfGroupModal` (e.g., `PartDetailScreen`), pluralization is currently handled by directly appending `'s'` to `labelCapitalized`. This works for now but is brittle and not semantically clean.

---

#### ✅ Replace with:
```dart
String pluralize(String word) => word.endsWith('s') ? word : '${word}s';
```

#### 🔁 And update usage:
```dart
'Back to ${pluralize(labelCapitalized)}'
```

---

**Benefits:**
- Prevents awkward `ss` (e.g. “classs”).
- Encapsulates logic in one place for future improvements (like localization or irregular plurals).
- Aligns with best practices for clean, reusable utilities.

---

Let me know when you’re ready to roll this out across other screens, or if you want a shared `string_utils.dart` helper for it.