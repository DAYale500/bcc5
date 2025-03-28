import 'package:flutter/material.dart';

class AppTheme {
  // 🟠 Primary Colors
  static const Color primaryBlue = Color(0xFF0077B6);
  static const Color primaryRed = Color(0xFFCC0000);

  // 🟠 Light Theme (Material 3)
  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    textTheme: textTheme,
  );

  // 🟠 Typography Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
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

  // 🟠 Button Variants
  static const double buttonCornerRadius = 12.0;

  static const EdgeInsetsGeometry groupButtonPadding = EdgeInsets.symmetric(
    vertical: 14,
    horizontal: 24,
  );

  static const EdgeInsetsGeometry itemButtonPadding = EdgeInsets.symmetric(
    vertical: 10,
    horizontal: 12,
  );

  // 🟠 TextTheme for full app integration
  static const TextTheme textTheme = TextTheme(
    headlineLarge: headingStyle,
    headlineMedium: subheadingStyle,
    bodyLarge: bodyTextStyle,
    labelLarge: buttonTextStyle,
  );
}
