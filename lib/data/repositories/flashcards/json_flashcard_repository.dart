// lib/data/repositories/flashcards/json_flashcard_repository.dart
// lib/data/repositories/flashcards/json_flashcard_repository.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/utils/logger.dart';

/// JSON-backed flashcard discovery (filename-agnostic):
/// - Scans AssetManifest for JSON under:
///     • assets/json/tools/**
///     • assets/json/lessons/**
///     • assets/json/parts/**
/// - Extracts any embedded `flashcards` from:
///     • tools:   { "tools":   [ { ..., "flashcards":[...] }, ... ] }
///     • lessons: { "lessons": [ { ..., "flashcards":[...] }, ... ] }
///     • parts:   { "parts":   [ { ..., "flashcards":[...] }, ... ] }
///     • single-object top-level: { "flashcards":[...] }
/// - Groups by *category*:
///     • Prefer top-level "module" from the JSON (common in our files)
///     • Else, use the immediate folder name under the root directory
///     • Else, fall back to the file stem
/// - Public API:
///     • getAllCategories() → ["category-a", "category-b", ..., "all", "random"]
///     • getFlashcardsForCategory("category") → List`<Flashcard>`
///        (special: "all" returns all, "random" returns a small random sample)
///     • getFlashcardsByIds([...]) → List`<Flashcard>`
/// - Caches results in-memory; call invalidateIndex() to rebuild.
/// - Ignores obvious backup files (e.g., *.bak, *_deprecated.json, etc.).
class JsonFlashcardRepository {
  static const String _kToolsDir = 'assets/json/tools/';
  static const String _kLessonsDir = 'assets/json/lessons/';
  static const String _kPartsDir = 'assets/json/parts/';

  static const int _kRandomSampleDefault = 10;

  // Caches
  static bool _isIndexing = false;
  static Map<String, List<Flashcard>>?
  _categoryToCards; // category (lowercase) -> cards
  static Map<String, Flashcard>? _idToCard; // id -> card
  static Set<String>? _categories; // discovered categories (lowercase)
  static List<String>? _allFiles; // all JSON files we scanned

