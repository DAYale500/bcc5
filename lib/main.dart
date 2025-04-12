// lib/main.dart

// 📄 lib/main.dart

import 'package:flutter/material.dart';
import 'package:bcc5/bcc5_app.dart';
import 'package:bcc5/utils/settings_manager.dart';
import 'package:bcc5/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final showReminder = await _shouldShowEmergencyReminder();

  logger.i('''
🚀 App Launch | Emergency Reminder: $showReminder
🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀
🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
''');

  runApp(Bcc5App(showReminder: showReminder));
}

Future<bool> _shouldShowEmergencyReminder() async {
  final enabled = await SettingsManager.getEmergencyReminderEnabled();
  if (!enabled) return false;

  final name = await SettingsManager.getBoatName();
  final type = await SettingsManager.getVesselType();
  final desc = await SettingsManager.getVesselDescription();
  final adults = await SettingsManager.getSoulsAdults();
  final children = await SettingsManager.getSoulsChildren();

  final allFilled =
      name.trim().isNotEmpty &&
      type.trim().isNotEmpty &&
      desc.trim().isNotEmpty &&
      (adults > 0 || children > 0);

  final reviewedAt = await SettingsManager.getEmergencyInfoReviewedAt();
  return !allFilled || reviewedAt == null;
}

// import 'package:flutter/material.dart';
// import 'package:bcc5/bcc5_app.dart';
// import 'package:bcc5/utils/logger.dart'; // Make sure this is imported

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   logger.i('''
// 🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀
// 🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
// 🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
// 🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
// ''');

//   runApp(const Bcc5App());
// }
