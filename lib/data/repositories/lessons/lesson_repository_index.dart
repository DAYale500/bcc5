import 'lesson_docking_repository.dart';
import 'lesson_emergencies_repository.dart';
import 'lesson_knots_repository.dart';
import 'lesson_navigation_repository.dart';
import 'lesson_safety_repository.dart';
import 'lesson_seamanship_repository.dart';
import 'lesson_systems_repository.dart';
import 'lesson_teamwork_repository.dart';
import 'lesson_terminology_repository.dart';
import 'package:bcc5/utils/id_parser.dart';
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

  void assertLessonIdsMatchModules(List<Lesson> lessons) {
    for (final lesson in lessons) {
      final parsedGroup = getGroupFromId(lesson.id);
      assert(
        lesson.id.startsWith('lesson_${parsedGroup}_'),
        'Lesson ID mismatch: ${lesson.id} should match group $parsedGroup',
      );
    }
  }
}
