import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/lesson_model.dart';

class EmergenciesLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: 'lesson_emergencies_1.00',
      moduleId: 'emergencies',
      title: 'Man Overboard (MOB) Response',
      content: [
        ContentBlock.heading('Immediate Action'),
        ContentBlock.text(
          'Yell "Man Overboard!" and throw a floatation device.',
        ),
        ContentBlock.image('assets/images/mob.jpeg'),
        ContentBlock.bullets([
          'Press MOB button on GPS (if available).',
          'Assign a spotter to keep eyes on person.',
          'Prepare for quick recovery turn.',
        ]),
      ],
      keywords: ['emergency', 'man overboard', 'MOB'],
      flashcardIds: ['fc_emergencies_1'],
      isPaid: false,
    ),
  ];
}
