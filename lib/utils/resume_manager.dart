import 'package:bcc5/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeManager {
  static const String _prefix = 'resume_';
  static const String _keyPathName = 'resume_path_name';
  static const String _keyChapterId = 'resume_chapter_id';
  static const String _keyItemId = 'resume_item_id';

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
}
