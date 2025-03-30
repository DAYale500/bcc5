// 📄 lib/data/repositories/tools/tool_calculators_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';

final List<ToolItem> _calculators = [
  ToolItem(
    id: 'tool_calculators_1.00',
    title: 'Hull Speed Calculator',
    content: [
      ContentBlock.text('Use this formula to calculate theoretical hull speed:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('Hull Speed (knots) = 1.34 × √LWL (ft)\n\nExample: 25ft LWL → 1.34 × √25 = 6.7 knots'),
    ],
  ),
  ToolItem(
    id: 'tool_calculators_2.00',
    title: 'Fuel Consumption Estimator',
    content: [
      ContentBlock.text('Estimate range based on engine fuel burn rate:'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('Range (nm) = Fuel Amount (gal) ÷ Burn Rate (gal/hr) × Speed (knots)'),
    ],
  ),
];

List<ToolItem> getItemsForGroup(String toolbag) {
  assert(toolbag == 'calculators');
  return _calculators;
}

ToolItem? getItemById(String id) {
  return _calculators.firstWhere((item) => item.id == id, orElse: () => _calculators.first);
}

List<String> getGroupNames() => ['calculators'];

void assertIdsMatchRepositoryPrefix() {
  for (var item in _calculators) {
    assert(item.id.startsWith('tool_calculators_'), 'Invalid ID: ${item.id}');
  }
}
