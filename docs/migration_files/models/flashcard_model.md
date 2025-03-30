// From BCC4: lib/data/models/flashcard_model.dart

// 🟡 COMMENTARY:
// - Already mostly compatible with BCC5 flashcard model.
// - Includes flexible structure: sides A/B, multiple choice, source reference.
// - Already supports paid/free status and front-side preference.
// ✅ Recommend reusing this model with minimal refactoring (rename type to enum?).

class Flashcard {
  final String id; // Unique identifier
  final String title; // ✅ Title field
  final String sideA; // First possible side
  final String sideB; // Second possible side
  final List<String> options; // Multiple-choice options (optional)
  final String category; // Module or Zone (e.g., "Navigation")
  final String referenceId; // ID of associated lesson or part
  final String type; // "lesson" or "part" — consider changing to enum in BCC5
  final bool isPaid; // Paid or free content
  final String? preferredFront; // Optional: "A" or "B"

  Flashcard({
    required this.id,
    required this.title,
    required this.sideA,
    required this.sideB,
    this.options = const [],
    required this.category,
    required this.referenceId,
    required this.type,
    required this.isPaid,
    this.preferredFront,
  });
}
