// 📄 lib/data/models/flashcard_model.dart

import 'package:bcc5/data/models/content_block.dart';

class FlashcardItem {
  final String id;
  final String title;
  final List<ContentBlock> content;

  FlashcardItem({required this.id, required this.title, required this.content});
}
