// lib/data/repositories/lessons/json_lesson_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/lesson_model.dart';

class JsonLessonRepository {
  // In-memory, rebuilt on hot restart
  static final Map<String, List<Map<String, String>>> _moduleToRows = {};
  static final Map<String, String> _idToModule = {};
  static bool _built = false;

  // ------------------------------ Discovery ------------------------------

  static Future<List<String>> getModuleNames() async {
    final manifestRaw = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

    // Only lesson JSONs, ignore obvious backups
    final paths =
        manifest.keys
            .where(
              (k) =>
                  k.startsWith('assets/json/lessons/') &&
                  k.endsWith('.json') &&
                  !_looksLikeBackup(k),
            )
            .toList()
          ..sort();

    final modules = <String>{};
    for (final p in paths) {
      final fileName = p.split('/').last; // e.g., emergencies.json
      final module = fileName.substring(0, fileName.length - '.json'.length);
      modules.add(module);
    }

    final list = modules.toList()..sort();
    logger.i('📦 Discovered lesson modules: ${list.join(', ')}');
    return list;
  }

  static bool _looksLikeBackup(String path) {
    final name = path.split('/').last.toLowerCase();
    return name.contains('.bak') ||
        name.endsWith('~') ||
        name.startsWith('_') ||
        name.contains('deprecated') ||
        name.contains('backup');
  }

  // ------------------------------ Indexing ------------------------------

  static Future<void> _buildIndex() async {
    if (_built) return;
    _moduleToRows.clear();
    _idToModule.clear();

    final modules = await getModuleNames();
    for (final module in modules) {
      final rows = await _readModuleRows(module);
      _moduleToRows[module] = rows;
      for (final row in rows) {
        final id = row['id'];
        if (id == null || id.isEmpty) continue;
        // Keep first occurrence; warn on duplicates
        if (_idToModule.containsKey(id)) {
          logger.w(
            '⚠️ Duplicate lesson id "$id" in ${_idToModule[id]} and $module; keeping the first.',
          );
          continue;
        }
        _idToModule[id] = module;
      }
    }
    _built = true;
  }

  static Future<List<Map<String, String>>> _readModuleRows(
    String module,
  ) async {
    final path = 'assets/json/lessons/$module.json';
    try {
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> map = jsonDecode(raw);
      final List lessons = (map['lessons'] as List?) ?? const [];
      return lessons.map<Map<String, String>>((e) {
        final m = Map<String, dynamic>.from(e as Map);
        return {
          'id': (m['id'] ?? '').toString(),
          'title': (m['title'] ?? m['id'] ?? '').toString(),
        };
      }).toList();
    } catch (e, st) {
      logger.w('❌ Could not load $path → $e\n$st');
      return const [];
    }
  }

  // ------------------------------ Public API ------------------------------

  /// Lightweight rows for the list UI
  static Future<List<Map<String, String>>> getLessonsForModule(
    String module,
  ) async {
    await _buildIndex();
    final cached = _moduleToRows[module];
    if (cached != null) return cached;
    // If not indexed (new file added after first call), read it now.
    final rows = await _readModuleRows(module);
    _moduleToRows[module] = rows;
    for (final r in rows) {
      final id = r['id'];
      if (id != null && id.isNotEmpty && !_idToModule.containsKey(id)) {
        _idToModule[id] = module;
      }
    }
    return rows;
  }

  /// Find a single lesson by id in whichever file contains it.
  static Future<Lesson?> loadById(String id) async {
    await _buildIndex();

    // If the id is known, go straight to the right file.
    final knownModule = _idToModule[id];
    final searchModules =
        (knownModule != null)
            ? <String>[knownModule]
            : _moduleToRows.keys.toList();

    // Fallback: if index is empty (e.g., manifest edge cases), scan all modules we can find now.
    if (searchModules.isEmpty) {
      searchModules.addAll(await getModuleNames());
    }

    for (final module in searchModules) {
      final path = 'assets/json/lessons/$module.json';
      try {
        final raw = await rootBundle.loadString(path);
        final Map<String, dynamic> map = jsonDecode(raw);
        final List lessons = (map['lessons'] as List?) ?? const [];
        final match = lessons.cast<Map>().firstWhere(
          (e) => (e['id'] ?? '').toString() == id,
          orElse: () => const <String, dynamic>{},
        );
        if (match.isNotEmpty) {
          // Update index in case this was a fallback find
          _idToModule[id] = module;
          return Lesson.fromJson(Map<String, dynamic>.from(match));
        }
      } catch (e, st) {
        logger.w('❌ Lessons: failed to read $path → $e\n$st');
      }
    }

    logger.w('❌ Lesson not found in any module for id: $id');
    return null;
  }

