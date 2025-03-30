import 'package:flutter/material.dart';

class AppTheme {
  // 🔵 Primary Colors
  static const Color primaryBlue = Color(0xFF163FE8); // System-wide blue
  static const Color primaryRed = Color(0xFFCC0000); // Accent/alert color
  static const Color backgroundColor = Colors.white;
  static const Color darkBackground = Color(0xFF121212);

  // 🧠 Semantic Color Aliases
  static const Color infoColor = primaryBlue;
  static const Color errorColor = primaryRed;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  static const Color disabledGray = Colors.grey;

  // 🌤️ Light Theme
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

  // 🌑 Dark Theme
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

  // ✍️ Typography
  static const TextStyle headingStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
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

  static const TextTheme textTheme = TextTheme(
    headlineLarge: headingStyle,
    headlineMedium: subheadingStyle,
    bodyLarge: bodyTextStyle,
    labelLarge: buttonTextStyle,
    bodySmall: captionStyle,
  );

  // 📏 Radius, Padding, Margins
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

  // ⬇️ Add near the bottom of AppTheme
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
}
