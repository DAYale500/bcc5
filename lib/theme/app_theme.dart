import 'package:flutter/material.dart';

class AppTheme {
  // ────────────────────────────────────────────────────────────
  // 🎨 Color Palette
  // ────────────────────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF163FE8);
  static const Color primaryRed = Color.fromARGB(255, 255, 0, 0);
  static const Color backgroundColor = Colors.white;
  static const Color darkBackground = Color(0xFF121212);

  static const Color infoColor = primaryBlue;
  static const Color errorColor = primaryRed;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  static const Color disabledGray = Colors.grey;

  // ────────────────────────────────────────────────────────────
  // 🔠 Text Styles
  // ────────────────────────────────────────────────────────────

  /// Used in AppBar titles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Used in section headers throughout modals/settings
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// Default large body text
  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  /// Default button label text
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// Subtext or hints
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  /// Used in breadcrumb headers for branches
  static const TextStyle branchBreadcrumbStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  /// Used in breadcrumb headers for groups
  static const TextStyle groupBreadcrumbStyle = TextStyle(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: Colors.black87,
  );

  /// Used in section titles within detail views
  static const TextStyle detailTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryBlue,
  );

  /// Used in alert dialogs like emergency reminder
  static const TextStyle modalTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  /// Used to show phonetic spelling (styled bodySmall)
  static final TextStyle phoneticStyle = textTheme.bodySmall!.copyWith(
    color: Colors.grey[600],
  );

  /// Used for "Close" buttons in modals
  static const TextStyle dialogButtonText = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  /// Used for section labels in settings modal
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  /// Default app-wide text theme
  static const TextTheme textTheme = TextTheme(
    headlineLarge: headingStyle,
    headlineMedium: subheadingStyle,
    bodyLarge: bodyTextStyle,
    labelLarge: buttonTextStyle,
    bodySmall: captionStyle,
  );

  /// Scaled text theme for accessibility / larger text setting
  static const double textScaleMultiplier = 1.5;
  static final TextTheme scaledTextTheme = TextTheme(
    headlineLarge: headingStyle.copyWith(
      fontSize: headingStyle.fontSize! * textScaleMultiplier,
    ),
    headlineMedium: subheadingStyle.copyWith(
      fontSize: subheadingStyle.fontSize! * textScaleMultiplier,
    ),
    bodyLarge: bodyTextStyle.copyWith(
      fontSize: bodyTextStyle.fontSize! * textScaleMultiplier,
    ),
    labelLarge: buttonTextStyle.copyWith(
      fontSize: buttonTextStyle.fontSize! * textScaleMultiplier,
    ),
    bodySmall: captionStyle.copyWith(
      fontSize: captionStyle.fontSize! * textScaleMultiplier,
    ),
  );

  /// Used for guided tour text
  static const tourDescriptionStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // /// Returns the appropriate color for the tour overlay shadow
  // /// depending on brightness (light = white, dark = black) and
  // /// using AppTheme.tourOverlayOpacity.
  // static Color tourOverlayColor(BuildContext context) {
  //   final brightness = Theme.of(context).brightness;
  //   final base = brightness == Brightness.dark ? Colors.white : Colors.black; //white for dark mode, black for light mode
  //   return base.withAlpha((tourOverlayOpacity * 255).toInt());
  // }

  // /// Opacity for the guided tour overlay (0.0–1.0 range)
  // static const double tourOverlayOpacity = 0.8;

  /// Opacity for the tour overlay shadow: 0–255
  static const int tourOverlayAlpha = 204; // ~0.8 opacity

  /// Theme-aware shadow color for the tour overlay
  static Color tourOverlayColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  // ────────────────────────────────────────────────────────────
  // 🔘 Button Styles
  // ────────────────────────────────────────────────────────────

  static final ButtonStyle groupRedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryRed,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14),
    textStyle: buttonTextStyle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonCornerRadius),
    ),
  );

  static final ButtonStyle whiteTextButton = ElevatedButton.styleFrom(
    backgroundColor: primaryRed,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    textStyle: buttonTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonCornerRadius),
    ),
  );

  static final ButtonStyle largeRedButton = ElevatedButton.styleFrom(
    backgroundColor: primaryRed,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonCornerRadius),
    ),
  );

  static final ButtonStyle navigationButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryRed,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    textStyle: buttonTextStyle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonCornerRadius),
    ),
  );

  static final ButtonStyle disabledNavigationButtonStyle =
      ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade400,
        foregroundColor: Colors.white.withAlpha(153),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: buttonTextStyle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonCornerRadius),
        ),
      );

  static final ButtonStyle highlightedGroupButtonStyle =
      ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        padding: groupButtonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonCornerRadius),
        ),
      );

  static ButtonStyle get landingPrimaryButton => largeRedButton;
  static ButtonStyle get navigationButton => navigationButtonStyle;
  static ButtonStyle get disabledNavigationButton =>
      disabledNavigationButtonStyle;

  static Color get groupButtonSelected => primaryBlue.withAlpha(229);
  static Color get groupButtonUnselected => primaryBlue.withAlpha(153);

  // ────────────────────────────────────────────────────────────
  // 📐 Dimensions & Padding
  // ────────────────────────────────────────────────────────────
  static const double buttonCornerRadius = 12.0;
  static const double cardCornerRadius = 16.0;
  static const double screenPadding = 16.0;

  static const EdgeInsetsGeometry groupButtonPadding = EdgeInsets.symmetric(
    vertical: 14,
    horizontal: 24,
  );

  static const EdgeInsetsGeometry itemButtonPadding = EdgeInsets.symmetric(
    vertical: 10,
    horizontal: 12,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(12);

  // ────────────────────────────────────────────────────────────
  // 🌞 Light & 🌚 Dark Themes
  // ────────────────────────────────────────────────────────────

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: headingStyle,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryBlue,
      selectedItemColor: primaryRed,
      unselectedItemColor: Colors.white70,
      selectedIconTheme: IconThemeData(size: 26),
      unselectedIconTheme: IconThemeData(size: 22),
      selectedLabelStyle: buttonTextStyle,
      unselectedLabelStyle: buttonTextStyle,
      showUnselectedLabels: true,
    ),
    textTheme: textTheme,
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: ColorScheme.dark(primary: primaryBlue, secondary: primaryRed),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: headingStyle,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryBlue,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: buttonTextStyle,
      unselectedLabelStyle: buttonTextStyle,
    ),
    textTheme: textTheme,
  );
}

