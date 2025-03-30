// From BCC4: lib/data/models/flashcard_category_model.dart

// 🟡 COMMENTARY:
// - This was used for grouping flashcards into categories (e.g. by module or zone).
// - May become obsolete in BCC5 if flashcards are embedded in lessons/parts.
// - Still useful if you want category browsing in the flashcard UI.

class FlashcardCategory {
  final String id;
  final String title;

  FlashcardCategory({required this.id, required this.title});
}
