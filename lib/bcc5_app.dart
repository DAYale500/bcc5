// 📄 lib/bcc5_app.dart

import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/navigation/app_router.dart';

class Bcc5App extends StatelessWidget {
  final bool showReminder;

  const Bcc5App({super.key, required this.showReminder});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BCC5 Sailing App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter, // You may need to inject showReminder into this
    );
  }
}
