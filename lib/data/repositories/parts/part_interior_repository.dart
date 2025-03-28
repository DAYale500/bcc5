import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/data/models/content_block.dart';

final List<PartItem> interiorParts = [
  PartItem(
    id: 'part_interior_1.00',
    title: 'Galley',
    keywords: ['kitchen', 'cooking'],
    content: [
      ContentBlock.text('The galley is the cooking area aboard the boat.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('It includes a stove, sink, and storage for food.'),
    ],
  ),
  PartItem(
    id: 'part_interior_2.00',
    title: 'Head',
    keywords: ['bathroom', 'toilet'],
    content: [
      ContentBlock.text('The head is the marine toilet and washroom area.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('Proper use and maintenance are essential aboard.'),
    ],
  ),
  PartItem(
    id: 'part_interior_3.00',
    title: 'Nav Station',
    keywords: ['navigation', 'chart table'],
    content: [
      ContentBlock.text(
        'The nav station is where charts and electronics are used.',
      ),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text(
        'It is a workspace for planning routes and monitoring instruments.',
      ),
    ],
  ),
  PartItem(
    id: 'part_interior_4.00',
    title: 'Berths',
    keywords: ['bed', 'sleep'],
    content: [
      ContentBlock.text('Berths are sleeping areas for crew members.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('They vary in size and comfort depending on the boat.'),
    ],
  ),
  PartItem(
    id: 'part_interior_5.00',
    title: 'Cabin Sole',
    keywords: ['floor', 'walking'],
    content: [
      ContentBlock.text('The cabin sole is the floor of the interior cabin.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('It may lift up to reveal storage or bilge access.'),
    ],
  ),
];
