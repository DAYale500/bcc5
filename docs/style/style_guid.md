Here’s your reformatted `.md`-ready version:

---

```md
# 🧾 Style Guide Entry: Text Sizing + Theming

## 🧠 Content Text Sizing (`AppTheme.textScaleMultiplier` & `scaledTextTheme`)

- Use `AppTheme.scaledTextTheme` for rendering **content-heavy blocks** like lessons, parts, tools, and flashcards.
- Use `Theme.of(context).textTheme` (the default `textTheme`) for **UI scaffolding**: app bars, navigation buttons, and UI labels.
- To globally adjust content readability, change `AppTheme.textScaleMultiplier` in `app_theme.dart`.  
  It will automatically scale all entries in `scaledTextTheme`.

---

## 🛠 Usage Examples:

```dart
// For headers in content:
Text('How to Reef a Sail', style: AppTheme.scaledTextTheme.headlineMedium);

// For normal content:
Text('Step 1: Ease the sheets...', style: AppTheme.scaledTextTheme.bodyLarge);

// For captions or footnotes:
Text('Optional technique', style: AppTheme.scaledTextTheme.bodySmall);
```

---

## 🧰 Optional Enhancement:

In the future, we could introduce a utility like:

```dart
AppTheme.getTextTheme({bool scaled = false});
```

That would let you switch between normal and scaled modes inline, e.g.:

```dart
Text('Hello', style: AppTheme.getTextTheme(scaled: true).bodyLarge);
```
```

---

Let me know if you want this added to a README or your `app_theme.dart` documentation header.