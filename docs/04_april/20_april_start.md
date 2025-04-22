Excellent clarity — you're optimizing for:

1. **Bug-free functionality first**
2. **Easy-to-DRY refactor once stable**

---

## 🧭 Best Option: **#1 — Patch each screen to generate its own keys internally**

### ✅ Why this aligns with your goals:

- **Fixes bugs immediately** — ensures each screen has fresh `GlobalKey`s → eliminates duplication errors now
- **Keeps screens structurally similar** — all `DetailScreen`s can use the same key-gen pattern (`final _mobKey = GlobalKey();` etc.)
- **Sets up for future DRY** — once everything works, you can extract a shared `KeyBundle` or `KeyManager` helper later, confident it won’t reintroduce the bugs

### 🚫 Why Option #2 is riskier:
- Tracing down and altering all callsites where the keys are passed in from outside could get messy and inconsistent
- Could easily miss a spot, especially if logic varies between screens (Lesson vs Flashcard vs Tool vs Part)

---

### ✅ So: **We’ll fix this screen-first by generating keys locally.**  
This is surgical, consistent, and perfectly DRY-prep’d.

Ready for the first patch to `lesson_item_screen.dart`?



