import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/utils/logger.dart';

class JsonLessonRepository {
  static Future<Lesson?> loadById(String id) async {
    final possibleFolders = [
      'assets/json/lessons/docking',
      'assets/json/lessons/safety',
      'assets/json/lessons/emergencies',
      // add other folders as needed
    ];

    for (final folder in possibleFolders) {
      final path = '$folder/$id.json';
      try {
        final rawJson = await rootBundle.loadString(path);
        final map = jsonDecode(rawJson);
        final lesson = Lesson.fromJson(map);
        logger.i('📘 Loaded $id from $path');
        return lesson;
      } catch (e) {
        // Continue trying other folders silently
      }
    }

    logger.w('🕵️‍♂️ Could not find JSON for lesson $id');
    return null;
  }
}
