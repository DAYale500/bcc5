Confirmed — this is a clear and structured plan. Here's a summary and restatement of the breadcrumb system implementation so we’re totally aligned before we begin:

---

### ✅ **Goal: Unified Breadcrumb Visual Hierarchy Across BCC5**

We will:

1. **Create 3 new `TextStyle`s in `AppTheme`:**
   - `branchBreadcrumbStyle`: Bold → used for branch names
   - `groupBreadcrumbStyle`: Italic → used for group names (e.g., module, zone, toolbag, chapter)
   - `detailTitleStyle`: Used for item names (existing or updated as needed)

2. **Standardize breadcrumb structure across all screen levels:**

| Level       | Example                                | Styling                                                   |
|-------------|----------------------------------------|------------------------------------------------------------|
| Top Level   | `Lessons`                              | Bold (branchBreadcrumbStyle)                              |
| Item Level  | `Lessons / Anchoring`                  | `Lessons`: Bold (branchBreadcrumbStyle)<br>`Anchoring`: Italic (groupBreadcrumbStyle) |
| Detail Level| `Lessons / Anchoring`<br>`Holding Ground` | Top line: branch + group as above<br>Second line: `Holding Ground` in detailTitleStyle |

3. **Apply this system consistently across:**
   - `/lessons`, `/parts`, `/tools`, `/flashcards`
   - Learning Path versions of detail screens (path mode): use `pathName` as branch, and `chapterId` as group
   - Replace visual → symbols with space-separated styles (no arrows)

---

Once you confirm this restatement matches your intent, we’ll proceed with:

- Step 1: Adding the 3 styles to `AppTheme`
- Step 2: Applying these across all screens (`LessonItemScreen`, `LessonDetailScreen`, etc.)

Sound good?
