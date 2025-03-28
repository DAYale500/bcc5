import 'content_block.dart';

class Lesson {
  final String id;
  final String moduleId;
  final String title;
  final List<ContentBlock> content;
  final List<String> keywords;
  final List<String> flashcardIds;
  final bool isPaid;

  Lesson({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.content,
    required this.keywords,
    required this.flashcardIds,
    required this.isPaid,
  });
}
