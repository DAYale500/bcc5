// lib/data/repositories/parts/json_part_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/part_model.dart';

class JsonPartRepository {
  /// Auto-discovers part modules from the asset bundle.
  /// Looks for: `assets/json/parts/<module>.json`
  static Future<List<String>> getModuleNames() async {
    final manifestRaw = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

    final partModulePaths =
        manifest.keys
            .where(
              (k) => k.startsWith('assets/json/parts/') && k.endsWith('.json'),
            )
            .toList()
          ..sort();

    final modules = <String>{};
    for (final p in partModulePaths) {
      final fileName = p.split('/').last; // e.g., hull.json
      final module = fileName.substring(0, fileName.length - '.json'.length);
      modules.add(module);
    }

    final list = modules.toList()..sort();
    logger.i('🧩 Discovered part modules: ${list.join(', ')}');
    return list;
  }

  /// Returns lightweight rows for the module’s list UI: [{id, title}, ...]
  /// Expects: `assets/json/parts/<module>.json` with a top-level "parts": [...]
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

  static String? _moduleFor(String id) {
    if (id.startsWith('part_hull_')) return 'hull';
    if (id.startsWith('part_deck_')) return 'deck';
    if (id.startsWith('part_rigg_') || id.startsWith('part_rigging_')) {
      return 'rigging';
    }
    {}
    if (id.startsWith('part_sail_') || id.startsWith('part_sails_')) {
      return 'sails';
    }
    if (id.startsWith('part_intr_') || id.startsWith('part_interior_')) {
      return 'interior';
    }
    return null;
  }

  /// Look up a single part by id from `assets/json/parts/<module>.json`
  static Future<PartItem?> loadById(String id) async {
    final module = _moduleFor(id);
    if (module == null) {
      logger.w('🕵️‍♂️ No module mapping for part id: $id');
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
}
