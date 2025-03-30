// 📄 lib/data/repositories/tools/tool_procedures_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

final List<ToolItem> _procedures = [
  ToolItem(
    id: 'tool_procedures_1.00',
    title: 'Man Overboard Recovery',
    content: [
      ContentBlock.text('Steps to follow immediately:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text(
        '1. Shout "Man Overboard"\n2. Assign spotter\n3. Press MOB button\n4. Retrieve safely',
      ),
    ],
    flashcards: [
      Flashcard(
        id: 'flashcard_tool_procedures_1.00',
        title: 'Man Overboard – First Step',
        sideA: [
          ContentBlock.text(
            'What’s the first step when someone goes overboard?',
          ),
        ],
        sideB: [
          ContentBlock.text('Shout "Man Overboard" and assign a spotter.'),
        ],
        isPaid: false,
        showAFirst: true,
      ),
      Flashcard(
        id: 'flashcard_tool_procedures_1.01',
        title: 'Recovery Tools',
        sideA: [ContentBlock.text('Recovery tools to use?')],
        sideB: [ContentBlock.text('LifeSling or ladder.')],
        isPaid: false,
        showAFirst: true,
      ),
    ],
  ),
  ToolItem(
    id: 'tool_procedures_2.00',
    title: 'Engine Failure Response',
    content: [
      ContentBlock.text('Troubleshoot your engine:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text(
        '1. Shift to neutral\n2. Check kill switch\n3. Restart once\n4. Anchor or radio',
      ),
    ],
    flashcards: [
      Flashcard(
        id: 'flashcard_tool_procedures_2.00',
        title: 'Engine Failure Checklist',
        sideA: [ContentBlock.text('What to check first in engine failure?')],
        sideB: [ContentBlock.text('Neutral, kill switch, fuel, battery.')],
        isPaid: false,
        showAFirst: true,
      ),
    ],
  ),
];
