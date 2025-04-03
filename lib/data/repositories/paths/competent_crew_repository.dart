import 'package:bcc5/data/models/path_model.dart';

class CompetentCrewRepository {
  static final List<LearningPathChapter> _chapters = [
    for (int i = 1; i <= 6; i++)
      LearningPathChapter(
        id: 'path_competentCrew_${i.toStringAsFixed(2)}',
        // title: '$i: Chapter ${(i ^ 2)}',
        title: 'Chapter ${(i)}',
        items: [
          // 1. LESSON + FLASHCARD
          PathItem(pathItemId: 'lesson_syst_1.00'),
          PathItem(pathItemId: 'flashcard_lesson_syst_1.00'),

          // 2. PART + FLASHCARD
          PathItem(pathItemId: 'part_deck_1.00'),
          PathItem(pathItemId: 'flashcard_part_deck_1.00'),

          // 3. TOOL + FLASHCARD
          PathItem(pathItemId: 'tool_procedures_1.00'),
          PathItem(pathItemId: 'flashcard_tool_procedures_1.00'),

          // 4. LESSON + FLASHCARD
          PathItem(pathItemId: 'lesson_syst_2.00'),
          PathItem(pathItemId: 'flashcard_lesson_syst_2.00'),

          // 5. PART + FLASHCARD
          PathItem(pathItemId: 'part_hull_1.00'),
          PathItem(pathItemId: 'flashcard_part_hull_1.00'),

          // 6. TOOL + FLASHCARD
          PathItem(pathItemId: 'tool_procedures_2.00'),
          PathItem(pathItemId: 'flashcard_tool_procedures_2.00'),

          // 7. LESSON + FLASHCARD
          PathItem(pathItemId: 'lesson_syst_3.00'),
          PathItem(pathItemId: 'flashcard_lesson_syst_3.00'),

          // 8. PART + FLASHCARD
          PathItem(pathItemId: 'part_deck_2.00'),
          PathItem(pathItemId: 'flashcard_part_deck_2.00'),

          // 9. TOOL + FLASHCARD
          PathItem(pathItemId: 'tool_checklists_1.00'),
          PathItem(pathItemId: 'flashcard_tool_checklists_1.00'),

          // 10. LESSON + FLASHCARD
          PathItem(pathItemId: 'lesson_syst_6.00'),
          PathItem(pathItemId: 'flashcard_lesson_syst_6.00'),

          // 11. PART + FLASHCARD
          PathItem(pathItemId: 'part_hull_2.00'),
          PathItem(pathItemId: 'flashcard_part_hull_2.00'),

          // 12. TOOL + FLASHCARD
          PathItem(pathItemId: 'tool_checklists_2.00'),
          PathItem(pathItemId: 'flashcard_tool_checklists_2.00'),
        ],
      ),
  ];

  static List<LearningPathChapter> getChapters() => _chapters;
}
