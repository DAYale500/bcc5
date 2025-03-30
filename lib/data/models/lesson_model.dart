// 📄 lib/data/models/lesson_model.dart

import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class Lesson {
  final String id;
  final String title;
  final List<ContentBlock> content;
  final List<String> keywords;
  final List<Flashcard> flashcards;
  final bool isPaid;

  const Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.keywords,
    required this.flashcards,
    required this.isPaid,
  });
}
