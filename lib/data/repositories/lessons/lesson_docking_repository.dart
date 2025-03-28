import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/lesson_model.dart';

class DockingLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: 'lesson_docking_1.00',
      moduleId: 'docking',
      title: 'Approaching the Dock',
      content: [
        ContentBlock.heading('Approach Strategy'),
        ContentBlock.text('Always plan your angle and speed when approaching.'),
        ContentBlock.image('assets/images/docking_example.jpeg'),
        ContentBlock.bullets([
          'Go slow — your fenders are your brakes.',
          'Account for wind and current.',
          'Crew should be ready with lines.',
        ]),
      ],
      keywords: ['docking', 'approach', 'fenders'],
      flashcardIds: ['fc_docking_1'],
      isPaid: false,
    ),
  ];
}