// import 'package:flutter/material.dart';

// class AppTheme {
//   // ────────────────────────────────────────────────────────────
//   // 🎨 Color Palette
//   // ────────────────────────────────────────────────────────────
//   static const Color primaryBlue = Color(0xFF163FE8);
//   static const Color primaryRed = Color.fromARGB(255, 255, 0, 0);
//   static const Color backgroundColor = Colors.white;
//   static const Color darkBackground = Color(0xFF121212);

//   static const Color infoColor = primaryBlue;
//   static const Color errorColor = primaryRed;
//   static const Color successColor = Colors.green;
//   static const Color warningColor = Colors.orange;
//   static const Color disabledGray = Colors.grey;

//   // ────────────────────────────────────────────────────────────
//   // 🔠 Text Styles
//   // ────────────────────────────────────────────────────────────

//   /// Used in AppBar titles
//   static const TextStyle headingStyle = TextStyle(
//     fontSize: 22,
//     fontWeight: FontWeight.bold,
//     color: Colors.white,
//   );

//   /// Used in section headers throughout modals/settings
//   static const TextStyle subheadingStyle = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//     color: Colors.white,
//   );

//   /// Default large body text
//   static const TextStyle bodyTextStyle = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.normal,
//     color: Colors.black87,
//   );

//   /// Default button label text
//   static const TextStyle buttonTextStyle = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//     color: Colors.white,
//   );