  /// Force a rebuild after asset changes (useful during authoring / hot restart).
  static void invalidateIndex() {
    _categoryToCards = null;
    _idToCard = null;
    _categories = null;
    _allFiles = null;
    _isIndexing = false;
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Discovery / Indexing
  // ────────────────────────────────────────────────────────────────────────────

  static Future<void> _ensureIndex() async {
    if ((_categoryToCards != null &&
            _idToCard != null &&
            _categories != null &&
            _allFiles != null) ||
        _isIndexing) {
      return;
    }
    _isIndexing = true;

    final categoryToCards = <String, List<Flashcard>>{};
    final idToCard = <String, Flashcard>{};
    final categories = <String>{};
    final files = <String>[];

    try {
      final manifestRaw = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

      // Collect all candidate JSON files under our three roots
      final jsonFiles =
          manifest.keys
              .where(
                (k) =>
                    (k.startsWith(_kToolsDir) ||
                        k.startsWith(_kLessonsDir) ||
                        k.startsWith(_kPartsDir)) &&
                    k.endsWith('.json') &&
                    !_looksLikeBackup(k),
              )
              .toList()
            ..sort();

      files.addAll(jsonFiles);

      for (final path in jsonFiles) {
        try {
          final raw = await rootBundle.loadString(path);
          final dynamic data = jsonDecode(raw);

          // Determine category
          final category = _inferCategory(path, data);
          if (category.isEmpty) {
            // No sensible category → skip but log
            logger.w('⚠️ Flashcard index: could not infer category for $path');
            continue;
          }

          // Extract flashcards from known containers
          final cards = _extractFlashcards(data);
          if (cards.isEmpty) continue;

          final lcCategory = category.toLowerCase();
          categories.add(lcCategory);

          final bucket = categoryToCards.putIfAbsent(
            lcCategory,
            () => <Flashcard>[],
          );

          for (final c in cards) {
            // First writer wins to avoid flicker; log duplicates
            if (!idToCard.containsKey(c.id)) {
              idToCard[c.id] = c;
              bucket.add(c);
            } else {
              logger.w(
                '⚠️ Duplicate flashcard id "${c.id}" encountered; keeping the first.',
              );
            }
          }
        } catch (e, st) {
          logger.w('❌ Flashcard index: failed to parse $path → $e\n$st');
        }
      }

      // Sort categories and cards for stable UI
      for (final entry in categoryToCards.entries) {
        entry.value.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      }

      _categoryToCards = categoryToCards;
      _idToCard = idToCard;
      _categories = categories;
      _allFiles = files;

      logger.i(
        '🃏 Flashcards indexed: ${idToCard.length} cards across ${categories.length} categories from ${files.length} files',
      );
    } catch (e, st) {
      logger.e('❌ Building flashcard index failed → $e\n$st');
      _categoryToCards = <String, List<Flashcard>>{};
      _idToCard = <String, Flashcard>{};
      _categories = <String>{};
      _allFiles = <String>[];
    } finally {
      _isIndexing = false;
    }
  }

  static bool _looksLikeBackup(String path) {
    final name = path.split('/').last.toLowerCase();
    // Ignore common backup/temporary patterns
    return name.contains('.bak') ||
        name.endsWith('~') ||
        name.startsWith('_') ||
        name.contains('deprecated') ||
        name.contains('backup') ||
        name.endsWith('.tmp') ||
        name.contains('.orig') ||
        name.contains('.old');
  }

  /// Prefer top-level "module" (nice human label) when available;
  /// else use immediate folder under the root; else fallback to file stem.
  static String _inferCategory(String path, dynamic data) {
    String? module;
    if (data is Map<String, dynamic>) {
      final m = data['module'];
      if (m is String && m.trim().isNotEmpty) {
        module = m.trim();
      }
    }
    if (module != null) return module;

    if (path.startsWith(_kToolsDir)) {
      // tools/<file>.json → "file"
      return _fileStem(path);
    }
    if (path.startsWith(_kLessonsDir)) {
      final folder = _immediateChildFolder(_kLessonsDir, path);
      return folder.isNotEmpty ? folder : _fileStem(path);
    }
    if (path.startsWith(_kPartsDir)) {
      final folder = _immediateChildFolder(_kPartsDir, path);
      return folder.isNotEmpty ? folder : _fileStem(path);
    }
    return '';
  }

  static String _fileStem(String path) {
    final file = path.split('/').last; // e.g., vhf.json
    return file.endsWith('.json') ? file.substring(0, file.length - 5) : file;
  }

  static String _immediateChildFolder(String root, String path) {
    // root: "assets/json/lessons/", path: "assets/json/lessons/safety/lesson_....json"
    if (!path.startsWith(root)) return '';
    final rest = path.substring(root.length); // e.g., "safety/lesson_....json"
    final idx = rest.indexOf('/');
    return idx > 0 ? rest.substring(0, idx) : '';
  }

  /// Extracts flashcards from the common container shapes.
  /// Delegates parsing of the card itself to Flashcard.fromJson.
  static List<Flashcard> _extractFlashcards(dynamic data) {
    final cards = <Flashcard>[];
    if (data is! Map<String, dynamic>) return cards;

    // Tools container
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
                } catch (e) {
                  // Ignore ill-formed cards in a batch; we'll log once per file in ensureIndex
                }
              }
            }
          }
        }
      }
    }

    // Lessons container
    final lessons = data['lessons'];
    if (lessons is List) {
      for (final l in lessons) {
        if (l is Map<String, dynamic>) {
          final fc = l['flashcards'];
          if (fc is List) {
            for (final j in fc) {
              if (j is Map<String, dynamic>) {
                try {
                  cards.add(Flashcard.fromJson(j));
                } catch (e) {
                  // ignore individual bad card
                }
              }
            }
          }
        }
      }
    }

    // Parts container
    final parts = data['parts'];
    if (parts is List) {
      for (final p in parts) {
        if (p is Map<String, dynamic>) {
          final fc = p['flashcards'];
          if (fc is List) {
            for (final j in fc) {
              if (j is Map<String, dynamic>) {
                try {
                  cards.add(Flashcard.fromJson(j));
                } catch (e) {
                  // ignore individual bad card
                }
              }
            }
          }
        }
      }
    }

    // Single-object top-level
    final top = data['flashcards'];
    if (top is List) {
      for (final j in top) {
        if (j is Map<String, dynamic>) {
          try {
            cards.add(Flashcard.fromJson(j));
          } catch (e) {
            // ignore individual bad card
          }
        }
      }
    }

    return cards;
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Public API
  // ────────────────────────────────────────────────────────────────────────────

  /// All discovered categories (lowercase), plus "all" and "random".
  static Future<List<String>> getAllCategories() async {
    await _ensureIndex();
    final base = (_categories ?? const {}).toList()..sort();
    // Ensure reserved items come last and aren’t duplicated by content names
    final filteredBase =
        base.where((c) => c != 'all' && c != 'random').toList();
    return [...filteredBase, 'all', 'random'];
  }

  /// Cards for a given category.
  /// Special:
  ///  - "all": returns every discovered card
  ///  - "random": returns a random sample (default 10)
  static Future<List<Flashcard>> getFlashcardsForCategory(
    String category, {
    int randomSampleSize = _kRandomSampleDefault,
  }) async {
    await _ensureIndex();
    final lc = category.toLowerCase();

    if (lc == 'all') {
      return _idToCard!.values.toList();
    }
    if (lc == 'random') {
      final all = _idToCard!.values.toList();
      if (all.isEmpty) return const <Flashcard>[];
      final rng = Random();
      // Simple reservoir-style sample without bias
      all.shuffle(rng);
      final n = randomSampleSize.clamp(1, all.length);
      return all.take(n).toList();
    }

    return _categoryToCards![lc] ?? const <Flashcard>[];
  }

  /// Cards by exact ids (order preserved as provided).
  static Future<List<Flashcard>> getFlashcardsByIds(List<String> ids) async {
    await _ensureIndex();
    final out = <Flashcard>[];
    for (final id in ids) {
      final c = _idToCard![id];
      if (c != null) out.add(c);
    }
    return out;
  }

  /// (Optional) Introspection helpers for debugging authoring issues.

  /// Returns the list of asset JSON files scanned the last time the index was built.
  static Future<List<String>> getIndexedFiles() async {
    await _ensureIndex();
    return List<String>.from(_allFiles ?? const <String>[]);
  }

  /// Returns a map of category -> number of cards (for quick sanity checks).
  static Future<Map<String, int>> getCategorySizes() async {
    await _ensureIndex();
    final out = <String, int>{};
    for (final e in _categoryToCards!.entries) {
      out[e.key] = e.value.length;
    }
    return out;
  }
}

// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:bcc5/data/models/flashcard_model.dart';
// import 'package:bcc5/utils/logger.dart';

// /// JSON-backed flashcard discovery:
// /// - Scans AssetManifest for JSON under assets/json/tools/**, assets/json/lessons/**, assets/json/parts/**
// /// - Extracts any embedded `flashcards` and groups them by category:
// ///     • Tools: category from top-level "module" (fallback: file stem)
// ///     • Lessons: category from folder name under lessons/ (e.g., safety, docking)
// ///     • Parts: category from folder or file stem under parts/
// /// - Provides: categories, by-category lists, and by-ids lookup.
// /// No hard-coded data. Editing/adding/removing JSON files updates the app automatically.
// class JsonFlashcardRepository {
//   static const _kToolsDir = 'assets/json/tools/';
//   static const _kLessonsDir = 'assets/json/lessons/';
//   static const _kPartsDir = 'assets/json/parts/';

//   // Caches
//   static bool _isIndexing = false;
//   static Map<String, List<Flashcard>>? _categoryToCards; // category -> cards
//   static Map<String, Flashcard>? _idToCard; // id -> card
//   static Set<String>? _categories; // discovered categories (lowercase)

//   /// Force a rebuild after asset changes (useful during authoring / hot restart).
//   static void invalidateIndex() {
//     _categoryToCards = null;
//     _idToCard = null;
//     _categories = null;
//     _isIndexing = false;
//   }

