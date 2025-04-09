// 📄 lib/data/repositories/tools/references_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class ToolReferencesRepository {
  static final List<ToolItem> toolItems = [
    ToolItem(
      id: 'tool_reference_1.00',
      title: 'Rule of 12ths (Tide Estimation)',
      content: [
        ContentBlock.text('Estimate tidal rise/fall hourly:'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Tide moves:\n'
          '- 1/12 in 1st hour\n'
          '- 2/12 in 2nd\n'
          '- 3/12 in 3rd (then mirrors down)\n'
          'Use for anchoring & under-keel clearance.',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_reference_1.00',
          title: 'Rule of 12ths',
          sideA: [
            ContentBlock.text(
              'How does the Rule of 12ths estimate tidal movement?',
            ),
          ],
          sideB: [
            ContentBlock.text(
              'The tide moves:\n'
              '- 1/12 in 1st hour\n'
              '- 2/12 in 2nd\n'
              '- 3/12 in 3rd\n'
              '(Then mirrors down)',
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    ToolItem(
      id: 'tool_reference_2.00',
      title: '6-Minute Rule (Speed/Distance)',
      content: [
        ContentBlock.text('Speed (knots) ÷ 10 = Distance in 6 minutes (NM).'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Example: 6 knots ÷ 10 = 0.6 NM traveled in 6 minutes.',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_reference_2.00',
          title: '6-Minute Rule',
          sideA: [
            ContentBlock.text(
              'How do you estimate distance traveled in 6 minutes?',
            ),
          ],
          sideB: [ContentBlock.text('Distance = Speed (knots) ÷ 10')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    ToolItem(
      id: 'tool_reference_3.00',
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
          id: 'flashcard_tool_reference_3.00',
          title: 'Hull Speed Formula',
          sideA: [ContentBlock.text('What is the formula for hull speed?')],
          sideB: [ContentBlock.text('Hull Speed = 1.34 × √LWL (in feet)')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    ToolItem(
      id: 'tool_reference_4.00',
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
          id: 'flashcard_tool_reference_4.00',
          title: 'Fuel Range Formula',
          sideA: [
            ContentBlock.text(
              'How do you calculate range using fuel and speed?',
            ),
          ],
          sideB: [ContentBlock.text('Range = Fuel ÷ Burn Rate × Speed')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];

  static void assertToolIdsAreSequential() {
    for (var i = 0; i < toolItems.length; i++) {
      final expectedId = 'tool_reference_${(i + 1).toStringAsFixed(2)}';
      assert(
        toolItems[i].id == expectedId,
        'Mismatched ID: ${toolItems[i].id} ≠ $expectedId',
      );
    }
  }
}
