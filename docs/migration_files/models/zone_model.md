// From BCC4: lib/data/models/zone_model.dart

// 🟡 COMMENTARY:
// - Represents a “Part Zone” in BCC5.
// - Simple and maps directly to BCC5’s zone structure.
// ✅ Should be migrated directly with same name: BoatZone.

class BoatZone {
  final String id;
  final String title;

  BoatZone({required this.id, required this.title});
}
