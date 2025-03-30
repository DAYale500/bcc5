// From BCC4: lib/data/models/navigation_step.dart

// ⚠️ COMMENTARY:
// - Used only in experimental path navigation logic.
// - Might not be necessary if BCC5 handles sequencing elsewhere.
// - Kept a `stepNumber` and `itemId` with some description text.
// 🔁 Possibly merge into a reusable “PathItem” or remove entirely.

class NavigationStep {
  final int stepNumber;
  final String itemId;
  final String description;

  NavigationStep({
    required this.stepNumber,
    required this.itemId,
    required this.description,
  });
}