//   /// Subtext or hints
//   static const TextStyle captionStyle = TextStyle(
//     fontSize: 14,
//     color: Colors.grey,
//   );

//   /// Used in breadcrumb headers for branches
//   static const TextStyle branchBreadcrumbStyle = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.bold,
//     color: Colors.black87,
//   );

//   /// Used in breadcrumb headers for groups
//   static const TextStyle groupBreadcrumbStyle = TextStyle(
//     fontSize: 16,
//     fontStyle: FontStyle.italic,
//     color: Colors.black87,
//   );

//   /// Used in section titles within detail views
//   static const TextStyle detailTitleStyle = TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.bold,
//     color: primaryBlue,
//   );

//   /// Used in alert dialogs like emergency reminder
//   static const TextStyle modalTitle = TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.w600,
//     color: Colors.black,
//   );

//   /// Used to show phonetic spelling (styled bodySmall)
//   static final TextStyle phoneticStyle = textTheme.bodySmall!.copyWith(
//     color: Colors.grey[600],
//   );

//   /// Used for "Close" buttons in modals
//   static const TextStyle dialogButtonText = TextStyle(
//     fontSize: 16,
//     color: Colors.white,
//   );

//   /// Used for section labels in settings modal
//   static const TextStyle sectionTitle = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w500,
//     color: Colors.black,
//   );

//   /// Default app-wide text theme
//   static const TextTheme textTheme = TextTheme(
//     headlineLarge: headingStyle,
//     headlineMedium: subheadingStyle,
//     bodyLarge: bodyTextStyle,
//     labelLarge: buttonTextStyle,
//     bodySmall: captionStyle,
//   );

//   /// Scaled text theme for accessibility / larger text setting
//   static const double textScaleMultiplier = 1.5;
//   static final TextTheme scaledTextTheme = TextTheme(
//     headlineLarge: headingStyle.copyWith(
//       fontSize: headingStyle.fontSize! * textScaleMultiplier,
//     ),
//     headlineMedium: subheadingStyle.copyWith(
//       fontSize: subheadingStyle.fontSize! * textScaleMultiplier,
//     ),
//     bodyLarge: bodyTextStyle.copyWith(
//       fontSize: bodyTextStyle.fontSize! * textScaleMultiplier,
//     ),
//     labelLarge: buttonTextStyle.copyWith(
//       fontSize: buttonTextStyle.fontSize! * textScaleMultiplier,
//     ),
//     bodySmall: captionStyle.copyWith(
//       fontSize: captionStyle.fontSize! * textScaleMultiplier,
//     ),
//   );

//   /// Used for guided tour text
//   static const tourDescriptionStyle = TextStyle(
//     color: Colors.white,
//     fontSize: 18,
//     fontWeight: FontWeight.w500,
//     height: 1.4,
//   );

//   // ────────────────────────────────────────────────────────────
//   // 🔘 Button Styles
//   // ────────────────────────────────────────────────────────────

//   static final ButtonStyle groupRedButtonStyle = ElevatedButton.styleFrom(
//     backgroundColor: primaryRed,
//     foregroundColor: Colors.white,
//     padding: const EdgeInsets.symmetric(vertical: 14),
//     textStyle: buttonTextStyle,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(buttonCornerRadius),
//     ),
//   );

//   static final ButtonStyle whiteTextButton = ElevatedButton.styleFrom(
//     backgroundColor: primaryRed,
//     foregroundColor: Colors.white,
//     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//     textStyle: buttonTextStyle.copyWith(
//       fontSize: 16,
//       fontWeight: FontWeight.w600,
//       color: Colors.white,
//     ),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(buttonCornerRadius),
//     ),
//   );

