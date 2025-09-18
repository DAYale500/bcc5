// 📄 lib/widgets/search_modal.dart
// JSON-only search index by scanning AssetManifest.json
// - Supports single-item JSONs (lessons, parts, tools)
// - Supports module JSONs with "tools": [ { id,title,keywords/tags,... }, ... ]
// - Keywords from "keywords" or "tags" (List<String>); falls back to title
// - No legacy indices; drop-in new JSONs and they are discoverable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/navigation/detail_route.dart';

class SearchResult {
  final String id;
  final String keyword;
  final String displayTitle;
  final RenderItemType type;

  SearchResult({
    required this.id,
    required this.keyword,
    required this.displayTitle,
    required this.type,
  });
}

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _controller = TextEditingController();

  List<SearchResult> _allResults = const [];
  List<SearchResult> _filteredResults = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _buildSearchIndex(); // async JSON scan
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Build index by scanning AssetManifest.json for our JSON content files.
  Future<void> _buildSearchIndex() async {
    final results = <SearchResult>[];
    final seen = <String>{}; // dedupe key: "$id|$keyword|$type"

    try {
      final manifestRaw = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

      // Collect lesson/part/tool JSON asset paths
      final paths = manifest.keys.where((p) {
        if (!p.endsWith('.json')) return false;
        return p.contains('/json/lessons/') ||
            p.contains('/json/parts/') ||
            p.contains('/json/tools/');
      });

      for (final path in paths) {
        final type = _typeFromPath(path);
        if (type == null) continue;

        final raw = await rootBundle.loadString(path);
        final decoded = jsonDecode(raw);

        // Tools can be "module" JSONs with an array of items at "tools".
        if (type == RenderItemType.tool &&
            decoded is Map<String, dynamic> &&
            decoded['tools'] is List) {
          final List list = decoded['tools'] as List;
          for (final item in list) {
            if (item is! Map<String, dynamic>) continue;
            final id = _idFromMapOrPath(item, path);
            if (id.isEmpty) continue;

            final title = _titleFromMapOrId(item, id);
            final kws = _keywordsFromMap(item);
            for (final kw in kws) {
              final k = kw.trim();
              if (k.isEmpty) continue;
              final key = '$id|$k|${type.name}';
              if (seen.add(key)) {
                results.add(
                  SearchResult(
                    id: id,
                    keyword: k,
                    displayTitle: title,
                    type: type,
                  ),
                );
              }
            }
          }
        } else {
          // Single-item JSON (lessons, parts, or single tool file)
          final Map<String, dynamic>? map =
              decoded is Map<String, dynamic> ? decoded : null;
          if (map == null) continue;

          final id = _idFromMapOrPath(map, path);
          if (id.isEmpty) continue;

          final title = _titleFromMapOrId(map, id);
          final kws = _keywordsFromMap(map);

          for (final kw in kws) {
            final k = kw.trim();
            if (k.isEmpty) continue;
            final key = '$id|$k|${type.name}';
            if (seen.add(key)) {
              results.add(
                SearchResult(
                  id: id,
                  keyword: k,
                  displayTitle: title,
                  type: type,
                ),
              );
            }
          }
        }
      }
    } catch (_) {
      // Swallow and show empty results; add logging if you want.
    }

    if (!mounted) return;
    setState(() {
      _allResults = results;
      _filteredResults = results;
      _loading = false;
    });
  }

  RenderItemType? _typeFromPath(String path) {
    if (path.contains('/json/lessons/')) return RenderItemType.lesson;
    if (path.contains('/json/parts/')) return RenderItemType.part;
    if (path.contains('/json/tools/')) return RenderItemType.tool;
    return null;
  }

  // Prefer explicit "id" from the JSON; otherwise derive from filename.
  String _idFromMapOrPath(Map<String, dynamic> map, String path) {
    final raw = map['id'];
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    return _idFromPath(path);
  }

  // e.g. assets/json/lessons/lesson_rules_of_road.json -> lesson_rules_of_road
  String _idFromPath(String path) {
    final file = path.split('/').last;
    return file.replaceAll('.json', '');
  }

  String _titleFromMapOrId(Map<String, dynamic> map, String fallbackId) {
    final t = map['title'];
    if (t is String && t.trim().isNotEmpty) return t.trim();
    return _titleFromId(fallbackId);
  }

  // "lesson_rules_of_road" -> "Lesson Rules Of Road"
  String _titleFromId(String id) {
    return id
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  // Accept keywords from "keywords" or "tags" (both List<String>).
  // Fallback to [title] if neither is present.
  List<String> _keywordsFromMap(Map<String, dynamic> map) {
    List<String> coerceList(dynamic v) {
      if (v is List) {
        return v
            .map((e) => e is String ? e : e?.toString() ?? '')
            .where((s) => s.trim().isNotEmpty)
            .toList();
      }
      return const <String>[];
    }

    final kws = coerceList(map['keywords']);
    if (kws.isNotEmpty) return kws;

    final tags = coerceList(map['tags']);
    if (tags.isNotEmpty) return tags;

    final title = map['title'];
    return title is String && title.trim().isNotEmpty ? [title.trim()] : [];
  }

  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filteredResults = _allResults);
      return;
    }
    setState(() {
      _filteredResults =
          _allResults
              .where((r) => r.keyword.toLowerCase().contains(q))
              .toList();
    });
  }

  Future<void> _navigateToResult(SearchResult result) async {
    final renderItems = await buildRenderItems(ids: [result.id]);
    if (!mounted) return;

    final extra = {
      'renderItems': renderItems,
      'currentIndex': 0,
      'branchIndex': 0,
      'backDestination': '/',
      'transitionKey':
          'search_${result.id}_${DateTime.now().millisecondsSinceEpoch}',
      'detailRoute': DetailRoute.branch,
    };

    switch (result.type) {
      case RenderItemType.lesson:
        context.go('/lessons/detail', extra: extra);
        break;
      case RenderItemType.part:
        context.go('/parts/detail', extra: extra);
        break;
      case RenderItemType.tool:
        context.go('/tools/detail', extra: extra);
        break;
      case RenderItemType.flashcard:
        // Not indexed (flashcards are owned by lessons/parts/tools)
        context.go('/flashcards/detail', extra: extra);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child:
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredResults.isEmpty
                    ? const Center(child: Text('No matches'))
                    : ListView.separated(
                      itemCount: _filteredResults.length,
                      separatorBuilder:
                          (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final r = _filteredResults[index];
                        return ListTile(
                          title: Text(r.displayTitle),
                          subtitle: Text('${r.type.name} • ${r.keyword}'),
                          onTap: () => _navigateToResult(r),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

// // 📄 lib/widgets/search_modal.dart
// // JSON-only search index by scanning AssetManifest.json

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:go_router/go_router.dart';

// import 'package:bcc5/data/models/render_item.dart';
// import 'package:bcc5/utils/render_item_helpers.dart';
// import 'package:bcc5/navigation/detail_route.dart';

// class SearchResult {
//   final String id;
//   final String keyword;
//   final String displayTitle;
//   final RenderItemType type;

//   SearchResult({
//     required this.id,
//     required this.keyword,
//     required this.displayTitle,
//     required this.type,
//   });
// }

// class SearchModal extends StatefulWidget {
//   const SearchModal({super.key});

//   @override
//   State<SearchModal> createState() => _SearchModalState();
// }

// class _SearchModalState extends State<SearchModal> {
//   final TextEditingController _controller = TextEditingController();

//   List<SearchResult> _allResults = const [];
//   List<SearchResult> _filteredResults = const [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _buildSearchIndex(); // async JSON scan
//   }

//   // Build index by scanning AssetManifest.json for our JSON content files.
//   Future<void> _buildSearchIndex() async {
//     final results = <SearchResult>[];
//     final seen = <String>{}; // dedupe key: "$id|$keyword|$type"

//     try {
//       final manifestRaw = await rootBundle.loadString('AssetManifest.json');
//       final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

//       // Collect lesson/part/tool JSON asset paths
//       final paths = manifest.keys.where((p) {
//         final isJson = p.endsWith('.json');
//         if (!isJson) return false;
//         // Adjust prefixes if your structure differs
//         final isLesson = p.contains('/json/lessons/');
//         final isPart = p.contains('/json/parts/');
//         final isTool = p.contains('/json/tools/');
//         return isLesson || isPart || isTool;
//       });

//       for (final path in paths) {
//         final type = _typeFromPath(path);
//         if (type == null) continue;

//         // Load each JSON and read id/title/keywords
//         final raw = await rootBundle.loadString(path);
//         final map = jsonDecode(raw) as Map<String, dynamic>;

//         final id = (map['id'] as String?) ?? _idFromPath(path);
//         if (id.isEmpty) continue;

//         final title = (map['title'] as String? ?? _titleFromId(id)).trim();
//         final kws =
//             (map['keywords'] as List<dynamic>?)?.whereType<String>().toList() ??
//             const <String>[];

//         for (final kw in kws) {
//           final k = kw.trim();
//           if (k.isEmpty) continue;
//           final deDupe = '$id|$k|${type.name}';
//           if (seen.add(deDupe)) {
//             results.add(
//               SearchResult(id: id, keyword: k, displayTitle: title, type: type),
//             );
//           }
//         }
//       }
//     } catch (_) {
//       // Swallow and show empty results; you can add logging if desired.
//     }

//     if (!mounted) return;
//     setState(() {
//       _allResults = results;
//       _filteredResults = results;
//       _loading = false;
//     });
//   }

//   RenderItemType? _typeFromPath(String path) {
//     if (path.contains('/json/lessons/')) return RenderItemType.lesson;
//     if (path.contains('/json/parts/')) return RenderItemType.part;
//     if (path.contains('/json/tools/')) return RenderItemType.tool;
//     return null;
//   }

//   String _idFromPath(String path) {
//     // e.g. assets/json/lessons/lesson_rules_of_road.json -> lesson_rules_of_road
//     final file = path.split('/').last;
//     return file.replaceAll('.json', '');
//   }

//   String _titleFromId(String id) {
//     // Fallback title if JSON missing; turns "lesson_rules_of_road" -> "Lesson Rules Of Road"
//     return id
//         .replaceAll('_', ' ')
//         .replaceAll('-', ' ')
//         .split(' ')
//         .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
//         .join(' ');
//   }

//   void _onSearchChanged(String query) {
//     final q = query.trim().toLowerCase();
//     if (q.isEmpty) {
//       setState(() => _filteredResults = _allResults);
//       return;
//     }
//     setState(() {
//       _filteredResults =
//           _allResults
//               .where((r) => r.keyword.toLowerCase().contains(q))
//               .toList();
//     });
//   }

//   Future<void> _navigateToResult(SearchResult result) async {
//     final renderItems = await buildRenderItems(ids: [result.id]);
//     if (!mounted) return;

//     final detailRoute = switch (result.type) {
//       RenderItemType.lesson => DetailRoute.branch,
//       RenderItemType.part => DetailRoute.branch,
//       RenderItemType.tool => DetailRoute.branch,
//       RenderItemType.flashcard => DetailRoute.branch,
//     };

//     final extra = {
//       'renderItems': renderItems,
//       'currentIndex': 0,
//       'branchIndex': 0,
//       'backDestination': '/',
//       'transitionKey':
//           'search_${result.id}_${DateTime.now().millisecondsSinceEpoch}',
//       'detailRoute': detailRoute,
//     };

//     switch (result.type) {
//       case RenderItemType.lesson:
//         context.go('/lessons/detail', extra: extra);
//         break;
//       case RenderItemType.part:
//         context.go('/parts/detail', extra: extra);
//         break;
//       case RenderItemType.tool:
//         context.go('/tools/detail', extra: extra);
//         break;
//       case RenderItemType.flashcard:
//         context.go('/flashcards/detail', extra: extra);
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _controller,
//               onChanged: _onSearchChanged,
//               decoration: const InputDecoration(
//                 labelText: 'Search...',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           Expanded(
//             child:
//                 _loading
//                     ? const Center(child: CircularProgressIndicator())
//                     : _filteredResults.isEmpty
//                     ? const Center(child: Text('No matches'))
//                     : ListView.separated(
//                       itemCount: _filteredResults.length,
//                       separatorBuilder: (_, _) => const Divider(height: 1),
//                       itemBuilder: (context, index) {
//                         final r = _filteredResults[index];
//                         return ListTile(
//                           title: Text(r.displayTitle),
//                           subtitle: Text('${r.type.name} • ${r.keyword}'),
//                           onTap: () => _navigateToResult(r),
//                         );
//                       },
//                     ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // // 📄 lib/widgets/search_modal.dart

// // import 'package:bcc5/navigation/detail_route.dart';
// // import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:bcc5/data/models/render_item.dart';
// // import 'package:bcc5/utils/render_item_helpers.dart';
// // import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
// // import 'package:bcc5/data/repositories/parts/part_repository_index.dart';

// // // 🚫 No need to import flashcards until keyword support is added

// // class SearchResult {
// //   final String id;
// //   final String keyword;
// //   final String displayTitle;
// //   final RenderItemType type;

// //   SearchResult({
// //     required this.id,
// //     required this.keyword,
// //     required this.displayTitle,
// //     required this.type,
// //   });
// // }

// // class SearchModal extends StatefulWidget {
// //   const SearchModal({super.key});

// //   @override
// //   State<SearchModal> createState() => _SearchModalState();
// // }

// // class _SearchModalState extends State<SearchModal> {
// //   final TextEditingController _controller = TextEditingController();
// //   late List<SearchResult> _allResults;
// //   List<SearchResult> _filteredResults = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _allResults = _buildSearchIndex();
// //     _filteredResults = _allResults;
// //   }

// //   List<SearchResult> _buildSearchIndex() {
// //     final results = <SearchResult>[];

// //     for (final lesson in LessonRepositoryIndex.getAllLessons()) {
// //       for (final keyword in lesson.keywords) {
// //         results.add(
// //           SearchResult(
// //             id: lesson.id,
// //             keyword: keyword,
// //             displayTitle: lesson.title,
// //             type: RenderItemType.lesson,
// //           ),
// //         );
// //       }
// //     }

// //     for (final part in PartRepositoryIndex.getAllParts()) {
// //       for (final keyword in part.keywords) {
// //         results.add(
// //           SearchResult(
// //             id: part.id,
// //             keyword: keyword,
// //             displayTitle: part.title,
// //             type: RenderItemType.part,
// //           ),
// //         );
// //       }
// //     }

// //     return results;
// //   }

// //   // List<SearchResult> _buildSearchIndex() {
// //   //   final results = <SearchResult>[];

// //   //   for (final lesson in LessonRepositoryIndex.getAllLessons()) {
// //   //     for (final keyword in lesson.keywords) {
// //   //       results.add(
// //   //         SearchResult(
// //   //           id: lesson.id,
// //   //           title: keyword,
// //   //           type: RenderItemType.lesson,
// //   //         ),
// //   //       );
// //   //     }
// //   //   }

// //   //   for (final part in PartRepositoryIndex.getAllParts()) {
// //   //     for (final keyword in part.keywords) {
// //   //       results.add(
// //   //         SearchResult(id: part.id, title: keyword, type: RenderItemType.part),
// //   //       );
// //   //     }
// //   //   }

// //   //   // 🚧 Flashcard keywords not yet available in model
// //   //   // Future-proof logic:
// //   //   // for (final flashcard in FlashcardRepository.getAllFlashcards()) {
// //   //   //   for (final keyword in flashcard.keywords ?? []) {
// //   //   //     results.add(SearchResult(
// //   //   //       id: flashcard.id,
// //   //   //       title: keyword,
// //   //   //       type: RenderItemType.flashcard,
// //   //   //     ));
// //   //   //   }
// //   //   // }

// //   //   return results;
// //   // }

// //   void _onSearchChanged(String query) {
// //     setState(() {
// //       _filteredResults =
// //           _allResults
// //               .where(
// //                 (r) => r.keyword.toLowerCase().contains(query.toLowerCase()),
// //               )
// //               .toList();
// //     });
// //   }

// //   Future<void> _navigateToResult(SearchResult result) async {
// //     final renderItems = await buildRenderItems(ids: [result.id]);
// //     final timestamp = DateTime.now().millisecondsSinceEpoch;

// //     if (!mounted) return; // ✅ Dart-safe context use

// //     final detailRoute = switch (result.type) {
// //       RenderItemType.lesson => DetailRoute.branch,
// //       RenderItemType.part => DetailRoute.branch,
// //       RenderItemType.tool => DetailRoute.branch,
// //       RenderItemType.flashcard => DetailRoute.branch,
// //     };

// //     final extra = {
// //       'renderItems': renderItems,
// //       'currentIndex': 0,
// //       'branchIndex': 0,
// //       'backDestination': '/',
// //       'transitionKey': 'search_${result.id}_$timestamp',
// //       'detailRoute': detailRoute, // ✅ Now safe for all routes
// //     };

// //     switch (result.type) {
// //       case RenderItemType.lesson:
// //         context.go('/lessons/detail', extra: extra);
// //         break;
// //       case RenderItemType.part:
// //         context.go('/parts/detail', extra: extra);
// //         break;
// //       case RenderItemType.tool:
// //         context.go('/tools/detail', extra: extra);
// //         break;
// //       case RenderItemType.flashcard:
// //         context.go('/flashcards/detail', extra: extra);
// //         break;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Dialog(
// //       backgroundColor: Colors.white,
// //       child: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: TextField(
// //               controller: _controller,
// //               onChanged: _onSearchChanged,
// //               decoration: const InputDecoration(
// //                 labelText: 'Search...',
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             child: ListView.separated(
// //               itemCount: _filteredResults.length,
// //               separatorBuilder: (_, _) => const Divider(height: 1),
// //               itemBuilder: (context, index) {
// //                 final result = _filteredResults[index];
// //                 return ListTile(
// //                   title: Text(result.displayTitle),
// //                   subtitle: Text(result.type.name),
// //                   onTap: () => _navigateToResult(result),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
