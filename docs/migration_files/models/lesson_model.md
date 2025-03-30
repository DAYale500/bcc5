// From BCC4: lib/data/models/lesson_model.dart

// 🟡 COMMENTARY:
// - Mostly maps to BCC5 lesson model structure.
// - Uses `module` field explicitly (BCC5 derives module from ID instead).
// - Does not yet include content blocks—just title and intro.
// 🔁 Should be merged with BCC5 `ContentItem` structure (with ID, title, content).

class Lesson {
  final String id;
  final String title;
  final String module; // e.g., "docking"
  final String intro;

  Lesson({
    required this.id,
    required this.title,
    required this.module,
    required this.intro,
  });
}
