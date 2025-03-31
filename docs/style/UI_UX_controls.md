✅ Got it. Based on a full scan of your codebase (across the uploaded files), here’s the structured response for all **style, color, and transition controls** found, along with a plan to centralize and document them.

---

### ✅ 1. **Hardcoded Styles, Colors, Transitions Identified**
Here’s a summary of elements defined inline instead of in `app_theme.dart` or a central style manager:

| File | Line/Widget | Hardcoded Style | Action |
|------|-------------|------------------|--------|
| `flashcard_detail_screen.dart` | `Text(...)` | `fontSize: 16`, `TextAlign.center` | Move size to theme |
| `flashcard_detail_screen.dart` | `ElevatedButton.styleFrom(...)` | Red color, padding | Move to `AppTheme.navigationButton` |
| `flip_card_widget.dart` | `AnimatedBuilder`, `Matrix4.rotationY` | Animation curve, duration | Move to `AppTheme.cardFlipTransition` |
| `navigation_buttons.dart` | `Icon(...)` | Colors.grey / Colors.red | Move to `AppTheme.iconActive`, `iconDisabled` |
| `content_block_renderer.dart` | `Text(...)`, `Container(...)` | Font weights, paddings, vertical spacing | Replace with named styles in theme (e.g., `AppTheme.bodyText`, `AppTheme.dividerPadding`) |

---

### ✅ 2. **Centralized Style Name → Function → Change Method**

| Theme Variable | Used For | Location | How to Change |
|----------------|----------|----------|----------------|
| `AppTheme.headingStyle` | H1 headings | `app_theme.dart` | Modify `fontSize`, `fontWeight` |
| `AppTheme.subheadingStyle` | H2 headings / titles | `app_theme.dart` | Modify text styles |
| `AppTheme.bodyTextStyle` | Paragraphs and bullets | `app_theme.dart` | Adjust size, spacing |
| `AppTheme.navigationButton` | Prev/Next buttons | `navigation_buttons.dart`, `flashcard_detail_screen.dart` | Adjust padding, color, shape |
| `AppTheme.iconActive` | Enabled icon color (search, back) | `custom_app_bar_widget.dart` | Set to global color like `AppColors.primaryRed` |
| `AppTheme.iconDisabled` | Disabled icon color | — | Same as above |
| `AppTheme.cardFlipTransition` | Flip animation duration & curve | `flip_card_widget.dart` | Centralize `Duration` and `Curve` |
| `AppTheme.indexCardSize` | Fixed modal card size | — | Centralize width/height for `index_card.png` |

---

### ✅ 3. **Theme Documentation Template (for `app_theme.dart`)**

```dart
/// ----------------------
/// TEXT STYLES
/// ----------------------
/// Heading Style (e.g., "Teamwork & Terminology")
static const TextStyle headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

/// Subheading or title (used in FlashcardDetailScreen title)
static const TextStyle subheadingStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

/// Body text for paragraphs or flip card sides
static const TextStyle bodyTextStyle = TextStyle(
  fontSize: 16,
  height: 1.5,
);


/// ----------------------
/// BUTTON STYLES
/// ----------------------
/// Used for Previous/Next and Flip buttons
static final ButtonStyle navigationButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
);


/// ----------------------
/// ICON COLORS
/// ----------------------
static const Color iconActive = Colors.red;
static const Color iconDisabled = Colors.grey;


/// ----------------------
/// ANIMATIONS
/// ----------------------
static const Duration cardFlipDuration = Duration(milliseconds: 400);
static const Curve cardFlipCurve = Curves.easeInOut;


/// ----------------------
/// LAYOUT SIZES
/// ----------------------
static const double indexCardWidth = 500;
static const double indexCardHeight = 450;
```

---

### ✅ Next Steps

1. **Refactor all instances** of hardcoded style/color to use `AppTheme` references.
2. **Create a new file** (`app_colors.dart` or similar) if you need separate color palette management.
3. **Add comment headers** in `app_theme.dart` to make onboarding super clear (e.g. `// TEXT STYLES`, `// BUTTONS`, etc).
4. (Optional) Add a `AppSpacing` or `AppLayout` class for global paddings/margins.

Would you like me to generate a full updated `app_theme.dart` file based on this pattern and migrate these values in your key widgets/screens?