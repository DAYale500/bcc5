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
  ];
}
