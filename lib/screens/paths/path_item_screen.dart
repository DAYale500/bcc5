import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';

class PathItemScreen extends StatelessWidget {
  final String pathName;
  final String chapterId;

  const PathItemScreen({
    super.key,
    required this.pathName,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    logger.i(
      '📘 Building PathItemScreen for path "$pathName", chapter "$chapterId"',
    );

    final chapter = PathRepositoryIndex.getChapterById(pathName, chapterId);

    if (chapter == null) {
      logger.e(
        '❌ Could not find chapter for id: "$chapterId" in path: "$pathName"',
      );
      return const Center(child: Text('Chapter not found'));
    }

    final items = chapter.items;
    logger.i('🟩 Found chapter "${chapter.title}" with ${items.length} items');

    return Column(
      children: [
        CustomAppBarWidget(
          title: chapter.title,
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          onBack: () {
            logger.i(
              '🔙 Back tapped — returning to PathChapterScreen for "$pathName"',
            );
            context.go(
              '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}',
            );
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, index) {
                final pathItem = items[index];
                final label = pathItem.pathItemId;

                logger.i(
                  '📦 Rendering button for pathItem: $label (index $index)',
                );

                return ItemButton(
                  label: label,
                  onTap: () {
                    logger.i('🟦 Tapped PathItem: $label (index $index)');

                    final sequenceIds = items.map((e) => e.pathItemId).toList();

                    if (sequenceIds.isEmpty) {
                      logger.e('❌ sequenceIds is empty — navigation aborted');
                      return;
                    }

                    logger.i(
                      '🧭 Navigating to /content with sequenceIds: $sequenceIds, startIndex: $index',
                    );

                    context.push(
                      '/content',
                      extra: {
                        'sequenceIds': sequenceIds,
                        'startIndex': index,
                        'branchIndex': 0,
                        'backDestination':
                            '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                        'backExtra': {
                          'pathName': pathName,
                          'chapterId': chapterId,
                        },
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
