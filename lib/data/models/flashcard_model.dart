// 📄 lib/data/models/flashcard_model.dart

import 'package:bcc5/data/models/content_block.dart';

class Flashcard {
  final String id;
  final String title;
  final List<ContentBlock> sideA;
  final List<ContentBlock> sideB;
  final bool isPaid;
  final bool showAFirst; // true = show sideA first, false = sideB first
  final List<String> keywords;

  const Flashcard({
    required this.id,
    required this.title,
    required this.sideA,
    required this.sideB,
    required this.isPaid,
    required this.showAFirst,
    this.keywords = const [],
  });
}
