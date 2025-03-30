// Source: BCC4 raw repository
// Module: seamanship

import 'package:bcc4/data/models/flashcard_model.dart';
import 'package:bcc4/data/models/lesson_model.dart';

final List<Lesson> seamanshipLessons = [
  Lesson(
    id: "lesson_seam_1.00",
    moduleId: "seamanship",
    title: "Raising the Sails",
    content: [
      "Learn the names of sails and the teamwork required to raise them properly."
    ],
    keywords: ["sails", "halyards", "winches"],
    partIds: ["part_halyards"],
    flashcardIds: ["flashcard_lesson_seam_1.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_seam_1.00",
        title: "FC: Raising the Sails",
        sideA: "What is the primary function of halyards?",
        sideB: "Halyards are used to hoist sails up the mast.",
        category: "Seamanship",
        referenceId: "lesson_seam_1.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_seam_2.00",
    moduleId: "seamanship",
    title: "Sailing Along - Trimming Sails",
    content: [
      "Learn how to trim sails to optimize performance based on wind conditions."
    ],
    keywords: ["sail trim", "tacking", "jibing"],
    partIds: ["part_rudder"],
    flashcardIds: ["flashcard_lesson_seam_2.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_seam_2.00",
        title: "FC: Sailing Along - Trimming Sails",
        sideA: "What does proper sail trimming achieve?",
        sideB:
            "It optimizes boat speed and efficiency by adjusting sails to wind conditions.",
        category: "Seamanship",
        referenceId: "lesson_seam_2.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_seam_3.00",
    moduleId: "seamanship",
    title: "Understanding Wind and Sail Interaction",
    content: [
      "Gain an understanding of how sails interact with the wind to generate propulsion."
    ],
    keywords: ["wind", "aerodynamics", "sail force"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_seam_3.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_seam_3.00",
        title: "FC: Understanding Wind and Sail Interaction",
        sideA: "How does wind generate propulsion on a sailboat?",
        sideB:
            "Wind flows over the sails, creating lift and pushing the boat forward.",
        category: "Seamanship",
        referenceId: "lesson_seam_3.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_seam_4.00",
    moduleId: "seamanship",
    title: "Heaving-To: How to Stop a Sailboat",
    content: [
      "Learn how to heave-to, an essential sailing maneuver to pause in open water."
    ],
    keywords: ["heaving-to", "stopping", "storm tactics"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_seam_4.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_seam_4.00",
        title: "FC: Heaving-To: How to Stop a Sailboat",
        sideA: "What is heaving-to?",
        sideB:
            "A maneuver where the sails and rudder are adjusted to keep the boat nearly stationary in the water.",
        category: "Seamanship",
        referenceId: "lesson_seam_4.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
];










File: lib/data/repositories/lessons/lesson_repository.dart
import 'package:bcc4/data/models/lesson_model.dart';
import 'package:bcc4/data/repositories/lessons/docking_lessons.dart';
import 'package:bcc4/data/repositories/lessons/emergencies_lessons.dart';
import 'package:bcc4/data/repositories/lessons/knots_lessons.dart';
import 'package:bcc4/data/repositories/lessons/navigation_lessons.dart';
import 'package:bcc4/data/repositories/lessons/safety_lessons.dart';
import 'package:bcc4/data/repositories/lessons/seamanship_lessons.dart';
import 'package:bcc4/data/repositories/lessons/systems_lessons.dart';
import 'package:bcc4/data/repositories/lessons/teamwork_lessons.dart';
import 'package:bcc4/data/repositories/lessons/terminology_lessons.dart';
import 'package:bcc4/utils/logger.dart';
import 'package:collection/collection.dart';

class LessonRepository {
  static final List<Lesson> lessons = [
    ...dockingLessons,
    ...emergenciesLessons,
    ...knotsLessons,
    ...navigationLessons,
    ...safetyLessons,
    ...seamanshipLessons,
    ...systemsLessons,
    ...teamworkLessons,
    ...terminologyLessons,
  ];

  // ✅ Get all lessons
  static List<Lesson> getAllLessons() => lessons;

  // ✅ Get lessons by module ID (with logging)
  static List<Lesson> getLessonsByModule(String moduleId) {
    final filteredLessons =
        lessons.where((lesson) => lesson.moduleId == moduleId).toList();
    // logger.i(
    //     '📚 [LessonRepository] getLessonsByModule("$moduleId") → Found ${filteredLessons.length} lessons');
    return filteredLessons;
  }

  static Lesson? getPreviousLesson(String lessonId, String moduleId) {
    final lessons = getLessonsByModule(moduleId);
    final index = lessons.indexWhere((l) => l.id == lessonId);
    return (index > 0) ? lessons[index - 1] : null;
  }

  static Lesson? getNextLesson(String lessonId, String moduleId) {
    final lessons = getLessonsByModule(moduleId);
    final index = lessons.indexWhere((l) => l.id == lessonId);
    return (index >= 0 && index < lessons.length - 1)
        ? lessons[index + 1]
        : null;
  }

  static Lesson getLessonById(String lessonId) {
    return getAllLessons().firstWhere(
      (lesson) => lesson.id == lessonId,
      orElse: () => throw Exception('Lesson not found with id $lessonId'),
    );
  }

  // ✅ **Find a lesson by ID (Refined)**
  static Lesson findLessonById(String lessonId) {
    final lesson = lessons.firstWhereOrNull((lesson) => lesson.id == lessonId);
    if (lesson == null) {
      logger.w('⚠️ [LessonRepository] Lesson not found for ID: $lessonId');
      return Lesson(
        id: "not_found",
        title: "Lesson Not Found",
        content: ["This lesson ID does not exist."],
        keywords: [],
        partIds: [],
        flashcardIds: [],
        moduleId: "unknown",
        flashcards: [],
        isPaid: false,
      );
    }
    return lesson;
  }
}










File: lib/data/repositories/lessons/module_repository.dart
// Relative path: lib/data/repositories/module_repository.dart

import 'package:bcc4/data/models/module_model.dart';
import 'package:bcc4/data/repositories/lessons/lesson_repository.dart';

final lessons = LessonRepository.getAllLessons();

class ModuleRepository {
  static final List<Module> modules = [
    Module(id: 'docking', title: 'Docking'),
    Module(id: 'emergencies', title: 'Emergencies'),
    Module(id: 'knots', title: 'Knots'),
    Module(id: 'navigation', title: 'Navigation'),
    Module(id: 'safety', title: 'Safety'),
    Module(id: 'seamanship', title: 'Seamanship'),
    Module(id: 'systems', title: 'Systems'),
    Module(id: 'teamwork', title: 'Teamwork'),
    Module(id: 'terminology', title: 'Terminology'),
  ];

  // ✅ Get all modules
  static List<Module> getAllModules() => modules;

  // ✅ Find module by ID
  static Module? findModuleById(String moduleId) {
    return modules.firstWhere(
      (module) => module.id == moduleId,
      orElse: () => Module(id: 'unknown', title: 'Unknown Module'),
    );
  }
}