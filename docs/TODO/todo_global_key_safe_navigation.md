Here’s your TODO checklist for GlobalKey sanitization — **cleanly formatted for later action** once the app is stabilized:

---

### ✅ TODO: Sweep for GlobalKey-safe navigation

Each item prevents future `Duplicate GlobalKey` crashes by wrapping `extra` in `_stripGlobalKeys(...)`.

#### 🔁 Replace `context.go(...)` / `context.push(...)` with sanitized versions

- [ ] **LandingScreen → path button tap**  
  File: `lib/screens/landing_screen/landing_screen.dart`  
  ✅ Wrap `extra:` with `_stripGlobalKeys(...)`

- [ ] **LandingScreen → popup menu selection (learning paths)**  
  File: `lib/screens/landing_screen/landing_screen.dart`  
  ✅ Also wrap `extra:` with `_stripGlobalKeys(...)`

- [ ] **LessonDetailScreen → back button (if `.go()` is re-enabled)**  
  File: `lib/screens/lessons/lesson_detail_screen.dart`  
  ✅ Patch:  
  ```dart
  extra: {
    ...(TransitionManager._stripGlobalKeys(widget.backExtra) ?? {}),
    ...
  }
  ```

- [ ] **PathChapterScreen → back button (`context.go('/')`)**  
  File: `lib/screens/paths/path_chapter_screen.dart`  
  ✅ Add a comment:  
  > // ⚠️ If GlobalKeys are passed in `extra`, wrap with `_stripGlobalKeys(...)`

- [ ] **Generic renderItem dispatcher (`context.go(...)` for RenderItemType)**  
  File: unknown — possibly `search_screen.dart`, `navigation_helper.dart`, or similar  
  ✅ Patch all `context.go(..., extra: extra)` to sanitize `extra`

---

### 🧪 Suggested Enhancements

- [ ] **Add helper methods**:
  ```dart
  void safeGo(BuildContext context, String path, Map<String, dynamic>? extra) {
    context.go(path, extra: _stripGlobalKeys(extra));
  }

  void safePush(BuildContext context, String path, Map<String, dynamic>? extra) {
    context.push(path, extra: _stripGlobalKeys(extra));
  }
  ```
- [ ] **Replace all raw `.go()` and `.push()` calls** with these safe versions

---

Let me know when you're ready to apply them — we can batch the patches or tackle one file at a time.