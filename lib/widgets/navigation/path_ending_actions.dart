import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/repositories/flashcards/competent_crew_flashards.dart';

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
          onPressed: () {
            final curated = curatedChapterFlashcards[chapterId];
            if (curated != null && curated.isNotEmpty) {
              context.push(
                '/flashcards/custom',
                extra: {
                  'flashcardIds': curated,
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

  String? _getNextPathName(String currentPath) {
    final paths = [
      'competent crew',
      // Add future paths here if needed
    ];
    final currentIndex = paths.indexOf(currentPath.toLowerCase());
    if (currentIndex == -1 || currentIndex + 1 >= paths.length) return null;
    return paths[currentIndex + 1];
  }
}
