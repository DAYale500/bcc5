import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/data/models/content_block.dart';

class SystemsLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: 'lesson_systems_1.00',
      moduleId: 'systems',
      title: 'Battery Basics',
      content: [
        ContentBlock.heading('12V DC Systems'),
        ContentBlock.text('Most boats use 12-volt DC electrical systems.'),
        ContentBlock.image('assets/images/battery_system.jpeg'),
        ContentBlock.bullets([
          'Check voltage before and after trips.',
          'Know location of battery switches.',
          'Don’t overload circuits.',
        ]),
      ],
      keywords: ['systems', 'battery', 'electrical'],
      flashcardIds: ['fc_systems_1'],
      isPaid: false,
    ),
  ];
}
