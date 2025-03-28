// 🟠 part_model.dart

import 'package:bcc5/data/models/content_block.dart';

class PartItem {
  final String id; // e.g., part_hull_1.00
  final String title;
  final List<ContentBlock> content; // interleaved text and images
  final List<String> flashcardIds;
  final List<String> keywords;
  final bool isPaid;

  const PartItem({
    required this.id,
    required this.title,
    required this.content,
    this.flashcardIds = const [],
    this.keywords = const [],
    this.isPaid = false,
  });
}

class PartZone {
  final String name; // e.g., "Hull", "Deck"
  final List<PartItem> items;

  const PartZone({required this.name, required this.items});
}
