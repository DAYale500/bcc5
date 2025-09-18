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

  factory ToolItem.fromJson(Map<String, dynamic> json) {
    return ToolItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? json['id'] ?? '').toString(),
      content:
          ((json['content'] as List?) ?? const [])
              .map((e) => ContentBlock.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
      flashcards:
          (json['flashcards'] as List? ?? const [])
              .map((e) => Flashcard.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
    );
  }
}
