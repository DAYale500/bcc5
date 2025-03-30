import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class ToolGrabbagRepository {
  static final List<ToolItem> toolItems = [
    ToolItem(
      id: 'tool_grabbag_1.00',
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
          id: 'flashcard_tool_grabbag_1.00',
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
      id: 'tool_grabbag_2.00',
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
          id: 'flashcard_tool_grabbag_2.00',
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
