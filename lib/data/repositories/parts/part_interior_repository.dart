import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/data/models/content_block.dart';

class InteriorPartRepository {
  static final List<PartItem> partItems = [
    PartItem(
      id: 'part_interior_1.00',
      title: 'Galley',
      keywords: ['kitchen', 'cooking'],
      isPaid: false,
      content: [
        ContentBlock.text('The galley is the cooking area aboard the boat.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('It includes a stove, sink, and storage for food.'),
      ],
      flashcards: [],
    ),
    PartItem(
      id: 'part_interior_2.00',
      title: 'Head',
      keywords: ['bathroom', 'toilet'],
      isPaid: false,
      content: [
        ContentBlock.text('The head is the marine toilet and washroom area.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('Proper use and maintenance are essential aboard.'),
      ],
      flashcards: [],
    ),
    PartItem(
      id: 'part_interior_3.00',
      title: 'Nav Station',
      keywords: ['navigation', 'chart table'],
      isPaid: false,
      content: [
        ContentBlock.text(
          'The nav station is where charts and electronics are used.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'It is a workspace for planning routes and monitoring instruments.',
        ),
      ],
      flashcards: [],
    ),
    PartItem(
      id: 'part_interior_4.00',
      title: 'Berths',
      keywords: ['bed', 'sleep'],
      isPaid: false,
      content: [
        ContentBlock.text('Berths are sleeping areas for crew members.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'They vary in size and comfort depending on the boat.',
        ),
      ],
      flashcards: [],
    ),
    PartItem(
      id: 'part_interior_5.00',
      title: 'Cabin Sole',
      keywords: ['floor', 'walking'],
      isPaid: false,
      content: [
        ContentBlock.text('The cabin sole is the floor of the interior cabin.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('It may lift up to reveal storage or bilge access.'),
      ],
      flashcards: [],
    ),
  ];
}
