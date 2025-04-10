import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/utils/logger.dart';

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

  static List<String> getZoneNames() => _zones.keys.toList();

  static List<PartItem> getPartsForZone(String zone) =>
      _zones[zone.toLowerCase()] ?? [];

  static PartItem? getPartById(String id) {
    for (final items in _zones.values) {
      for (final item in items) {
        if (item.id == id) return item;
      }
    }
    return null;
  }

  static List<PartItem> getAllParts() =>
      _zones.values.expand((list) => list).toList();

  static Flashcard? getFlashcardById(String id) {
    logger.i('🔍 Looking for flashcard in parts: $id');

    for (final part in getAllParts()) {
      for (final card in part.flashcards) {
        if (card.id == id) {
          logger.i('✅ Found flashcard in part: ${card.id}');
          return card;
        }
      }
    }

    logger.w('❌ Flashcard not found in part zones for id: $id');
    return null;
  }

  static String? getZoneForPartId(String partId) {
    for (final entry in _zones.entries) {
      if (entry.value.any((item) => item.id == partId)) {
        return entry.key;
      }
    }
    return null;
  }

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

  static String? getNextZone(String currentZoneId) {
    final zoneNames = getZoneNames();
    final currentIndex = zoneNames.indexOf(currentZoneId.toLowerCase());
    if (currentIndex == -1 || currentIndex + 1 >= zoneNames.length) return null;
    return zoneNames[currentIndex + 1];
  }
}