//   static Future<void> _ensureIndex() async {
//     if ((_categoryToCards != null &&
//             _idToCard != null &&
//             _categories != null) ||
//         _isIndexing) {
//       return;
//     }
//     _isIndexing = true;

//     final categoryToCards = <String, List<Flashcard>>{};
//     final idToCard = <String, Flashcard>{};
//     final categories = <String>{};

//     try {
//       final manifestRaw = await rootBundle.loadString('AssetManifest.json');
//       final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

//       // Collect all candidate JSON files
//       final jsonFiles =
//           manifest.keys
//               .where(
//                 (k) =>
//                     (k.startsWith(_kToolsDir) ||
//                         k.startsWith(_kLessonsDir) ||
//                         k.startsWith(_kPartsDir)) &&
//                     k.endsWith('.json'),
//               )
//               .toList()
//             ..sort();

//       for (final path in jsonFiles) {
//         try {
//           final raw = await rootBundle.loadString(path);
//           final data = jsonDecode(raw);

//           // Determine category based on location/metadata
//           final category = _inferCategory(path, data);
//           if (category.isEmpty) continue;

//           // Extract any flashcards from plausible containers
//           final cards = _extractFlashcards(data);
//           if (cards.isEmpty) continue;

//           categories.add(category);

//           final bucket = categoryToCards.putIfAbsent(
//             category,
//             () => <Flashcard>[],
//           );
//           for (final c in cards) {
//             // Deduplicate by id across files
//             if (!idToCard.containsKey(c.id)) {
//               idToCard[c.id] = c;
//               bucket.add(c);
//             }
//           }
//         } catch (e, st) {
//           logger.w('❌ Flashcard index: failed to parse $path → $e\n$st');
//         }
//       }

//       // Sort categories and (optionally) cards by title for stable UI
//       for (final entry in categoryToCards.entries) {
//         entry.value.sort(
//           (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
//         );
//       }

//       _categoryToCards = categoryToCards;
//       _idToCard = idToCard;
//       _categories = categories.map((e) => e.toLowerCase()).toSet();

//       logger.i(
//         '🃏 Flashcards indexed: ${idToCard.length} cards across ${categories.length} categories',
//       );
//     } catch (e, st) {
//       logger.e('❌ Building flashcard index failed → $e\n$st');
//       _categoryToCards = <String, List<Flashcard>>{};
//       _idToCard = <String, Flashcard>{};
//       _categories = <String>{};
//     } finally {
//       _isIndexing = false;
//     }
//   }

//   /// Public: all categories discovered, plus special "all" and "random" (to match legacy UX).
//   static Future<List<String>> getAllCategories() async {
//     await _ensureIndex();
//     final base = (_categories ?? const {}).toList()..sort();
//     return [...base, 'all', 'random'];
//   }

//   /// Public: list of cards for a given category.
//   /// Special cases:
//   ///  - "all": every discovered card
//   ///  - "random": a random small sample (e.g., 10)
//   static Future<List<Flashcard>> getFlashcardsForCategory(
//     String category,
//   ) async {
//     await _ensureIndex();
//     final lc = category.toLowerCase();

//     if (lc == 'all') {
//       return _idToCard!.values.toList();
//     }
//     if (lc == 'random') {
//       final all = _idToCard!.values.toList()..shuffle();
//       return all.take(10).toList();
//     }

//     return _categoryToCards![lc] ?? const <Flashcard>[];
//   }

