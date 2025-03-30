// 📄 lib/data/repositories/tools/tool_ditchbag_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class ToolDitchbagRepository {
  static final List<ToolItem> toolItems = [
    ToolItem(
      id: 'tool_ditchbag_1.00',
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
          id: 'flashcard_tool_ditchbag_1.00',
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
  ];
}
