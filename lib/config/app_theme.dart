import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF0077B6);
  static const Color primaryRed = Color(0xFFCC0000);

  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
    useMaterial3: true,
  );
}