//   /// Public: get cards by IDs (used by /flashcards/custom in router).
//   static Future<List<Flashcard>> getFlashcardsByIds(List<String> ids) async {
//     await _ensureIndex();
//     final out = <Flashcard>[];
//     for (final id in ids) {
//       final c = _idToCard![id];
//       if (c != null) out.add(c);
//     }
//     return out;
//   }

//   // ────────────────────────────────────────────────────────────────────────────
//   // Helpers
//   // ────────────────────────────────────────────────────────────────────────────

//   /// Infer a category for the file:
//   ///  - Tools: use top-level "module" if present; fallback to file stem
//   ///  - Lessons: use the immediate folder under assets/json/lessons/ (e.g., "safety")
//   ///  - Parts: use the immediate folder under assets/json/parts/ OR file stem
//   static String _inferCategory(String path, dynamic data) {
//     if (path.startsWith(_kToolsDir)) {
//       // Tools JSON shape like: {"module": "vhf", "tools": [ {..., "flashcards":[...] } ]}
//       final module =
//           (data is Map<String, dynamic>)
//               ? (data['module']?.toString() ?? '')
//               : '';
//       if (module.isNotEmpty) return module.toLowerCase();
//       return _fileStem(path).toLowerCase();
//     }

//     if (path.startsWith(_kLessonsDir)) {
//       // e.g., assets/json/lessons/safety/lesson_safe_4.00.json → "safety"
//       final folder = _immediateChildFolder(_kLessonsDir, path);
//       if (folder.isNotEmpty) return folder.toLowerCase();
//       return _fileStem(path).toLowerCase();
//     }

//     if (path.startsWith(_kPartsDir)) {
//       // Prefer folder name; fallback to file stem.
//       final folder = _immediateChildFolder(_kPartsDir, path);
//       if (folder.isNotEmpty) return folder.toLowerCase();
//       return _fileStem(path).toLowerCase();
//     }

//     return '';
//   }

//   static String _fileStem(String path) {
//     final file = path.split('/').last; // e.g., vhf.json
//     return file.endsWith('.json') ? file.substring(0, file.length - 5) : file;
//   }

//   static String _immediateChildFolder(String root, String path) {
//     // root: "assets/json/lessons/" ; path: "assets/json/lessons/safety/lesson_safe_4.00.json"
//     final rest = path.substring(root.length); // "safety/lesson_safe_4.00.json"
//     final idx = rest.indexOf('/');
//     return idx > 0 ? rest.substring(0, idx) : '';
//   }

//   /// Extracts flashcards from a variety of JSON shapes:
//   ///  - Tools: { "tools": [ { "flashcards": [...] }, ... ] }
//   ///  - Lessons: a single lesson object or a folder of lesson files, each with "flashcards"
//   ///  - Parts: similar to lessons, each item JSON may include "flashcards"
//   static List<Flashcard> _extractFlashcards(dynamic data) {
//     final cards = <Flashcard>[];

//     // Tools container
//     if (data is Map<String, dynamic>) {
//       // tools array
//       final tools = data['tools'];
//       if (tools is List) {
//         for (final t in tools) {
//           if (t is Map<String, dynamic>) {
//             final fc = t['flashcards'];
//             if (fc is List) {
//               for (final j in fc) {
//                 if (j is Map<String, dynamic>) {
//                   try {
//                     cards.add(Flashcard.fromJson(j));
//                   } catch (_) {}
//                 }
//               }
//             }
//           }
//         }
//       }

//       // lesson/part single-object shape
//       // (Some lesson/part JSON are individual files with "flashcards":[...])
//       final fc = data['flashcards'];
//       if (fc is List) {
//         for (final j in fc) {
//           if (j is Map<String, dynamic>) {
//             try {
//               cards.add(Flashcard.fromJson(j));
//             } catch (_) {}
//           }
//         }
//       }
//     }

//     return cards;
//   }
// }
