// lib/data/repositories/paths/json_path_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/path_model.dart';

/// Loads learning paths from assets/json/paths/*.json
/// File schema:
/// {
///   "path": "competent crew",
///   "chapters": [
///     { "id": "...", "title": "...", "showFlashcardEnding": true,
///       "items": [ { "id": "lesson_xxx" }, { "id": "tool_yyy" } ] }
///   ]
/// }
class JsonPathRepository {
  static Map<String, List<LearningPathChapter>> _cache = {};
  static Map<String, dynamic>? _manifest;

  static Future<Map<String, dynamic>> _loadManifest() async {
    if (_manifest != null) return _manifest!;
    final raw = await rootBundle.loadString('AssetManifest.json');
    _manifest = jsonDecode(raw) as Map<String, dynamic>;
    return _manifest!;
  }

  static String _slug(String s, String sep) {
    return s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), sep);
  }

  static String _normalizeBase(String s) {
    // normalize filename base (no extension) for fuzzy matching
    return s.toLowerCase().replaceAll(RegExp(r'[_\-\s]'), '');
  }

  static Future<String?> _resolveAssetForPath(String pathName) async {
    final manifest = await _loadManifest();
    final keys = manifest.keys;

    final cand1 = 'assets/json/paths/${_slug(pathName, "_")}.json';
    final cand2 = 'assets/json/paths/${_slug(pathName, "-")}.json';
    if (keys.contains(cand1)) return cand1;
    if (keys.contains(cand2)) return cand2;

    // Fallback: fuzzy match by filename base
    final wanted = _normalizeBase(pathName);
    final candidates =
        keys
            .where(
              (k) => k.startsWith('assets/json/paths/') && k.endsWith('.json'),
            )
            .toList();
    for (final k in candidates) {
      final base = k.split('/').last.replaceAll('.json', '');
      if (_normalizeBase(base) == wanted) return k;
    }

    // Last resort: open each and check the "path" field
    for (final k in candidates) {
      try {
        final raw = await rootBundle.loadString(k);
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final p = (map['path'] ?? '').toString().toLowerCase().trim();
        if (p == pathName.toLowerCase().trim()) return k;
      } catch (_) {
        // ignore parse errors here; we'll log when actually loading
      }
    }

    return null;
  }

  /// Returns path keys discovered in assets/json/paths/*.json.
  /// The "key" is the value of the "path" field if present, else the filename base.
  static Future<List<String>> getPathKeys() async {
    final manifest = await _loadManifest();
    final keys =
        manifest.keys
            .where(
              (k) => k.startsWith('assets/json/paths/') && k.endsWith('.json'),
            )
            .toList()
          ..sort();

    final result = <String>[];
    for (final asset in keys) {
      try {
        final raw = await rootBundle.loadString(asset);
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final pathName = (map['path'] ?? '').toString().trim();
        if (pathName.isNotEmpty) {
          result.add(pathName);
        } else {
          // fall back to filename
          final base = asset.split('/').last.replaceAll('.json', '');
          result.add(base.replaceAll('_', ' ').replaceAll('-', ' '));
        }
      } catch (e, st) {
        logger.w('❌ Failed to read $asset → $e\n$st');
      }
    }
    return result..sort();
  }

  /// Load all chapters for a given path (by human name, e.g., "competent crew").
  static Future<List<LearningPathChapter>> getChaptersForPath(
    String pathName,
  ) async {
    final key = pathName.toLowerCase().trim();
    if (_cache.containsKey(key)) return _cache[key]!;

    final asset = await _resolveAssetForPath(pathName);
    if (asset == null) {
      logger.e('🧭 Path asset not found for "$pathName"');
      _cache[key] = const [];
      return const [];
    }

    try {
      final raw = await rootBundle.loadString(asset);
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final List chaptersJson = (map['chapters'] as List?) ?? const [];
      final chapters =
          chaptersJson.map<LearningPathChapter>((c) {
            final cid = (c['id'] ?? '').toString();
            final title = (c['title'] ?? '').toString();
            final show = (c['showFlashcardEnding'] as bool?) ?? true;
            final List itemsJson = (c['items'] as List?) ?? const [];
            final items =
                itemsJson.map<PathItem>((it) {
                  final id = (it['id'] ?? it['pathItemId'] ?? '').toString();
                  return PathItem(pathItemId: id);
                }).toList();
            return LearningPathChapter(
              id: cid,
              title: title,
              items: items,
              showFlashcardEnding: show,
            );
          }).toList();

      _cache[key] = chapters;
      logger.i(
        '📚 Loaded ${chapters.length} chapters for "$pathName" from $asset',
      );
      return chapters;
    } catch (e, st) {
      logger.e('❌ Failed to parse path file for "$pathName" → $e\n$st');
      _cache[key] = const [];
      return const [];
    }
  }

  static Future<List<String>> getChapterTitles(String pathName) async {
    final chapters = await getChaptersForPath(pathName);
    return chapters.map((c) => c.title).toList();
  }

  static Future<LearningPathChapter?> getChapterById(
    String pathName,
    String chapterId,
  ) async {
    final chapters = await getChaptersForPath(pathName);
    try {
      return chapters.firstWhere((c) => c.id == chapterId);
    } catch (_) {
      return null;
    }
  }

  static Future<String?> getChapterTitleForPath(
    String pathName,
    String chapterId,
  ) async {
    final chapter = await getChapterById(pathName, chapterId);
    return chapter?.title;
  }

  static Future<LearningPathChapter?> getNextChapter(
    String pathName,
    String currentChapterId,
  ) async {
    final chapters = await getChaptersForPath(pathName);
    for (var i = 0; i < chapters.length - 1; i++) {
      if (chapters[i].id == currentChapterId) {
        return chapters[i + 1];
      }
    }
    return null;
  }

  /// Optional: clear caches (e.g., during hot reload)
  static void clearCache() {
    _cache = {};
    _manifest = null;
  }
}
