// ─────────────────────────────────────────────────────────────────────────────
// lib/widgets/navigation/path_ending_actions.dart
// JSON-only: build flashcard set from chapter.items via JsonPathRepository.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/data/repositories/paths/json_path_repository.dart';

class PathEndingActions extends StatelessWidget {
  final String pathName;
  final String chapterId;

  const PathEndingActions({
    super.key,
    required this.pathName,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final ids = await _flashcardIdsForChapter(pathName, chapterId);
            if (!context.mounted) return;

            if (ids.isNotEmpty) {
              context.push(
                '/flashcards/custom',
                extra: {
                  'flashcardIds': ids,
                  'pathName': pathName,
                  'chapterId': chapterId,
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No flashcards available for this chapter.'),
                ),
              );
            }
          },
          child: const Text('Test your knowledge'),
        ),
        ElevatedButton(
          onPressed: () {
            final nextPath = _getNextPathName(pathName);
            if (nextPath != null) {
              context.push(
                '/learning-paths/${nextPath.replaceAll(' ', '-').toLowerCase()}',
              );
            }
          },
          child: const Text('Start next Course Series'),
        ),
        TextButton(
          onPressed: () => context.go('/learning-paths'),
          child: const Text('Back to the Main Index'),
        ),
      ],
    );
  }

  // Collect flashcard IDs that appear in the chapter's items list.
  // We treat items as PathItem objects and use their `pathItemId` field.
  Future<List<String>> _flashcardIdsForChapter(
    String path,
    String chapter,
  ) async {
    final chapters = await JsonPathRepository.getChaptersForPath(path);
    final found = chapters.where((c) => c.id == chapter);
    if (found.isEmpty) return const [];

    final items = found.first.items; // List<PathItem>
    final ids = <String>[];
    for (final it in items) {
      final id = it.pathItemId;
      if (id.startsWith('flashcard_')) {
        ids.add(id);
      }
    }
    return ids;
  }

  // Keep simple linear progression hook for future multi-path support.
  String? _getNextPathName(String currentPath) {
    final paths = <String>[
      'competent crew',
      // Add future paths here if needed
    ];
    final i = paths.indexOf(currentPath.toLowerCase());
    if (i == -1 || i + 1 >= paths.length) return null;
    return paths[i + 1];
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:bcc5/data/repositories/flashcards/competent_crew_flashards.dart';

// class PathEndingActions extends StatelessWidget {
//   final String pathName;
//   final String chapterId;

//   const PathEndingActions({
//     super.key,
//     required this.pathName,
//     required this.chapterId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             final curated = curatedChapterFlashcards[chapterId];
//             if (curated != null && curated.isNotEmpty) {
//               context.push(
//                 '/flashcards/custom',
//                 extra: {
//                   'flashcardIds': curated,
//                   'pathName': pathName,
//                   'chapterId': chapterId,
//                 },
//               );
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('No flashcards available for this chapter.'),
//                 ),
//               );
//             }
//           },
//           child: const Text('Test your knowledge'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             final nextPath = _getNextPathName(pathName);
//             if (nextPath != null) {
//               context.push(
//                 '/learning-paths/${nextPath.replaceAll(' ', '-').toLowerCase()}',
//               );
//             }
//           },
//           child: const Text('Start next Course Series'),
//         ),
//         TextButton(
//           onPressed: () => context.go('/learning-paths'),
//           child: const Text('Back to the Main Index'),
//         ),
//       ],
//     );
//   }

//   String? _getNextPathName(String currentPath) {
//     final paths = [
//       'competent crew',
//       // Add future paths here if needed
//     ];
//     final currentIndex = paths.indexOf(currentPath.toLowerCase());
//     if (currentIndex == -1 || currentIndex + 1 >= paths.length) return null;
//     return paths[currentIndex + 1];
//   }
// }
