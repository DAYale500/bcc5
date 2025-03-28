import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/data/models/content_block.dart';

class SeamanshipLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: 'lesson_seamanship_1.00',
      moduleId: 'seamanship',
      title: 'Line Handling Skills',
      content: [
        ContentBlock.heading('Why It Matters'),
        ContentBlock.text(
          'Proper line handling prevents accidents and damage.',
        ),
        ContentBlock.image('assets/images/line_handling.jpeg'),
        ContentBlock.bullets([
          'Coil lines neatly to avoid tangles.',
          'Never step into a loop.',
          'Wear gloves when handling under load.',
        ]),
      ],
      keywords: ['seamanship', 'line', 'handling'],
      flashcardIds: ['fc_seamanship_1'],
      isPaid: false,
    ),
  ];
}
