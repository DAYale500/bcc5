// 📄 lib/data/models/tool_model.dart

import 'package:bcc5/data/models/content_block.dart';

class ToolItem {
  final String id;
  final String title;
  final List<ContentBlock> content;

  ToolItem({required this.id, required this.title, required this.content});
}
