// lib/data/repositories/tools/json_tool_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/tool_model.dart';

class JsonToolRepository {
  // Cache: tool id -> asset path (e.g. "tool_vhf_x" -> "assets/json/tools/vhf.json")
  static Map<String, String>? _idToPath;
  // Cache: all tool module files in the bundle
  static List<String>? _toolFiles;
  static bool _isIndexing = false;

  static Future<void> _ensureIndex() async {
    if ((_idToPath != null && _toolFiles != null) || _isIndexing) return;
    _isIndexing = true;
    try {
      final manifestRaw = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

      final files =
          manifest.keys
              .where(
                (k) =>
                    k.startsWith('assets/json/tools/') && k.endsWith('.json'),
              )
              .toList()
            ..sort();

      _toolFiles = files;

      final map = <String, String>{};
      for (final path in files) {
        try {
          final raw = await rootBundle.loadString(path);
          final data = jsonDecode(raw) as Map<String, dynamic>;
          final List tools = (data['tools'] as List?) ?? const [];
          for (final t in tools) {
            if (t is Map && t['id'] != null && t['id'].toString().isNotEmpty) {
              map[t['id'].toString()] = path;
            }
          }
        } catch (e, st) {
          logger.w('❌ Indexing tools: failed to read $path → $e\n$st');
        }
      }

      _idToPath = map;
      logger.i('🧰 Tool index: ${map.length} ids across ${files.length} files');
    } catch (e, st) {
      logger.e('❌ Building tool index failed → $e\n$st');
      _toolFiles = const [];
      _idToPath = const {};
    } finally {
      _isIndexing = false;
    }
  }

  /// Public: list module names discovered from assets (e.g. ["vhf", "communications", ...])
  static Future<List<String>> getModuleNames() async {
    await _ensureIndex();
    final modules = <String>{};
    for (final p in _toolFiles ?? const <String>[]) {
      final fileName = p.split('/').last; // e.g., vhf.json
      modules.add(fileName.substring(0, fileName.length - 5)); // strip ".json"
    }
    final list = modules.toList()..sort();
    logger.i('🧭 Tool modules: ${list.join(', ')}');
    return list;
  }

  /// Public: lightweight list for UI: [{id,title}, ...] for a given module.
  static Future<List<Map<String, String>>> getToolsForModule(
    String module,
  ) async {
    final path = 'assets/json/tools/$module.json';
    logger.i('📄 Loading tools list from: $path');
    try {
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> map = jsonDecode(raw);
      final List tools = (map['tools'] as List?) ?? const [];
      logger.i('✅ $module.json parsed → ${tools.length} tools');
      return tools
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

  /// Public: get the full ToolItem by id (works for any file dropped under assets/json/tools/)
  static Future<ToolItem?> loadById(String id) async {
    await _ensureIndex();
    final path = _idToPath?[id];
    if (path == null) {
      logger.w('🧩 Tool id not in index: $id');
      return null;
    }
    try {
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> map = jsonDecode(raw);
      final List tools = (map['tools'] as List?) ?? const [];
      final match = tools.cast<Map>().firstWhere(
        (e) => (e['id'] ?? '').toString() == id,
        orElse: () => const <String, dynamic>{},
      );
      if (match.isNotEmpty) {
        logger.i('📘 Tools: $id loaded from $path');
        return ToolItem.fromJson(Map<String, dynamic>.from(match));
      }
    } catch (e, st) {
      logger.w('❌ Tools: failed to parse $path for $id → $e\n$st');
    }
    return null;
  }

  /// If you need to force a rebuild after file changes without app restart.
  static void invalidateIndex() {
    _idToPath = null;
    _toolFiles = null;
  }
}
