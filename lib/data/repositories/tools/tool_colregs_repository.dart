// 📄 lib/data/repositories/tools/tool_colregs_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class ToolColregsRepository {
  static final List<ToolItem> toolItems = [
    ToolItem(
      id: 'tool_colregs_1.00',
      title: 'Light and Sound Signals',
      content: [
        ContentBlock.text('Reference for navigation lights and sound signals:'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          '• One short blast = Port turn\n'
          '• Two = Starboard\n'
          '• Five = Danger/Confusion',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_colregs_1.00',
          title: 'One Short Blast',
          sideA: [ContentBlock.text('What does one short blast mean?')],
          sideB: [ContentBlock.text('Turn to port.')],
          isPaid: false,
          showAFirst: true,
        ),
        Flashcard(
          id: 'flashcard_tool_colregs_1.01',
          title: 'Five Short Blasts',
          sideA: [
            ContentBlock.text('What is the meaning of five short blasts?'),
          ],
          sideB: [ContentBlock.text('Danger or confusion.')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    ToolItem(
      id: 'tool_colregs_2.00',
      title: 'Day Shapes and Flags',
      content: [
        ContentBlock.text('Common day shapes used on vessels:'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          '• Ball-Diamond-Ball = Restricted\n'
          '• Single Ball = Anchored\n'
          '• Cone (down) = Motor Sailing',
        ),
      ],
      flashcards: [
        Flashcard(
          id: 'flashcard_tool_colregs_2.00',
          title: 'Ball-Diamond-Ball',
          sideA: [ContentBlock.text('What does Ball-Diamond-Ball indicate?')],
          sideB: [ContentBlock.text('Restricted in ability to maneuver.')],
          isPaid: false,
          showAFirst: true,
        ),
        Flashcard(
          id: 'flashcard_tool_colregs_2.01',
          title: 'Anchored Day Shape',
          sideA: [ContentBlock.text('What day shape is used for anchoring?')],
          sideB: [ContentBlock.text('Single black ball.')],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
