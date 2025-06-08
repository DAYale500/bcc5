import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/data/repositories/lessons/json_lesson_repository.dart';
import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart'; // legacy fallback
import 'package:bcc5/utils/logger.dart';

class ContentLoader {
  static final _lessonCache = <String, Lesson?>{};

  static Future<Lesson?> loadLessonById(String id) async {
    if (_lessonCache.containsKey(id)) return _lessonCache[id];

    final jsonLesson = await JsonLessonRepository.loadById(id);
    if (jsonLesson != null) {
      _lessonCache[id] = jsonLesson;
      return jsonLesson;
    }

    logger.w('⚠️ Falling back to Dart for $id');
    final fallback = LessonRepositoryIndex.getLessonById(id);
    _lessonCache[id] = fallback;
    return fallback;
  }
}
