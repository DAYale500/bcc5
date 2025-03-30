import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';

class ToolThumbrulesRepository {
  static final List<ToolItem> toolItems = [
    ToolItem(
      id: 'tool_thumbrules_1.00',
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
        // Optionally add flashcards later
      ],
      flashcards: [],
    ),
    ToolItem(
      id: 'tool_thumbrules_2.00',
      title: '6-Minute Rule (Speed/Distance)',
      content: [
        ContentBlock.text('Speed (knots) ÷ 10 = Distance in 6 minutes (NM).'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Example: 6 knots ÷ 10 = 0.6 NM traveled in 6 minutes.',
        ),
      ],
      flashcards: [],
    ),
  ];

  static void assertToolIdsMatchPrefix() {
    for (final item in toolItems) {
      assert(item.id.startsWith('tool_thumbrules_'), 'Invalid ID: ${item.id}');
    }
  }
}
