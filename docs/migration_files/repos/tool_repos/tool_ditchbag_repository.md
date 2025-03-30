// 📄 lib/data/repositories/tools/tool_ditchbag_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';

final List<ToolItem> _ditchbag = [
  ToolItem(
    id: 'tool_ditchbag_1.00',
    title: 'Essential Ditch Bag Contents',
    content: [
      ContentBlock.text('Your ditch bag should include:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('- Handheld VHF\n- EPIRB / PLB\n- Water & rations\n- Signal mirror & flares\n- First aid kit\n- Backup nav (compass/maps)'),
    ],
  ),
  ToolItem(
    id: 'tool_ditchbag_2.00',
    title: 'Ditch Bag Checklist',
    content: [
      ContentBlock.text('Verify contents monthly and before offshore passages.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('- All gear waterproofed\n- Batteries fresh\n- Expiration dates valid\n- Pack labeled + sealed'),
    ],
  ),
];

List<ToolItem> getItemsForGroup(String toolbag) {
  assert(toolbag == 'ditchbag');
  return _ditchbag;
}

ToolItem? getItemById(String id) {
  return _ditchbag.firstWhere((item) => item.id == id, orElse: () => _ditchbag.first);
}

List<String> getGroupNames() => ['ditchbag'];

void assertIdsMatchRepositoryPrefix() {
  for (var item in _ditchbag) {
    assert(item.id.startsWith('tool_ditchbag_'), 'Invalid ID: ${item.id}');
  }
}
