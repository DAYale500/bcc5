import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/lesson_model.dart';

class NavigationLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: 'lesson_navigation_1.00',
      moduleId: 'navigation',
      title: 'Using a Compass',
      content: [
        ContentBlock.heading('Basic Compass Use'),
        ContentBlock.text(
          'A compass shows direction relative to magnetic north.',
        ),
        ContentBlock.image('assets/images/compass.jpeg'),
        ContentBlock.bullets([
          'Hold it flat and level.',
          'Avoid interference from metal.',
          'Use in conjunction with charts.',
        ]),
      ],
      keywords: ['navigation', 'compass', 'direction'],
      flashcardIds: ['fc_navigation_1'],
      isPaid: false,
    ),
  ];
}
