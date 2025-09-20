// lib/data/repositories/parts/json_part_repository.dart
// lib/data/repositories/parts/json_part_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/part_model.dart';

class JsonPartRepository {
  static Map<String, String>? _idToModule; // partId -> module (file stem)
  static List<String>? _partFiles; // all parts files (asset paths)
  static bool _isIndexing = false;

  static Future<void> _ensureIndex() async {
    if ((_idToModule != null && _partFiles != null) || _isIndexing) return;
    _isIndexing = true;
    try {
      final manifestRaw = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

      final files =
          manifest.keys
              .where(
                (k) =>
                    k.startsWith('assets/json/parts/') && k.endsWith('.json'),
              )
              .toList()
            ..sort();

      _partFiles = files;

      final map = <String, String>{};
      for (final path in files) {
        try {
          final raw = await rootBundle.loadString(path);
          final data = jsonDecode(raw) as Map<String, dynamic>;
          final List parts = (data['parts'] as List?) ?? const [];
          final module = path
              .split('/')
              .last
              .replaceAll('.json', ''); // file stem
          for (final p in parts) {
            if (p is Map && p['id'] != null) {
              final id = p['id'].toString();
              // first writer wins; log duplicates
              if (!map.containsKey(id)) {
                map[id] = module;
              } else {
                logger.w(
                  '⚠️ Duplicate part id "$id" in ${map[id]}.json and $module.json; keeping the first.',
                );
              }
            }
          }
        } catch (e, st) {
          logger.w('❌ Indexing parts: failed to read $path → $e\n$st');
        }
      }

      _idToModule = map;
      logger.i('🧩 Part index: ${map.length} ids across ${files.length} files');
    } catch (e, st) {
      logger.e('❌ Building parts index failed → $e\n$st');
      _partFiles = const [];
      _idToModule = const {};
    } finally {
      _isIndexing = false;
    }
  }

  /// Auto-discovers part modules (file stems).
  static Future<List<String>> getModuleNames() async {
    await _ensureIndex();
    final modules = <String>{};
    for (final p in _partFiles ?? const <String>[]) {
      modules.add(p.split('/').last.replaceAll('.json', ''));
    }
    final list = modules.toList()..sort();
    logger.i('🧩 Discovered part modules: ${list.join(', ')}');
    return list;
  }

  /// Lightweight rows for a module.
  static Future<List<Map<String, String>>> getPartsForModule(
    String module,
  ) async {
    final path = 'assets/json/parts/$module.json';
    logger.i('📄 Loading parts list from: $path');
    try {
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> map = jsonDecode(raw);
      final List parts = (map['parts'] as List?) ?? const [];
      logger.i('✅ $module.json parsed → ${parts.length} parts');
      return parts
          .map<Map<String, String>>(
            (e) => {
              'id': (e['id'] ?? '').toString(),
              'title': (e['title'] ?? e['id'] ?? '').toString(),
            },
          )
          .toList();
    } catch (e, st) {
      logger.w('❌ Could not load $path → $e\n$st');
      return [];
    }
  }

  /// Look up a single part by id from whichever file contains it.
  static Future<PartItem?> loadById(String id) async {
    await _ensureIndex();
    final module = _idToModule?[id];
    if (module == null) {
      logger.w('🕵️‍♂️ Part id not indexed: $id');
      return null;
    }
    final path = 'assets/json/parts/$module.json';
    try {
      logger.i('🔎 Parts: searching $id in $path');
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> map = jsonDecode(raw);
      final List parts = (map['parts'] as List?) ?? const [];
      final match = parts.cast<Map>().firstWhere(
        (e) => (e['id'] ?? '').toString() == id,
        orElse: () => const <String, dynamic>{},
      );
      if (match.isNotEmpty) {
        logger.i('📘 Parts: found $id in $path');
        return PartItem.fromJson(Map<String, dynamic>.from(match));
      }
    } catch (e, st) {
      logger.w('❌ Parts: failed to read $path → $e\n$st');
    }
    return null;
  }

