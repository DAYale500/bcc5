// From BCC4: lib/data/models/part_model.dart

// 🟡 COMMENTARY:
// - Direct match to BCC5 `PartItem`, but missing structured content.
// - Like BCC4 lessons, includes zone as a field. BCC5 derives this from ID.
// 🔁 Needs refactor to use `ContentBlock` list instead of intro string.

class BoatPart {
  final String id;
  final String title;
  final String zone; // e.g., "Rigging"
  final String intro;

  BoatPart({
    required this.id,
    required this.title,
    required this.zone,
    required this.intro,
  });
}
