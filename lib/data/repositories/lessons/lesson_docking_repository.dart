// 📄 lib/data/repositories/lessons/lesson_docking_repository.dart

import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/lesson_model.dart';

class DockingLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: 'lesson_dock_1.00',
      title: 'L1: Handling Dock Lines',
      content: [
        ContentBlock.text(
          'Learn how to approach the dock methodically to ensure smooth arrivals.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Use dock lines effectively to secure the boat in variable conditions.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Crew coordination and preparation makes docking safer and easier.',
        ),
      ],
      keywords: [],
      isPaid: false,
      flashcards: [],
    ),
    Lesson(
      id: 'lesson_dock_2.00',
      title: 'L2: Anchoring - Setting Up',
      content: [
        ContentBlock.text(
          'Anchoring starts with understanding the seabed and wind direction.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Use visual cues and depth sounders to choose a safe location.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Scope and anchor type are critical to holding strength.',
        ),
      ],
      keywords: [],
      isPaid: false,
      flashcards: [],
    ),
    Lesson(
      id: 'lesson_dock_3.00',
      title: 'Basics of Side Ties',
      content: [
        ContentBlock.text(
          'Side ties are useful when rafting up with other boats.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Proper fender placement protects both vessels from contact damage.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Choose knots that are secure but easy to untie under load.',
        ),
      ],
      keywords: [],
      isPaid: false,
      flashcards: [],
    ),
    Lesson(
      id: 'lesson_dock_4.00',
      title: 'Returning to Dock - Docking Procedure',
      content: [
        ContentBlock.text(
          'Slow and controlled movements are key when entering a slip.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Crew should be briefed and in position before final approach.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Use visual alignment with dock features to stay centered.',
        ),
      ],
      keywords: [],
      isPaid: false,
      flashcards: [],
    ),
    Lesson(
      id: 'lesson_dock_5.00',
      title: 'Basic Deck Safety and Boom Awareness',
      content: [
        ContentBlock.text(
          'Always maintain three points of contact while on deck.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Watch the boom\'s position to avoid surprise jibes.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Secure loose lines and gear to prevent trip hazards.',
        ),
      ],
      keywords: [],
      isPaid: false,
      flashcards: [],
    ),
    Lesson(
      id: 'lesson_dock_6.00',
      title: 'How to Assist in Docking',
      content: [
        ContentBlock.text(
          'Crew should be stationed and aware of their docking role.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Lines should be coiled and ready to deploy quickly.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Communication between helm and crew is essential for timing.',
        ),
      ],
      keywords: [],
      isPaid: false,
      flashcards: [],
    ),
    Lesson(
      id: 'lesson_dock_7.00',
      title: 'How to Assist in Anchoring',
      content: [
        ContentBlock.text(
          'Listen carefully to helm commands and anticipate needs.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Ensure the anchor is free to drop and flaked correctly.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('Watch for signs of dragging or improper setting.'),
      ],
      keywords: [],
      isPaid: false,
      flashcards: [],
    ),
    Lesson(
      id: 'lesson_dock_8.00',
      title: 'Lowering the Anchor Safely',
      content: [
        ContentBlock.text(
          'Approach into the wind and stop the boat before dropping anchor.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('Let the rode out steadily to avoid tangles.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Observe how the anchor sets and adjust scope if necessary.',
        ),
      ],
      keywords: [],
      isPaid: false,
      flashcards: [],
    ),
    Lesson(
      id: 'lesson_dock_9.00',
      title: 'Raising the Anchor Safely',
      content: [
        ContentBlock.text(
          'Coordinate engine movement with winch operation to reduce strain.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Ensure crew hands are clear of the windlass during retrieval.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Secure the anchor and check it\'s seated properly before departure.',
        ),
      ],
      keywords: [],
      isPaid: false,
      flashcards: [],
    ),
  ];
}
