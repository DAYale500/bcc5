// 📄 lib/data/repositories/tools/tool_repository.dart

import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';

List<ToolItem> getToolsForBag(String toolbag) {
  return List.generate(8, (i) {
    return ToolItem(
      id: 'tool_${toolbag}_$i',
      title: 'Tool ${i + 1} - $toolbag',
      content: [
        ContentBlock.text('Tool ${i + 1} details for $toolbag bag.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('Use this tool for specific procedures.'),
      ],
    );
  });
}
