import 'package:bcc5/navigation/app_router.dart'; // ✅ Add if not already imported
import 'package:bcc5/utils/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeManager {
  static const String _prefix = 'resume_';
  static const String _keyPathName = 'resume_path_name';
  static const String _keyChapterId = 'resume_chapter_id';
  static const String _keyItemId = 'resume_item_id';
  static bool shouldRestartTour = false;

  static Future<void> saveProgress({
    required String pathName,
    required String chapterId,
    required String itemId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix${pathName.toLowerCase()}';
    final value = '$chapterId|$itemId';
    await prefs.setString(key, value);
  }

  static Future<(String chapterId, String itemId)?> getProgress(
    String pathName,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix${pathName.toLowerCase()}';
    final value = prefs.getString(key);
    if (value == null) return null;

    final parts = value.split('|');
    if (parts.length != 2) return null;

    return (parts[0], parts[1]); // chapterId, itemId
  }

  static Future<void> clearProgress(String pathName) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix${pathName.toLowerCase()}';
    await prefs.remove(key);
  }

  static Future<void> clearResumePoint() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPathName);
    await prefs.remove(_keyChapterId);
    await prefs.remove(_keyItemId);
  }

  static Future<void> saveResumePoint({
    required String pathName,
    required String chapterId,
    required String itemId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPathName, pathName);
    await prefs.setString(_keyChapterId, chapterId);
    await prefs.setString(_keyItemId, itemId);
    logger.i('💾 Saved resume point → $pathName / $chapterId / $itemId');
  }

  static Future<Map<String, String>?> getResumePoint() async {
    final prefs = await SharedPreferences.getInstance();

    final pathName = prefs.getString(_keyPathName);
    final chapterId = prefs.getString(_keyChapterId);
    final itemId = prefs.getString(_keyItemId);

    if (pathName == null || chapterId == null || itemId == null) {
      return null;
    }

    return {'pathName': pathName, 'chapterId': chapterId, 'itemId': itemId};
  }

  static Future<void> resume() async {
    final prefs = await SharedPreferences.getInstance();
    final resumePath = prefs.getString('resumePath');
    final resumeExtra = prefs.getString('resumeExtra');

    if (resumePath == null) {
      logger.i('⛔ No resume path found. Skipping resume.');
      return;
    }

    logger.i('🔁 Resuming app at: $resumePath');

    if (navigatorKey.currentState == null) {
      logger.e('❌ navigatorKey.currentState is null — cannot resume.');
      return;
    }

    navigatorKey.currentState!.pushNamed(
      resumePath,
      arguments: resumeExtra, // ✅ FIX: use "arguments" instead of "extra"
    );
  }

  // resume_manager.dart
  static void manualStartTour() async {
    logger.i('🎯 Manual tour triggering reset');

    final context = navigatorKey.currentContext;
    if (context == null) {
      logger.e('❌ No navigatorKey context found — cannot start tour');
      return;
    }

    final goRouter = GoRouter.of(context);

    // 🚩 Check if already on LandingScreen
    if (goRouter.routerDelegate.currentConfiguration.fullPath == '/') {
      logger.i('🏁 Already on LandingScreen — setting shouldRestartTour');
      ResumeManager.shouldRestartTour = true;
    } else {
      logger.i('🔀 Navigating to LandingScreen to restart tour');
      ResumeManager.shouldRestartTour = true;
      appRouter.goNamed('landing');
    }
    // if (goRouter.routerDelegate.currentConfiguration.fullPath == '/') {
    //   logger.i('🏠 Already on LandingScreen — restarting tour immediately');
    //   LandingScreen.restartTourGlobal();
    // } else {
    //   logger.i('🔀 Navigating to LandingScreen first');
    //   // Close modals or extra screens
    //   navigatorKey.currentState!.popUntil((route) => route.isFirst);

    //   // Go home
    //   goRouter.go('/');

    //   // Wait for LandingScreen to rebuild
    //   await Future.delayed(const Duration(milliseconds: 300));

    //   LandingScreen.restartTourGlobal();
    // }

    // Optional: reset any tour prefs
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenTour', false);
  }
}
