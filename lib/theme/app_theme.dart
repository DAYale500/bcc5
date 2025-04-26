import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF163FE8);
  static const Color primaryRed = Color.fromARGB(255, 255, 0, 0);
  static const Color backgroundColor = Colors.white;
  static const Color darkBackground = Color(0xFF121212);

  static const Color infoColor = primaryBlue;
  static const Color errorColor = primaryRed;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  static const Color disabledGray = Colors.grey;

  static const double textScaleMultiplier = 1.5;

  static const TextStyle headingStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

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
  static ButtonStyle get landingPrimaryButton => largeRedButton;

  // For the "Next" button (already good enough but tighten if you want)
  static final ButtonStyle tourNextButton = ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: Colors.white,
    minimumSize: const Size(160, 48),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonCornerRadius),
    ),
  );

  // For the "Exit" button (needs fix)
  static final ButtonStyle tourExitButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: primaryRed, // 🔥 Change from primaryBlue ➔ primaryRed
    side: const BorderSide(color: primaryRed, width: 2), // 🔥 Also border red
    minimumSize: const Size(160, 48),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonCornerRadius),
    ),
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle branchBreadcrumbStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle groupBreadcrumbStyle = TextStyle(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: Colors.black87,
  );

  static const TextStyle detailTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryBlue,
  );

  static const TextTheme textTheme = TextTheme(
    headlineLarge: headingStyle,
    headlineMedium: subheadingStyle,
    bodyLarge: bodyTextStyle,
    labelLarge: buttonTextStyle,
    bodySmall: captionStyle,
  );

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

  static Color get groupButtonSelected => primaryBlue.withAlpha(229);
  static Color get groupButtonUnselected => primaryBlue.withAlpha(153);

  static ButtonStyle get navigationButton => navigationButtonStyle;
  static ButtonStyle get disabledNavigationButton =>
      disabledNavigationButtonStyle;
}
