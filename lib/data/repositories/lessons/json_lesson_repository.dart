// lib/data/repositories/lessons/json_lesson_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/lesson_model.dart';

class JsonLessonRepository {
  /// Auto-discovers lesson modules from the asset bundle.
  /// Looks for: `assets/json/lessons/<module>.json`
  static Future<List<String>> getModuleNames() async {
    final manifestRaw = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

    final lessonModulePaths =
        manifest.keys
            .where(
              (k) =>
                  k.startsWith('assets/json/lessons/') && k.endsWith('.json'),
            )
            .toList()
          ..sort();

    final modules = <String>{};
    for (final p in lessonModulePaths) {
      final fileName = p.split('/').last; // e.g., terminology.json
      final module = fileName.substring(0, fileName.length - '.json'.length);
      modules.add(module);
    }

    final list = modules.toList()..sort();
    logger.i('📦 Discovered lesson modules: ${list.join(', ')}');
    return list;
  }

  /// Returns lightweight rows for the module’s list UI: [{id, title}, ...]
  /// Expects: `assets/json/lessons/<module>.json` with a top-level "lessons": [...]
  static Future<List<Map<String, String>>> getLessonsForModule(
    String module,
  ) async {
    final path = 'assets/json/lessons/$module.json';
    logger.i('📄 Loading lessons list from: $path');

    try {
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> map = jsonDecode(raw);
      final List lessons = (map['lessons'] as List?) ?? const [];
      logger.i('✅ $module.json parsed → ${lessons.length} lessons');

      return lessons
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

  static String? _moduleFor(String id) {
    if (id.startsWith('lesson_dock_')) return 'docking';
    if (id.startsWith('lesson_safety_')) return 'safety';
    if (id.startsWith('lesson_emer_')) return 'emergencies';
    if (id.startsWith('lesson_seam_')) return 'seamanship';
    if (id.startsWith('lesson_term_')) return 'terminology';
    if (id.startsWith('lesson_syst_')) return 'systems';
    if (id.startsWith('lesson_team_')) return 'teamwork';
    if (id.startsWith('lesson_knot_') || id.startsWith('lesson_knots_')) {
      return 'knots';
    }
    if (id.startsWith('lesson_nav_')) return 'navigation';
    return null;
  }

  /// Finds a single lesson by id inside its module file.
  /// Expects: `assets/json/lessons/<module>.json`
  static Future<Lesson?> loadById(String id) async {
    final module = _moduleFor(id);
    if (module == null) {
      logger.w('🕵️‍♂️ No module mapping for lesson id: $id');
      return null;
    }

    final path = 'assets/json/lessons/$module.json';
    try {
      logger.i('🔎 Lessons: searching $id in $path');
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> map = jsonDecode(raw);
      final List lessons = (map['lessons'] as List?) ?? const [];

      final match = lessons.cast<Map>().firstWhere(
        (e) => (e['id'] ?? '').toString() == id,
        orElse: () => const <String, dynamic>{},
      );
      if (match.isNotEmpty) {
        logger.i('📘 Lessons: found $id in $path');
        return Lesson.fromJson(Map<String, dynamic>.from(match));
      }
    } catch (e, st) {
      logger.w('❌ Lessons: failed to read $path → $e\n$st');
    }
    return null;
  }
}
