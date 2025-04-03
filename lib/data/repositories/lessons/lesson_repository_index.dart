import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/utils/logger.dart';

import 'lesson_docking_repository.dart';
import 'lesson_emergencies_repository.dart';
import 'lesson_knots_repository.dart';
import 'lesson_navigation_repository.dart';
import 'lesson_safety_repository.dart';
import 'lesson_seamanship_repository.dart';
import 'lesson_systems_repository.dart';
import 'lesson_teamwork_repository.dart';
import 'lesson_terminology_repository.dart';
import 'package:bcc5/data/models/lesson_model.dart';

class LessonRepositoryIndex {
  static final Map<String, List<Lesson>> _modules = {
    'docking': DockingLessonRepository.lessons,
    'emergencies': EmergenciesLessonRepository.lessons,
    'knots': KnotsLessonRepository.lessons,
    'navigation': NavigationLessonRepository.lessons,
    'safety': SafetyLessonRepository.lessons,
    'seamanship': SeamanshipLessonRepository.lessons,
    'systems': SystemsLessonRepository.lessons,
    'teamwork': TeamworkLessonRepository.lessons,
    'terminology': TerminologyLessonRepository.lessons,
  };

  static List<String> getModuleNames() => _modules.keys.toList();

  static List<Lesson> getLessonsForModule(String moduleId) =>
      _modules[moduleId] ?? [];

  static Lesson? getLessonById(String lessonId) {
    for (final lessons in _modules.values) {
      for (final lesson in lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    return null;
  }

  static String? getModuleForLessonId(String lessonId) {
    for (final entry in _modules.entries) {
      if (entry.value.any((lesson) => lesson.id == lessonId)) {
        return entry.key;
      }
    }
    return null;
  }

  static List<Lesson> getAllLessons() =>
      _modules.values.expand((list) => list).toList();

  static Flashcard? getFlashcardById(String id) {
    logger.i('🔍 Scanning lessons for flashcard id: $id');

    for (final lesson in getAllLessons()) {
      for (final card in lesson.flashcards) {
        if (card.id == id) {
          logger.i('✅ Match found in lesson for $id');
          return card;
        }
      }
    }

    logger.w('❌ Flashcard not found in lesson modules for id: $id');
    return null;
  }

  static void assertAllLessonIdsMatchModules() {
    for (final entry in _modules.entries) {
      for (final lesson in entry.value) {
        assert(
          lesson.id.startsWith('lesson_${entry.key}_'),
          'Lesson ID mismatch: ${lesson.id} should start with lesson_${entry.key}_',
        );
      }
    }
  }

  static void assertAllFlashcardIdsValid() {
    for (final entry in _modules.entries) {
      for (final lesson in entry.value) {
        for (final card in lesson.flashcards) {
          assert(
            card.id.startsWith('flashcard_lesson_${entry.key}_'),
            'Flashcard ID mismatch in module ${entry.key}: ${card.id}',
          );
        }
      }
    }
  }
}
