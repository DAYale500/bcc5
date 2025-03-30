// 📄 lib/data/repositories/tools/tool_calculators_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class ToolCalculatorsRepository {
  static final List<ToolItem> toolItems = [
    ToolItem(
      id: 'tool_calculators_1.00',
      title: 'Hull Speed Calculator',
      content: [
        ContentBlock.text(
          'Use this formula to calculate theoretical hull speed:',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Hull Speed (knots) = 1.34 × √LWL (ft)\n\nExample: 25ft LWL → 1.34 × √25 = 6.7 knots',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_calculators_1.00',
          title: 'Hull Speed Formula',
          sideA: [ContentBlock.text('How do you calculate hull speed?')],
          sideB: [ContentBlock.text('Hull Speed = 1.34 × √LWL')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    ToolItem(
      id: 'tool_calculators_2.00',
      title: 'Fuel Consumption Estimator',
      content: [
        ContentBlock.text('Estimate range based on engine fuel burn rate:'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Range (nm) = Fuel Amount (gal) ÷ Burn Rate (gal/hr) × Speed (knots)',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_calculators_2.00',
          title: 'Fuel Range Formula',
          sideA: [
            ContentBlock.text('How to estimate cruising range from fuel?'),
          ],
          sideB: [ContentBlock.text('Range = Fuel ÷ Burn Rate × Speed')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
