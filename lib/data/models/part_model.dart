// 🟠 part_model.dart

import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

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
}

class PartZone {
  final String name; // e.g., "Hull", "Deck"
  final List<PartItem> items;

  const PartZone({required this.name, required this.items});
}
