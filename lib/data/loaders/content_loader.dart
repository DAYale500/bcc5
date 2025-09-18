// lib/data/loaders/content_loader.dart
//
// JSON-only content loader. No legacy fallbacks.
//
// This utility centralizes "load X by id" calls so the rest of the app
// doesn’t need to know which repository owns an ID. If an ID is unknown,
// we log and return null.

import 'package:bcc5/utils/logger.dart';

// JSON-backed repositories
import 'package:bcc5/data/repositories/lessons/json_lesson_repository.dart';
import 'package:bcc5/data/repositories/parts/json_part_repository.dart';
import 'package:bcc5/data/repositories/tools/json_tool_repository.dart';

class ContentLoader {
  const ContentLoader._();

  /// Route to the proper JSON repo based on the ID prefix.
  /// Returns the underlying model from the repo (lesson/part/tool) or null.
  static Future<dynamic> loadById(String id) async {
    if (id.startsWith('lesson_')) {
      return await JsonLessonRepository.loadById(id);
    }
    if (id.startsWith('part_')) {
      return await JsonPartRepository.loadById(id);
    }
    if (id.startsWith('tool_')) {
      return await JsonToolRepository.loadById(id);
    }
    logger.w('ContentLoader.loadById → unknown id prefix: $id');
    return null;
    // If you later add JSON-backed flashcards with ids like "flashcard_…",
    // add a branch here that calls your JsonFlashcardRepository.
  }

  /// Explicit JSON-only helpers (kept for call-sites that prefer them).
  static Future<dynamic> loadLessonById(String id) =>
      JsonLessonRepository.loadById(id);

  static Future<dynamic> loadPartById(String id) =>
      JsonPartRepository.loadById(id);

  static Future<dynamic> loadToolById(String id) =>
      JsonToolRepository.loadById(id);
}

// import 'package:bcc5/data/models/lesson_model.dart';
// import 'package:bcc5/data/repositories/lessons/json_lesson_repository.dart';
// import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart'; // legacy fallback
// import 'package:bcc5/utils/logger.dart';

// class ContentLoader {
//   static final _lessonCache = <String, Lesson?>{};

//   static Future<Lesson?> loadLessonById(String id) async {
//     if (_lessonCache.containsKey(id)) return _lessonCache[id];

//     final jsonLesson = await JsonLessonRepository.loadById(id);
//     if (jsonLesson != null) {
//       _lessonCache[id] = jsonLesson;
//       return jsonLesson;
//     }

//     logger.w('⚠️ Falling back to Dart for $id');
//     final fallback = LessonRepositoryIndex.getLessonById(id);
//     _lessonCache[id] = fallback;
//     return fallback;
//   }
// }
