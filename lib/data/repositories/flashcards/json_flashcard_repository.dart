// lib/data/repositories/flashcards/json_flashcard_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/utils/logger.dart';

/// JSON-backed flashcard discovery:
/// - Scans AssetManifest for JSON under assets/json/tools/**, assets/json/lessons/**, assets/json/parts/**
/// - Extracts any embedded `flashcards` and groups them by category:
///     • Tools: category from top-level "module" (fallback: file stem)
///     • Lessons: category from folder name under lessons/ (e.g., safety, docking)
///     • Parts: category from folder or file stem under parts/
/// - Provides: categories, by-category lists, and by-ids lookup.
/// No hard-coded data. Editing/adding/removing JSON files updates the app automatically.
class JsonFlashcardRepository {
  static const _kToolsDir = 'assets/json/tools/';
  static const _kLessonsDir = 'assets/json/lessons/';
  static const _kPartsDir = 'assets/json/parts/';

  // Caches
  static bool _isIndexing = false;
  static Map<String, List<Flashcard>>? _categoryToCards; // category -> cards
  static Map<String, Flashcard>? _idToCard; // id -> card
  static Set<String>? _categories; // discovered categories (lowercase)

  /// Force a rebuild after asset changes (useful during authoring / hot restart).
  static void invalidateIndex() {
    _categoryToCards = null;
    _idToCard = null;
    _categories = null;
    _isIndexing = false;
  }

  static Future<void> _ensureIndex() async {
    if ((_categoryToCards != null &&
            _idToCard != null &&
            _categories != null) ||
        _isIndexing) {
      return;
    }
    _isIndexing = true;

    final categoryToCards = <String, List<Flashcard>>{};
    final idToCard = <String, Flashcard>{};
    final categories = <String>{};

    try {
      final manifestRaw = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

      // Collect all candidate JSON files
      final jsonFiles =
          manifest.keys
              .where(
                (k) =>
                    (k.startsWith(_kToolsDir) ||
                        k.startsWith(_kLessonsDir) ||
                        k.startsWith(_kPartsDir)) &&
                    k.endsWith('.json'),
              )
              .toList()
            ..sort();

      for (final path in jsonFiles) {
        try {
          final raw = await rootBundle.loadString(path);
          final data = jsonDecode(raw);

          // Determine category based on location/metadata
          final category = _inferCategory(path, data);
          if (category.isEmpty) continue;

          // Extract any flashcards from plausible containers
          final cards = _extractFlashcards(data);
          if (cards.isEmpty) continue;

          categories.add(category);

          final bucket = categoryToCards.putIfAbsent(
            category,
            () => <Flashcard>[],
          );
          for (final c in cards) {
            // Deduplicate by id across files
            if (!idToCard.containsKey(c.id)) {
              idToCard[c.id] = c;
              bucket.add(c);
            }
          }
        } catch (e, st) {
          logger.w('❌ Flashcard index: failed to parse $path → $e\n$st');
        }
      }

      // Sort categories and (optionally) cards by title for stable UI
      for (final entry in categoryToCards.entries) {
        entry.value.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      }

      _categoryToCards = categoryToCards;
      _idToCard = idToCard;
      _categories = categories.map((e) => e.toLowerCase()).toSet();

      logger.i(
        '🃏 Flashcards indexed: ${idToCard.length} cards across ${categories.length} categories',
      );
    } catch (e, st) {
      logger.e('❌ Building flashcard index failed → $e\n$st');
      _categoryToCards = <String, List<Flashcard>>{};
      _idToCard = <String, Flashcard>{};
      _categories = <String>{};
    } finally {
      _isIndexing = false;
    }
  }

  /// Public: all categories discovered, plus special "all" and "random" (to match legacy UX).
  static Future<List<String>> getAllCategories() async {
    await _ensureIndex();
    final base = (_categories ?? const {}).toList()..sort();
    return [...base, 'all', 'random'];
  }

