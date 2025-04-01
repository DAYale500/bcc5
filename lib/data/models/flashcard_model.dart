// 📄 lib/data/models/flashcard_model.dart

import 'package:bcc5/data/models/content_block.dart';

class Flashcard {
  final String id;
  final String title;
  final List<ContentBlock> sideA;
  final List<ContentBlock> sideB;
  final bool isPaid;
  final bool showAFirst;

  Flashcard({
    required this.id,
    required this.title,
    List<ContentBlock>? sideA,
    List<ContentBlock>? sideB,
    required this.isPaid,
    required this.showAFirst,
  }) : sideA = sideA ?? [],
       sideB = sideB ?? [];
}