  /// Call this if you add/remove JSONs at runtime and want to rebuild.
  static Future<void> rebuildIndex() async {
    _built = false;
    await _buildIndex();
  }
}

// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:bcc5/utils/logger.dart';
// import 'package:bcc5/data/models/lesson_model.dart';

// class JsonLessonRepository {
//   /// Auto-discovers lesson modules from the asset bundle.
//   /// Looks for: `assets/json/lessons/<module>.json`
//   static Future<List<String>> getModuleNames() async {
//     final manifestRaw = await rootBundle.loadString('AssetManifest.json');
//     final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

//     final lessonModulePaths =
//         manifest.keys
//             .where(
//               (k) =>
//                   k.startsWith('assets/json/lessons/') && k.endsWith('.json'),
//             )
//             .toList()
//           ..sort();

//     final modules = <String>{};
//     for (final p in lessonModulePaths) {
//       final fileName = p.split('/').last; // e.g., terminology.json
//       final module = fileName.substring(0, fileName.length - '.json'.length);
//       modules.add(module);
//     }

//     final list = modules.toList()..sort();
//     logger.i('📦 Discovered lesson modules: ${list.join(', ')}');
//     return list;
//   }

//   /// Returns lightweight rows for the module’s list UI: [{id, title}, ...]
//   /// Expects: `assets/json/lessons/<module>.json` with a top-level "lessons": [...]
//   static Future<List<Map<String, String>>> getLessonsForModule(
//     String module,
//   ) async {
//     final path = 'assets/json/lessons/$module.json';
//     logger.i('📄 Loading lessons list from: $path');

//     try {
//       final raw = await rootBundle.loadString(path);
//       final Map<String, dynamic> map = jsonDecode(raw);
//       final List lessons = (map['lessons'] as List?) ?? const [];
//       logger.i('✅ $module.json parsed → ${lessons.length} lessons');

//       return lessons
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
//     if (id.startsWith('lesson_dock_')) return 'docking';
//     if (id.startsWith('lesson_safety_')) return 'safety';
//     if (id.startsWith('lesson_emer_')) return 'emergencies';
//     if (id.startsWith('lesson_seam_')) return 'seamanship';
//     if (id.startsWith('lesson_term_')) return 'terminology';
//     if (id.startsWith('lesson_syst_')) return 'systems';
//     if (id.startsWith('lesson_team_')) return 'teamwork';
//     if (id.startsWith('lesson_knot_') || id.startsWith('lesson_knots_')) {
//       return 'knots';
//     }
//     if (id.startsWith('lesson_nav_')) return 'navigation';
//     return null;
//   }

//   /// Finds a single lesson by id inside its module file.
//   /// Expects: `assets/json/lessons/<module>.json`
//   static Future<Lesson?> loadById(String id) async {
//     final module = _moduleFor(id);
//     if (module == null) {
//       logger.w('🕵️‍♂️ No module mapping for lesson id: $id');
//       return null;
//     }

//     final path = 'assets/json/lessons/$module.json';
//     try {
//       logger.i('🔎 Lessons: searching $id in $path');
//       final raw = await rootBundle.loadString(path);
//       final Map<String, dynamic> map = jsonDecode(raw);
//       final List lessons = (map['lessons'] as List?) ?? const [];

//       final match = lessons.cast<Map>().firstWhere(
//         (e) => (e['id'] ?? '').toString() == id,
//         orElse: () => const <String, dynamic>{},
//       );
//       if (match.isNotEmpty) {
//         logger.i('📘 Lessons: found $id in $path');
//         return Lesson.fromJson(Map<String, dynamic>.from(match));
//       }
//     } catch (e, st) {
//       logger.w('❌ Lessons: failed to read $path → $e\n$st');
//     }
//     return null;
//   }
// }
