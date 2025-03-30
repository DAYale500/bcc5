// 📄 lib/data/repositories/tools/tool_grabbag_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';

final List<ToolItem> _grabbag = [
  ToolItem(
    id: 'tool_grabbag_1.00',
    title: 'Grab Bag Must-Haves',
    content: [
      ContentBlock.text('Carry this bag when abandoning ship:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('- Passport & ID\n- Emergency cash & credit card\n- Medical prescriptions\n- Spare glasses\n- USB with boat docs'),
    ],
  ),
  ToolItem(
    id: 'tool_grabbag_2.00',
    title: 'Grab Bag Packing Tips',
    content: [
      ContentBlock.text('Keep it waterproof, light, and ready-to-go.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('- Use drybags or watertight cases\n- Label clearly\n- Store near emergency exit'),
    ],
  ),
];

List<ToolItem> getItemsForGroup(String toolbag) {
  assert(toolbag == 'grabbag');
  return _grabbag;
}

ToolItem? getItemById(String id) {
  return _grabbag.firstWhere((item) => item.id == id, orElse: () => _grabbag.first);
}

List<String> getGroupNames() => ['grabbag'];

void assertIdsMatchRepositoryPrefix() {
  for (var item in _grabbag) {
    assert(item.id.startsWith('tool_grabbag_'), 'Invalid ID: ${item.id}');
  }
}
