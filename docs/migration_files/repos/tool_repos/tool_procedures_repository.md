// 📄 lib/data/repositories/tools/tool_procedures_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';

final List<ToolItem> _procedures = [
  ToolItem(
    id: 'tool_procedures_1.00',
    title: 'Man Overboard Recovery',
    content: [
      ContentBlock.text('If someone falls overboard, follow these steps immediately:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('1. Shout "Man Overboard" and assign a spotter.\n2. Press MOB button if available.\n3. Throw flotation and turn the boat into a recovery loop.\n4. Retrieve using LifeSling or ladder.'),
    ],
  ),
  ToolItem(
    id: 'tool_procedures_2.00',
    title: 'Engine Failure Response',
    content: [
      ContentBlock.text('Steps to take when the engine fails unexpectedly:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('1. Shift to neutral and check fuel, battery, and kill switch.\n2. Attempt restart once.\n3. If failure persists, sail to safe position or anchor.\n4. Radio for assistance if needed.'),
    ],
  ),
];

List<ToolItem> getItemsForGroup(String toolbag) {
  assert(toolbag == 'procedures');
  return _procedures;
}

ToolItem? getItemById(String id) {
  return _procedures.firstWhere((item) => item.id == id, orElse: () => _procedures.first);
}

List<String> getGroupNames() => ['procedures'];

void assertIdsMatchRepositoryPrefix() {
  for (var item in _procedures) {
    assert(item.id.startsWith('tool_procedures_'), 'Invalid ID: ${item.id}');
  }
}
