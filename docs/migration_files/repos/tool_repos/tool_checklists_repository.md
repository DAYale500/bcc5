// 📄 lib/data/repositories/tools/tool_checklists_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';

final List<ToolItem> _checklists = [
  ToolItem(
    id: 'tool_checklists_1.00',
    title: 'Pre-Departure Checklist',
    content: [
      ContentBlock.text('Confirm all items before leaving dock:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('- Weather checked\n- Float plan filed\n- Safety gear onboard\n- Fuel and water topped\n- Engine check complete'),
    ],
  ),
  ToolItem(
    id: 'tool_checklists_2.00',
    title: 'Anchoring Checklist',
    content: [
      ContentBlock.text('Steps to follow when anchoring:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('- Select safe depth and bottom type\n- Lower anchor slowly\n- Back down to set\n- Check swing radius\n- Monitor holding'),
    ],
  ),
];

List<ToolItem> getItemsForGroup(String toolbag) {
  assert(toolbag == 'checklists');
  return _checklists;
}

ToolItem? getItemById(String id) {
  return _checklists.firstWhere((item) => item.id == id, orElse: () => _checklists.first);
}

List<String> getGroupNames() => ['checklists'];

void assertIdsMatchRepositoryPrefix() {
  for (var item in _checklists) {
    assert(item.id.startsWith('tool_checklists_'), 'Invalid ID: ${item.id}');
  }
}