  /// If you add/remove JSONs at runtime and want to rebuild without a full restart.
  static void invalidateIndex() {
    _idToModule = null;
    _partFiles = null;
  }
}

// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:bcc5/utils/logger.dart';
// import 'package:bcc5/data/models/part_model.dart';

// class JsonPartRepository {
//   /// Auto-discovers part modules from the asset bundle.
//   /// Looks for: `assets/json/parts/<module>.json`
//   static Future<List<String>> getModuleNames() async {
//     final manifestRaw = await rootBundle.loadString('AssetManifest.json');
//     final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

//     final partModulePaths =
//         manifest.keys
//             .where(
//               (k) => k.startsWith('assets/json/parts/') && k.endsWith('.json'),
//             )
//             .toList()
//           ..sort();

//     final modules = <String>{};
//     for (final p in partModulePaths) {
//       final fileName = p.split('/').last; // e.g., hull.json
//       final module = fileName.substring(0, fileName.length - '.json'.length);
//       modules.add(module);
//     }

//     final list = modules.toList()..sort();
//     logger.i('🧩 Discovered part modules: ${list.join(', ')}');
//     return list;
//   }

//   /// Returns lightweight rows for the module’s list UI: [{id, title}, ...]
//   /// Expects: `assets/json/parts/<module>.json` with a top-level "parts": [...]
//   static Future<List<Map<String, String>>> getPartsForModule(
//     String module,
//   ) async {
//     final path = 'assets/json/parts/$module.json';
//     logger.i('📄 Loading parts list from: $path');

//     try {
//       final raw = await rootBundle.loadString(path);
//       final Map<String, dynamic> map = jsonDecode(raw);
//       final List parts = (map['parts'] as List?) ?? const [];
//       logger.i('✅ $module.json parsed → ${parts.length} parts');

//       return parts
//           .map<Map<String, String>>(
//             (e) => {
//               'id': (e['id'] ?? '').toString(),
//               'title': (e['title'] ?? e['id'] ?? '').toString(),
//             },
//           )
//           .toList();
//     } catch (e, st) {
//       logger.w('❌ Could not load $path → $e\n$st');
//       return [];
//     }
//   }

//   static String? _moduleFor(String id) {
//     if (id.startsWith('part_hull_')) return 'hull';
//     if (id.startsWith('part_deck_')) return 'deck';
//     if (id.startsWith('part_rigg_') || id.startsWith('part_rigging_')) {
//       return 'rigging';
//     }
//     {}
//     if (id.startsWith('part_sail_') || id.startsWith('part_sails_')) {
//       return 'sails';
//     }
//     if (id.startsWith('part_intr_') || id.startsWith('part_interior_')) {
//       return 'interior';
//     }
//     return null;
//   }

//   /// Look up a single part by id from `assets/json/parts/<module>.json`
//   static Future<PartItem?> loadById(String id) async {
//     final module = _moduleFor(id);
//     if (module == null) {
//       logger.w('🕵️‍♂️ No module mapping for part id: $id');
//       return null;
//     }

//     final path = 'assets/json/parts/$module.json';
//     try {
//       logger.i('🔎 Parts: searching $id in $path');
//       final raw = await rootBundle.loadString(path);
//       final Map<String, dynamic> map = jsonDecode(raw);
//       final List parts = (map['parts'] as List?) ?? const [];

//       final match = parts.cast<Map>().firstWhere(
//         (e) => (e['id'] ?? '').toString() == id,
//         orElse: () => const <String, dynamic>{},
//       );
//       if (match.isNotEmpty) {
//         logger.i('📘 Parts: found $id in $path');
//         return PartItem.fromJson(Map<String, dynamic>.from(match));
//       }
//     } catch (e, st) {
//       logger.w('❌ Parts: failed to read $path → $e\n$st');
//     }
//     return null;
//   }
// }
