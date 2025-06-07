// lib/main.dart

import 'package:bcc5/widgets/tour/landing_screen_tour.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/bcc5_app.dart';
import 'package:bcc5/utils/settings_manager.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: override debugPrint for dev builds only
  if (kDebugMode) {
    final reviewedAt = await SettingsManager.getEmergencyInfoReviewedAt();
    final boatName = await SettingsManager.getBoatName();
    final tourShouldStart = await LandingScreenTour.shouldStart();

    logger.i('''
🧪 DEBUG STARTUP INFO:
- reviewedAt: $reviewedAt
- boatName: $boatName
- shouldStartTour: $tourShouldStart
''');
  }

  await SettingsManager.seedEmergencyDefaultsIfNeeded();
  final showReminder = await SettingsManager.shouldShowEmergencyReminder();
  final reviewedAt = await SettingsManager.getEmergencyInfoReviewedAt();
  logger.i('''
🚀 Reminder Check:
- showReminder: $showReminder
- reviewedAt: $reviewedAt
- shouldStartTour: ${await LandingScreenTour.shouldStart()}
''');

  // final showReminder = await SettingsManager.shouldShowEmergencyReminder();

  logger.i('''
🚀 App Launch | Emergency Reminder: $showReminder
🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀
🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
''');

  runApp(Bcc5App(showReminder: showReminder));
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Optional: override debugPrint for dev builds only
//   if (kDebugMode) {
//     final reviewedAt = await SettingsManager.getEmergencyInfoReviewedAt();
//     final boatName = await SettingsManager.getBoatName();
//     final tourShouldStart = await LandingScreenTour.shouldStart();

//     logger.i('''
// 🧪 DEBUG STARTUP INFO:
// - reviewedAt: $reviewedAt
// - boatName: $boatName
// - shouldStartTour: $tourShouldStart
// ''');
//   }

//   final showReminder = await _shouldShowEmergencyReminder();

//   logger.i('''
// 🚀 App Launch | Emergency Reminder: $showReminder
// 🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀
// 🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
// 🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
// 🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
// ''');

//   runApp(Bcc5App(showReminder: showReminder));
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Enable logging in release (for dev)
//   const bool isDebug = false; // set to false in release builds
//   if (isDebug) {
//     debugPrint = (String? message, {int? wrapWidth}) {
//       if (message != null) print('🔍 $message');
//     };
//   }

//   final showReminder = await _shouldShowEmergencyReminder();

//   logger.i('''
// 🚀 App Launch | Emergency Reminder: $showReminder
// 🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀
// 🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
// 🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
// 🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
// ''');

//   runApp(Bcc5App(showReminder: showReminder));
// }

// Future<bool> _shouldShowEmergencyReminder() async {
//   final enabled = await SettingsManager.getEmergencyReminderEnabled();
//   if (!enabled) return false;

//   // ✅ Skip check only on first launch (i.e. first-tour session)
//   final isFirstLaunch = await LandingScreenTour.shouldStart();
//   if (isFirstLaunch) return false;

//   // ✅ Always show after first launch — no 'reviewedAt' condition
//   return true;

//   // Legacy/future timing logic (commented for dev simplicity):
//   // final reviewedAt = await SettingsManager.getEmergencyInfoReviewedAt();
//   // if (reviewedAt == null) return true;
//   // final reviewedDate = DateTime.parse(reviewedAt);
//   // return DateTime.now().difference(reviewedDate).inDays > 30;
// }

// Future<bool> _shouldShowEmergencyReminder() async {
//   final enabled = await SettingsManager.getEmergencyReminderEnabled();
//   if (!enabled) return false;

//   final name = await SettingsManager.getBoatName();
//   final type = await SettingsManager.getVesselType();
//   final desc = await SettingsManager.getVesselDescription();
//   final adults = await SettingsManager.getSoulsAdults();
//   final children = await SettingsManager.getSoulsChildren();

//   final allFilled =
//       name.trim().isNotEmpty &&
//       type.trim().isNotEmpty &&
//       desc.trim().isNotEmpty &&
//       (adults > 0 || children > 0);

//   final reviewedAt = await SettingsManager.getEmergencyInfoReviewedAt();
//   return !allFilled || reviewedAt == null;
// }
