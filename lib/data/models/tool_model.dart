// 📄 lib/data/models/tool_model.dart

import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class ToolItem {
  final String id;
  final String title;
  final List<ContentBlock> content;
  final List<Flashcard> flashcards;

  const ToolItem({
    required this.id,
    required this.title,
    required this.content,
    required this.flashcards,
  });
}
