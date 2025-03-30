// 📄 lib/data/repositories/tools/tool_references_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';

final List<ToolItem> _references = [
  ToolItem(
    id: 'tool_references_1.00',
    title: 'Light and Sound Signals',
    content: [
      ContentBlock.text('Reference for navigation lights and sound signals:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('• One short blast = Port turn\n• Two = Starboard\n• Five = Danger/Confusion\n\nLights vary by vessel type — check official charts.'),
    ],
  ),
  ToolItem(
    id: 'tool_references_2.00',
    title: 'Day Shapes and Flags',
    content: [
      ContentBlock.text('Common day shapes used on vessels:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('• Ball-Diamond-Ball = Restricted in ability to maneuver\n• Single Ball = Anchored\n• Cone (point down) = Sailing + engine'),
    ],
  ),
];

List<ToolItem> getItemsForGroup(String toolbag) {
  assert(toolbag == 'references');
  return _references;
}

ToolItem? getItemById(String id) {
  return _references.firstWhere((item) => item.id == id, orElse: () => _references.first);
}

List<String> getGroupNames() => ['references'];

void assertIdsMatchRepositoryPrefix() {
  for (var item in _references) {
    assert(item.id.startsWith('tool_references_'), 'Invalid ID: ${item.id}');
  }
}
