import 'package:bcc5/data/models/part_model.dart';
import 'part_deck_repository.dart';
import 'part_hull_repository.dart';
import 'part_interior_repository.dart';
import 'part_rigging_repository.dart';
import 'part_sails_repository.dart';

class PartRepositoryIndex {
  static final Map<String, List<PartItem>> _zones = {
    'deck': DeckPartRepository.partItems,
    'hull': HullPartRepository.partItems,
    'interior': InteriorPartRepository.partItems,
    'rigging': RiggingPartRepository.partItems,
    'sails': SailsPartRepository.partItems,
  };

  /// Returns a list of all zone names
  static List<String> getZoneNames() => _zones.keys.toList();

  /// Gets all parts for a specific zone
  static List<PartItem> getPartsForZone(String zone) =>
      _zones[zone.toLowerCase()] ?? [];

  /// Looks up a part by ID
  static PartItem? getPartById(String id) {
    for (final items in _zones.values) {
      for (final item in items) {
        if (item.id == id) return item;
      }
    }
    return null;
  }

  /// Resolves a part ID to its zone
  static String? getZoneForPartId(String partId) {
    for (final entry in _zones.entries) {
      if (entry.value.any((item) => item.id == partId)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Validates all part IDs match zone prefixes
  static void assertPartIdsMatchZonePrefixes() {
    _zones.forEach((zone, items) {
      for (final item in items) {
        assert(
          item.id.startsWith('part_${zone}_'),
          'Invalid ID in $zone: ${item.id}',
        );
      }
    });
  }
}
