import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/data/models/content_block.dart';

final List<PartItem> hullParts = [
  PartItem(
    id: 'part_hull_1.00',
    title: 'Keel',
    keywords: ['stability', 'ballast'],
    content: [
      ContentBlock.text(
        'The keel provides stability and prevents sideways drift.',
      ),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('It also adds weight low in the hull for balance.'),
    ],
  ),
  PartItem(
    id: 'part_hull_2.00',
    title: 'Rudder',
    keywords: ['steering', 'control'],
    content: [
      ContentBlock.text('The rudder is used to steer the boat.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('It is controlled by the wheel or tiller.'),
    ],
  ),
  PartItem(
    id: 'part_hull_3.00',
    title: 'Hull Skin',
    keywords: ['structure', 'shell'],
    content: [
      ContentBlock.text('The hull skin is the outer structure of the boat.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('It protects against water and provides shape.'),
    ],
  ),
  PartItem(
    id: 'part_hull_4.00',
    title: 'Through-Hulls',
    keywords: ['plumbing', 'drainage'],
    content: [
      ContentBlock.text(
        'Through-hulls allow water or waste to pass in/out of the boat.',
      ),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('They must be sealed properly to prevent leaks.'),
    ],
  ),
  PartItem(
    id: 'part_hull_5.00',
    title: 'Bilge',
    keywords: ['drain', 'lowest point'],
    content: [
      ContentBlock.text(
        'The bilge is the lowest interior space where water collects.',
      ),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text(
        'Pumps remove water from this area to keep the boat dry.',
      ),
    ],
  ),
];
