// From BCC4: lib/data/repositories/paths/learning_path_competent_crew.dart

// 🟡 COMMENTARY:
// - This defines the Competent Crew learning path.
// - Each path step includes a type (`lesson`, `part`, or `flashcard`) and an `id`.
// - These steps represent a progression and are intended to guide the learner.
// - Still useful in BCC5. Needs migration to new structure with centralized repositories and new path step model.

final List<Map<String, String>> competentCrewPath = [
  {'type': 'lesson', 'id': 'lesson_docking_1.00'},
  {'type': 'lesson', 'id': 'lesson_safety_1.00'},
  {'type': 'flashcard', 'id': 'flashcard_lesson_safety_1.00'},
  {'type': 'part', 'id': 'part_hull_1.00'},
  {'type': 'lesson', 'id': 'lesson_navigation_2.00'},
  {'type': 'flashcard', 'id': 'flashcard_lesson_navigation_2.00'},
  {'type': 'lesson', 'id': 'lesson_emergencies_1.00'},
  {'type': 'flashcard', 'id': 'flashcard_lesson_emergencies_1.00'},
  {'type': 'lesson', 'id': 'lesson_terminology_1.00'},
  {'type': 'part', 'id': 'part_rigging_2.00'},
  {'type': 'lesson', 'id': 'lesson_knots_1.00'},
  {'type': 'flashcard', 'id': 'flashcard_lesson_knots_1.00'},
  {'type': 'part', 'id': 'part_sails_1.00'},
  {'type': 'lesson', 'id': 'lesson_systems_2.00'},
  {'type': 'flashcard', 'id': 'flashcard_lesson_systems_2.00'},
  {'type': 'lesson', 'id': 'lesson_teamwork_1.00'},
  {'type': 'lesson', 'id': 'lesson_seamanship_2.00'},
  {'type': 'part', 'id': 'part_deck_1.00'},
];
