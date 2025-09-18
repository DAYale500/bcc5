// 📄 lib/widgets/search_modal.dart
// JSON-only search index by scanning AssetManifest.json

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

  // Build index by scanning AssetManifest.json for our JSON content files.
  Future<void> _buildSearchIndex() async {
    final results = <SearchResult>[];
    final seen = <String>{}; // dedupe key: "$id|$keyword|$type"

    try {
      final manifestRaw = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

      // Collect lesson/part/tool JSON asset paths
      final paths = manifest.keys.where((p) {
        final isJson = p.endsWith('.json');
        if (!isJson) return false;
        // Adjust prefixes if your structure differs
        final isLesson = p.contains('/json/lessons/');
        final isPart = p.contains('/json/parts/');
        final isTool = p.contains('/json/tools/');
        return isLesson || isPart || isTool;
      });

      for (final path in paths) {
        final type = _typeFromPath(path);
        if (type == null) continue;

        // Load each JSON and read id/title/keywords
        final raw = await rootBundle.loadString(path);
        final map = jsonDecode(raw) as Map<String, dynamic>;

        final id = (map['id'] as String?) ?? _idFromPath(path);
        if (id.isEmpty) continue;

        final title = (map['title'] as String? ?? _titleFromId(id)).trim();
        final kws =
            (map['keywords'] as List<dynamic>?)?.whereType<String>().toList() ??
            const <String>[];

        for (final kw in kws) {
          final k = kw.trim();
          if (k.isEmpty) continue;
          final deDupe = '$id|$k|${type.name}';
          if (seen.add(deDupe)) {
            results.add(
              SearchResult(id: id, keyword: k, displayTitle: title, type: type),
            );
          }
        }
      }
    } catch (_) {
      // Swallow and show empty results; you can add logging if desired.
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

  String _idFromPath(String path) {
    // e.g. assets/json/lessons/lesson_rules_of_road.json -> lesson_rules_of_road
    final file = path.split('/').last;
    return file.replaceAll('.json', '');
  }

  String _titleFromId(String id) {
    // Fallback title if JSON missing; turns "lesson_rules_of_road" -> "Lesson Rules Of Road"
    return id
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
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

    final detailRoute = switch (result.type) {
      RenderItemType.lesson => DetailRoute.branch,
      RenderItemType.part => DetailRoute.branch,
      RenderItemType.tool => DetailRoute.branch,
      RenderItemType.flashcard => DetailRoute.branch,
    };

    final extra = {
      'renderItems': renderItems,
      'currentIndex': 0,
      'branchIndex': 0,
      'backDestination': '/',
      'transitionKey':
          'search_${result.id}_${DateTime.now().millisecondsSinceEpoch}',
      'detailRoute': detailRoute,
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
                      separatorBuilder: (_, _) => const Divider(height: 1),
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

// import 'package:bcc5/navigation/detail_route.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:bcc5/data/models/render_item.dart';
// import 'package:bcc5/utils/render_item_helpers.dart';
// import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
// import 'package:bcc5/data/repositories/parts/part_repository_index.dart';

// // 🚫 No need to import flashcards until keyword support is added

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
//   late List<SearchResult> _allResults;
//   List<SearchResult> _filteredResults = [];

//   @override
//   void initState() {
//     super.initState();
//     _allResults = _buildSearchIndex();
//     _filteredResults = _allResults;
//   }

//   List<SearchResult> _buildSearchIndex() {
//     final results = <SearchResult>[];

//     for (final lesson in LessonRepositoryIndex.getAllLessons()) {
//       for (final keyword in lesson.keywords) {
//         results.add(
//           SearchResult(
//             id: lesson.id,
//             keyword: keyword,
//             displayTitle: lesson.title,
//             type: RenderItemType.lesson,
//           ),
//         );
//       }
//     }

//     for (final part in PartRepositoryIndex.getAllParts()) {
//       for (final keyword in part.keywords) {
//         results.add(
//           SearchResult(
//             id: part.id,
//             keyword: keyword,
//             displayTitle: part.title,
//             type: RenderItemType.part,
//           ),
//         );
//       }
//     }

//     return results;
//   }

//   // List<SearchResult> _buildSearchIndex() {
//   //   final results = <SearchResult>[];

//   //   for (final lesson in LessonRepositoryIndex.getAllLessons()) {
//   //     for (final keyword in lesson.keywords) {
//   //       results.add(
//   //         SearchResult(
//   //           id: lesson.id,
//   //           title: keyword,
//   //           type: RenderItemType.lesson,
//   //         ),
//   //       );
//   //     }
//   //   }

//   //   for (final part in PartRepositoryIndex.getAllParts()) {
//   //     for (final keyword in part.keywords) {
//   //       results.add(
//   //         SearchResult(id: part.id, title: keyword, type: RenderItemType.part),
//   //       );
//   //     }
//   //   }

//   //   // 🚧 Flashcard keywords not yet available in model
//   //   // Future-proof logic:
//   //   // for (final flashcard in FlashcardRepository.getAllFlashcards()) {
//   //   //   for (final keyword in flashcard.keywords ?? []) {
//   //   //     results.add(SearchResult(
//   //   //       id: flashcard.id,
//   //   //       title: keyword,
//   //   //       type: RenderItemType.flashcard,
//   //   //     ));
//   //   //   }
//   //   // }

//   //   return results;
//   // }

//   void _onSearchChanged(String query) {
//     setState(() {
//       _filteredResults =
//           _allResults
//               .where(
//                 (r) => r.keyword.toLowerCase().contains(query.toLowerCase()),
//               )
//               .toList();
//     });
//   }

//   Future<void> _navigateToResult(SearchResult result) async {
//     final renderItems = await buildRenderItems(ids: [result.id]);
//     final timestamp = DateTime.now().millisecondsSinceEpoch;

//     if (!mounted) return; // ✅ Dart-safe context use

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
//       'transitionKey': 'search_${result.id}_$timestamp',
//       'detailRoute': detailRoute, // ✅ Now safe for all routes
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
//             child: ListView.separated(
//               itemCount: _filteredResults.length,
//               separatorBuilder: (_, _) => const Divider(height: 1),
//               itemBuilder: (context, index) {
//                 final result = _filteredResults[index];
//                 return ListTile(
//                   title: Text(result.displayTitle),
//                   subtitle: Text(result.type.name),
//                   onTap: () => _navigateToResult(result),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
