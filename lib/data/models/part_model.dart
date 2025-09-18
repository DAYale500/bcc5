// lib/data/models/part_model.dart
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart'; // <- Flashcard type & .fromJson

// local helper: turn JSON list -> List<ContentBlock>
List<ContentBlock> _blocksFromJson(dynamic v) {
  final list = (v as List?) ?? const [];
  return list
      .map<ContentBlock>(
        (e) => ContentBlock.fromJson(Map<String, dynamic>.from(e as Map)),
      )
      .toList();
}

class PartItem {
  final String id;
  final String title;
  final List<ContentBlock> content;
  final List<Flashcard> flashcards;
  final List<String> keywords;
  final bool isPaid;

  const PartItem({
    required this.id,
    required this.title,
    required this.content,
    required this.flashcards,
    this.keywords = const [],
    this.isPaid = false,
  });

  factory PartItem.fromJson(Map<String, dynamic> json) {
    return PartItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? json['id'] ?? '').toString(),
      content: _blocksFromJson(json['content']),
      keywords: (json['keywords'] as List?)?.cast<String>() ?? const [],
      isPaid: json['isPaid'] as bool? ?? false,
      flashcards:
          (json['flashcards'] as List?)
              ?.map((e) => Flashcard.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
    );
  }
}

class PartZone {
  final String name; // e.g., "Hull", "Deck"
  final List<PartItem> items;

  const PartZone({required this.name, required this.items});
}
