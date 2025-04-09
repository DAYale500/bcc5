import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';

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
    final sequenceIds = items.map((e) => e.pathItemId).toList();
    final renderItems = buildRenderItems(ids: sequenceIds);

    logger.i('🟩 Found chapter "${chapter.title}" with ${items.length} items');
    logger.i('🧪 Chapter title is: "${chapter.title}"');

    return Column(
      children: [
        CustomAppBarWidget(
          title: pathName.toTitleCase(),
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          onBack: () {
            logger.i(
              '🔙 Back tapped — returning to PathChapterScreen for "$pathName"',
            );
            context.go(
              '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}',
              extra: {
                'slideFrom': SlideDirection.left,
                'detailRoute': DetailRoute.path,
                'transitionType': TransitionType.slide, // ✅ Add this
              },
            );
          },
        ),

        const SizedBox(height: 16),
        Text(
          chapter.title,
          style: AppTheme.headingStyle.copyWith(
            fontSize: 20,
            color: AppTheme.primaryBlue, // or use a darker shade if needed
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Resume your voyage, or chart any path below.',
          style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryBlue),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),
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
                final id = pathItem.pathItemId;
                final title = renderItems[index].title;

                logger.i(
                  '📦 Rendering button for pathItem: $id — "$title" (index $index)',
                );

                return ItemButton(
                  label: title,
                  onTap: () {
                    logger.i('🟦 Tapped PathItem: $title (index $index)');

                    if (renderItems.isEmpty) {
                      logger.e('❌ renderItems is empty — navigation aborted');
                      return;
                    }

                    final timestamp = DateTime.now().millisecondsSinceEpoch;
                    final extra = {
                      'renderItems': renderItems,
                      'currentIndex': index,
                      'branchIndex': 0,
                      'backDestination':
                          '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                      'backExtra': {
                        'pathName': pathName,
                        'chapterId': chapterId,
                      },
                      'transitionKey': 'path_${id}_$timestamp',
                      'detailRoute': DetailRoute.path,
                      'slideFrom': SlideDirection.right,
                      'transitionType': TransitionType.slide, // ✅ NEW LINE
                    };

                    if (id.startsWith('lesson_')) {
                      logger.i('📘 Routing to LessonDetailScreen for $id');
                      context.push('/lessons/detail', extra: extra);
                    } else if (id.startsWith('part_')) {
                      logger.i('🧩 Routing to PartDetailScreen for $id');
                      context.push('/parts/detail', extra: extra);
                    } else if (id.startsWith('tool_')) {
                      logger.i('🛠️ Routing to ToolDetailScreen for $id');
                      context.push('/tools/detail', extra: extra);
                    } else if (id.startsWith('flashcard_')) {
                      logger.i('🃏 Routing to FlashcardDetailScreen for $id');
                      context.push('/flashcards/detail', extra: extra);
                    } else {
                      logger.e('❓ Unknown content type for ID: $id');
                    }
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
