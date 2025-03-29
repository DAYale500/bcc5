import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'navigation/main_scaffold.dart';
import 'screens/home/landing_screen.dart';

class Bcc5App extends StatelessWidget {
  const Bcc5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCC5 Sailing App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScaffold(branchIndex: 0, child: LandingScreen()),
    );
  }
}
