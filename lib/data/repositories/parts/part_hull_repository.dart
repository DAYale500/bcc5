import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

final List<PartItem> hullParts = [
  PartItem(
    id: 'part_hull_1.00',
    title: 'Keel',
    keywords: ['stability', 'ballast'],
    isPaid: false,
    content: [
      ContentBlock.text(
        'The keel provides stability and prevents sideways drift.',
      ),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('It also adds weight low in the hull for balance.'),
    ],
    flashcards: [
      Flashcard(
        id: 'flashcard_part_hull_1.00',
        title: 'FC: Keel Function',
        sideA: [ContentBlock.text('What does the keel do?')],
        sideB: [ContentBlock.text('It adds stability and reduces leeway.')],
        isPaid: false,
        showAFirst: true,
      ),
    ],
  ),
  PartItem(
    id: 'part_hull_2.00',
    title: 'Rudder',
    keywords: ['steering', 'control'],
    isPaid: false,
    content: [
      ContentBlock.text('The rudder is used to steer the boat.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('It is controlled by the wheel or tiller.'),
    ],
    flashcards: [
      Flashcard(
        id: 'flashcard_part_hull_2.00',
        title: 'FC: Rudder Role',
        sideA: [ContentBlock.text('What is the rudder for?')],
        sideB: [ContentBlock.text('To steer the boat.')],
        isPaid: false,
        showAFirst: true,
      ),
    ],
  ),
  PartItem(
    id: 'part_hull_3.00',
    title: 'Hull Skin',
    keywords: ['structure', 'shell'],
    isPaid: false,
    content: [
      ContentBlock.text('The hull skin is the outer structure of the boat.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('It protects against water and provides shape.'),
    ],
    flashcards: [
      Flashcard(
        id: 'flashcard_part_hull_3.00',
        title: 'FC: Hull Skin',
        sideA: [ContentBlock.text('What is the hull skin?')],
        sideB: [ContentBlock.text('The watertight shell of the boat.')],
        isPaid: false,
        showAFirst: true,
      ),
    ],
  ),
  PartItem(
    id: 'part_hull_4.00',
    title: 'Through-Hulls',
    keywords: ['plumbing', 'drainage'],
    isPaid: false,
    content: [
      ContentBlock.text(
        'Through-hulls allow water or waste to pass in/out of the boat.',
      ),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('They must be sealed properly to prevent leaks.'),
    ],
    flashcards: [
      Flashcard(
        id: 'flashcard_part_hull_4.00',
        title: 'FC: Through-Hulls',
        sideA: [ContentBlock.text('What are through-hulls used for?')],
        sideB: [ContentBlock.text('For plumbing in and out of the hull.')],
        isPaid: false,
        showAFirst: true,
      ),
    ],
  ),
  PartItem(
    id: 'part_hull_5.00',
    title: 'Bilge',
    keywords: ['drain', 'lowest point'],
    isPaid: false,
    content: [
      ContentBlock.text(
        'The bilge is the lowest interior space where water collects.',
      ),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text(
        'Pumps remove water from this area to keep the boat dry.',
      ),
    ],
    flashcards: [
      Flashcard(
        id: 'flashcard_part_hull_5.00',
        title: 'FC: Bilge Purpose',
        sideA: [ContentBlock.text('What is the bilge?')],
        sideB: [
          ContentBlock.text('The lowest part of the boat that collects water.'),
        ],
        isPaid: false,
        showAFirst: true,
      ),
    ],
  ),
];
