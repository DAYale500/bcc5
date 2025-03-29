// 📄 lib/data/repositories/flashcards/flashcard_repository.dart

import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/models/content_block.dart';

List<FlashcardItem> getFlashcardsForCategory(String category) {
  return List.generate(10, (i) {
    return FlashcardItem(
      id: 'flashcard_${category}_$i',
      title: 'Flashcard ${i + 1} - $category',
      content: [
        ContentBlock.text('This is flashcard ${i + 1} for $category.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('Here is more helpful info.'),
      ],
    );
  });
}
