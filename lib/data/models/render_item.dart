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

  /// Whether this item has any usable content or flashcards
  bool get isResolved => content.isNotEmpty || flashcards.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenderItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory RenderItem.fromFlashcard(Flashcard flashcard) {
    return RenderItem(
      id: flashcard.id,
      type: RenderItemType.flashcard,
      title: flashcard.title,
      content: flashcard.sideA, // or empty list if irrelevant
      flashcards: [flashcard],
    );
  }
}
