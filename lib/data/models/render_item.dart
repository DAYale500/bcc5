import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

enum RenderItemType { lesson, part, tool, flashcard }

class RenderItem {
  final RenderItemType type;
  final String id;
  final String title;
  final List<ContentBlock> content;
  final List<Flashcard> flashcards;

  RenderItem({
    required this.type,
    required this.id,
    required this.title,
    required this.content,
    required this.flashcards,
  });

  bool get isResolved => content.isNotEmpty || flashcards.isNotEmpty;
}