  /// Public: list of cards for a given category.
  /// Special cases:
  ///  - "all": every discovered card
  ///  - "random": a random small sample (e.g., 10)
  static Future<List<Flashcard>> getFlashcardsForCategory(
    String category,
  ) async {
    await _ensureIndex();
    final lc = category.toLowerCase();

    if (lc == 'all') {
      return _idToCard!.values.toList();
    }
    if (lc == 'random') {
      final all = _idToCard!.values.toList()..shuffle();
      return all.take(10).toList();
    }

    return _categoryToCards![lc] ?? const <Flashcard>[];
  }

  /// Public: get cards by IDs (used by /flashcards/custom in router).
  static Future<List<Flashcard>> getFlashcardsByIds(List<String> ids) async {
    await _ensureIndex();
    final out = <Flashcard>[];
    for (final id in ids) {
      final c = _idToCard![id];
      if (c != null) out.add(c);
    }
    return out;
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────────────────────────────────

  /// Infer a category for the file:
  ///  - Tools: use top-level "module" if present; fallback to file stem
  ///  - Lessons: use the immediate folder under assets/json/lessons/ (e.g., "safety")
  ///  - Parts: use the immediate folder under assets/json/parts/ OR file stem
  static String _inferCategory(String path, dynamic data) {
    if (path.startsWith(_kToolsDir)) {
      // Tools JSON shape like: {"module": "vhf", "tools": [ {..., "flashcards":[...] } ]}
      final module =
          (data is Map<String, dynamic>)
              ? (data['module']?.toString() ?? '')
              : '';
      if (module.isNotEmpty) return module.toLowerCase();
      return _fileStem(path).toLowerCase();
    }

    if (path.startsWith(_kLessonsDir)) {
      // e.g., assets/json/lessons/safety/lesson_safe_4.00.json → "safety"
      final folder = _immediateChildFolder(_kLessonsDir, path);
      if (folder.isNotEmpty) return folder.toLowerCase();
      return _fileStem(path).toLowerCase();
    }

    if (path.startsWith(_kPartsDir)) {
      // Prefer folder name; fallback to file stem.
      final folder = _immediateChildFolder(_kPartsDir, path);
      if (folder.isNotEmpty) return folder.toLowerCase();
      return _fileStem(path).toLowerCase();
    }

    return '';
  }

  static String _fileStem(String path) {
    final file = path.split('/').last; // e.g., vhf.json
    return file.endsWith('.json') ? file.substring(0, file.length - 5) : file;
  }

  static String _immediateChildFolder(String root, String path) {
    // root: "assets/json/lessons/" ; path: "assets/json/lessons/safety/lesson_safe_4.00.json"
    final rest = path.substring(root.length); // "safety/lesson_safe_4.00.json"
    final idx = rest.indexOf('/');
    return idx > 0 ? rest.substring(0, idx) : '';
  }

  /// Extracts flashcards from a variety of JSON shapes:
  ///  - Tools: { "tools": [ { "flashcards": [...] }, ... ] }
  ///  - Lessons: a single lesson object or a folder of lesson files, each with "flashcards"
  ///  - Parts: similar to lessons, each item JSON may include "flashcards"
  static List<Flashcard> _extractFlashcards(dynamic data) {
    final cards = <Flashcard>[];

    // Tools container
    if (data is Map<String, dynamic>) {
      // tools array
      final tools = data['tools'];
      if (tools is List) {
        for (final t in tools) {
          if (t is Map<String, dynamic>) {
            final fc = t['flashcards'];
            if (fc is List) {
              for (final j in fc) {
                if (j is Map<String, dynamic>) {
                  try {
                    cards.add(Flashcard.fromJson(j));
                  } catch (_) {}
                }
              }
            }
          }
        }
      }

      // lesson/part single-object shape
      // (Some lesson/part JSON are individual files with "flashcards":[...])
      final fc = data['flashcards'];
      if (fc is List) {
        for (final j in fc) {
          if (j is Map<String, dynamic>) {
            try {
              cards.add(Flashcard.fromJson(j));
            } catch (_) {}
          }
        }
      }
    }

    return cards;
  }
}