//   static final ButtonStyle largeRedButton = ElevatedButton.styleFrom(
//     backgroundColor: primaryRed,
//     foregroundColor: Colors.white,
//     padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
//     textStyle: const TextStyle(
//       fontSize: 20,
//       fontWeight: FontWeight.bold,
//       color: Colors.white,
//     ),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(buttonCornerRadius),
//     ),
//   );

//   static final ButtonStyle navigationButtonStyle = ElevatedButton.styleFrom(
//     backgroundColor: primaryRed,
//     foregroundColor: Colors.white,
//     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//     textStyle: buttonTextStyle,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(buttonCornerRadius),
//     ),
//   );

//   static final ButtonStyle disabledNavigationButtonStyle =
//       ElevatedButton.styleFrom(
//         backgroundColor: Colors.grey.shade400,
//         foregroundColor: Colors.white.withAlpha(153),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//         textStyle: buttonTextStyle,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(buttonCornerRadius),
//         ),
//       );

//   static final ButtonStyle highlightedGroupButtonStyle =
//       ElevatedButton.styleFrom(
//         backgroundColor: primaryRed,
//         padding: groupButtonPadding,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(buttonCornerRadius),
//         ),
//       );

//   static ButtonStyle get landingPrimaryButton => largeRedButton;
//   static ButtonStyle get navigationButton => navigationButtonStyle;
//   static ButtonStyle get disabledNavigationButton =>
//       disabledNavigationButtonStyle;

//   static Color get groupButtonSelected => primaryBlue.withAlpha(229);
//   static Color get groupButtonUnselected => primaryBlue.withAlpha(153);

//   // ────────────────────────────────────────────────────────────
//   // 📐 Dimensions & Padding
//   // ────────────────────────────────────────────────────────────
//   static const double buttonCornerRadius = 12.0;
//   static const double cardCornerRadius = 16.0;
//   static const double screenPadding = 16.0;

//   static const EdgeInsetsGeometry groupButtonPadding = EdgeInsets.symmetric(
//     vertical: 14,
//     horizontal: 24,
//   );

//   static const EdgeInsetsGeometry itemButtonPadding = EdgeInsets.symmetric(
//     vertical: 10,
//     horizontal: 12,
//   );

//   static const EdgeInsets cardPadding = EdgeInsets.all(12);

//   // ────────────────────────────────────────────────────────────
//   // 🌞 Light & 🌚 Dark Themes
//   // ────────────────────────────────────────────────────────────

//   static ThemeData get lightTheme => ThemeData(
//     useMaterial3: true,
//     scaffoldBackgroundColor: backgroundColor,
//     colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: primaryBlue,
//       foregroundColor: Colors.white,
//       centerTitle: true,
//       elevation: 0,
//       titleTextStyle: headingStyle,
//       iconTheme: IconThemeData(color: Colors.white),
//     ),
//     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//       backgroundColor: primaryBlue,
//       selectedItemColor: primaryRed,
//       unselectedItemColor: Colors.white70,
//       selectedIconTheme: IconThemeData(size: 26),
//       unselectedIconTheme: IconThemeData(size: 22),
//       selectedLabelStyle: buttonTextStyle,
//       unselectedLabelStyle: buttonTextStyle,
//       showUnselectedLabels: true,
//     ),
//     textTheme: textTheme,
//   );

//   static ThemeData get darkTheme => ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: darkBackground,
//     colorScheme: ColorScheme.dark(primary: primaryBlue, secondary: primaryRed),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: primaryBlue,
//       centerTitle: true,
//       elevation: 0,
//       titleTextStyle: headingStyle,
//       iconTheme: IconThemeData(color: Colors.white),
//     ),
//     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//       backgroundColor: primaryBlue,
//       selectedItemColor: Colors.white,
//       unselectedItemColor: Colors.white70,
//       selectedLabelStyle: buttonTextStyle,
//       unselectedLabelStyle: buttonTextStyle,
//     ),
//     textTheme: textTheme,
//   );
// }
