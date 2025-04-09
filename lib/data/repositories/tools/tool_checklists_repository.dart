// 📄 lib/data/repositories/tools/tool_checklists_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class ToolChecklistsRepository {
  static final toolItems = <ToolItem>[
    ToolItem(
      id: 'tool_checklists_1.00',
      title: 'Pre-Departure Checklist',
      content: [
        ContentBlock.text('Ensure your boat is ready before leaving the dock.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          '1. Check weather\n2. Fuel & water\n3. Safety gear\n4. Float plan',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_checklists_1.00',
          title: 'Pre-Departure Essentials',
          sideA: [ContentBlock.text('What do you check before departure?')],
          sideB: [
            ContentBlock.text(
              'Weather, fuel, safety gear, float plan, comms, and crew briefing.',
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    ToolItem(
      id: 'tool_checklists_2.00',
      title: 'Arrival Checklist',
      content: [
        ContentBlock.text('Wrap things up efficiently at the end of a sail.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          '1. Secure boat\n2. Log trip\n3. Stow gear\n4. Rinse & tidy',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_checklists_2.00',
          title: 'Arrival Tasks',
          sideA: [ContentBlock.text('What are key arrival checklist items?')],
          sideB: [
            ContentBlock.text(
              'Secure lines, log trip, rinse gear, stow sails.',
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    ToolItem(
      id: 'tool_checklists_3.00',
      title: 'Ditch Bag Essentials',
      content: [
        ContentBlock.text('Critical items to include in your ditch bag:'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          '1. Waterproof VHF radio\n2. EPIRB/PLB\n3. Flares\n4. Water & rations\n5. First aid kit',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_checklists_3.00',
          title: 'Ditch Bag Contents',
          sideA: [
            ContentBlock.text('Name 3 essential items for your ditch bag.'),
          ],
          sideB: [
            ContentBlock.text('VHF, flares, EPIRB/PLB, food/water, first aid.'),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    ToolItem(
      id: 'tool_checklists_4.00',
      title: 'Headlamp Basics',
      content: [
        ContentBlock.text(
          'Use a red-light headlamp at night to preserve night vision.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('Check battery levels before departure.'),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_checklists_4.00',
          title: 'Night Vision Tip',
          sideA: [
            ContentBlock.text('What kind of headlamp preserves night vision?'),
          ],
          sideB: [ContentBlock.text('A red-light headlamp.')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    ToolItem(
      id: 'tool_checklists_5.00',
      title: 'Backup Navigation Tools',
      content: [
        ContentBlock.text('Always keep paper charts and a handheld compass.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Battery-powered GPS can fail; analog tools are essential.',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_checklists_5.00',
          title: 'Analog Navigation',
          sideA: [
            ContentBlock.text(
              'What are two essential analog nav tools to carry?',
            ),
          ],
          sideB: [ContentBlock.text('Paper charts and a handheld compass.')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
