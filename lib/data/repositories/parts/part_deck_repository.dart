import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class DeckPartRepository {
  static final List<PartItem> partItems = [
    PartItem(
      id: 'part_deck_1.00',
      title: 'Deck Cleats',
      keywords: ['cleat', 'tie', 'dock'],
      isPaid: false,
      content: [
        ContentBlock.text(
          'Deck cleats are used for securing lines on the boat.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'They are usually mounted on the deck near mooring points.',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_part_deck_1.00',
          title: 'Cleat Use',
          sideA: [ContentBlock.text('What is the purpose of a deck cleat?')],
          sideB: [
            ContentBlock.text('To secure lines like dock lines or fenders.'),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    PartItem(
      id: 'part_deck_2.00',
      title: 'Winches',
      keywords: ['winch', 'line handling', 'tension'],
      isPaid: false,
      content: [
        ContentBlock.text(
          'Winches provide mechanical advantage for tightening lines.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('Used for trimming sails and controlling tension.'),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_part_deck_2.00',
          title: 'Winch Function',
          sideA: [
            ContentBlock.text('Why are winches important on a sailboat?'),
          ],
          sideB: [
            ContentBlock.text('They help manage line tension when sailing.'),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    PartItem(
      id: 'part_deck_3.00',
      title: 'Lifelines',
      keywords: ['safety', 'fence', 'rail'],
      isPaid: false,
      content: [
        ContentBlock.text(
          'Lifelines help prevent crew from falling overboard.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('They run along the edges of the deck for safety.'),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_part_deck_3.00',
          title: 'Lifeline Role',
          sideA: [ContentBlock.text('What is the function of lifelines?')],
          sideB: [ContentBlock.text('To provide a safety barrier on deck.')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    PartItem(
      id: 'part_deck_4.00',
      title: 'Stanchions',
      keywords: ['post', 'lifeline support'],
      isPaid: false,
      content: [
        ContentBlock.text(
          'Stanchions are vertical posts supporting lifelines.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'They are mounted securely along the deck perimeter.',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_part_deck_4.00',
          title: 'Stanchion Function',
          sideA: [ContentBlock.text('What are stanchions used for?')],
          sideB: [ContentBlock.text('To support and anchor lifelines.')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    PartItem(
      id: 'part_deck_5.00',
      title: 'Deck Hatches',
      keywords: ['hatch', 'ventilation'],
      isPaid: false,
      content: [
        ContentBlock.text(
          'Deck hatches provide access and ventilation below deck.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'They often include seals and locks for watertightness.',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_part_deck_5.00',
          title: 'Hatch Use',
          sideA: [ContentBlock.text('Why are deck hatches important?')],
          sideB: [ContentBlock.text('They provide light, air, and access.')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
