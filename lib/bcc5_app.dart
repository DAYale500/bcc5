import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/navigation/app_router.dart';

class Bcc5App extends StatelessWidget {
  const Bcc5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BCC5 Sailing App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // Optional: enable when needed
      // themeMode: ThemeMode.system,   // Optional: system-based theming
      routerConfig: appRouter,
    );
  }
}
