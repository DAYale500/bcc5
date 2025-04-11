import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/theme/app_theme.dart'; // ✅ Needed for AppTheme.primaryBlue
import 'package:bcc5/utils/string_extensions.dart'; // needed for title case

class PathChapterScreen extends StatelessWidget {
  final String pathName;

  const PathChapterScreen({super.key, required this.pathName});

  @override
  Widget build(BuildContext context) {
    logger.i('🟢 Entered PathChapterScreen for "$pathName"');

    final chapters = PathRepositoryIndex.getChaptersForPath(pathName);
    final titles = PathRepositoryIndex.getChapterTitles(pathName);
    logger.i('📚 Found ${titles.length} chapters for "$pathName"');

    return Column(
      children: [
        CustomAppBarWidget(
          title: pathName.toTitleCase(),
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          onBack: () {
            logger.i('🔙 Back tapped from PathChapterScreen');
            context.go(
              '/',
              extra: {
                'slideFrom': SlideDirection.left,
                'transitionType': TransitionType.slide,
                'detailRoute': DetailRoute.path,
              },
            );
          },
        ),

        const SizedBox(height: 20),

        // 🚀 Primary actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // this is the Start New Path button code
              ElevatedButton(
                onPressed: () {
                  logger.i('⛵ Set sail on a new course tapped → $pathName');

                  final chapters = PathRepositoryIndex.getChaptersForPath(
                    pathName,
                  );
                  if (chapters.isEmpty) {
                    logger.w('⚠️ No chapters found for path: $pathName');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No chapters found for this path.'),
                      ),
                    );
                    return;
                  }

                  final firstChapter = chapters.first;
                  final items = firstChapter.items;
                  if (items.isEmpty) {
                    logger.w('⚠️ First chapter has no items.');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This chapter has no items.'),
                      ),
                    );
                    return;
                  }

                  final renderItems = buildRenderItems(
                    ids: items.map((e) => e.pathItemId).toList(),
                  );
                  final item = renderItems.first;
                  final chapterId = firstChapter.id;

                  TransitionManager.goToDetailScreen(
                    context: context,
                    screenType: item.type,
                    renderItems: renderItems,
                    currentIndex: 0,
                    branchIndex: 0,
                    backDestination:
                        '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                    backExtra: {'pathName': pathName, 'chapterId': chapterId},
                    detailRoute: DetailRoute.path,
                    direction: SlideDirection.right,
                  );
                },

                // onPressed: () {
                //   logger.i('⛵ Set sail on a new course tapped → $pathName');
                //   final chapters = PathRepositoryIndex.getChaptersForPath(
                //     pathName,
                //   );
                //   if (chapters.isEmpty) {
                //     logger.w('⚠️ No chapters found for path: $pathName');
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text('No chapters found for this path.'),
                //       ),
                //     );
                //     return;
                //   }

                //   final firstChapter = chapters.first;
                //   final items = firstChapter.items;
                //   if (items.isEmpty) {
                //     logger.w('⚠️ First chapter has no items.');
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text('This chapter has no items.'),
                //       ),
                //     );
                //     return;
                //   }

                //   final renderItems = buildRenderItems(
                //     ids: items.map((e) => e.pathItemId).toList(),
                //   );
                //   final item = renderItems.first;

                //   TransitionManager.goToDetailScreen(
                //     context: context,
                //     screenType: item.type,
                //     renderItems: renderItems,
                //     currentIndex: 0,
                //     branchIndex: 0,
                //     backDestination:
                //         '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}',
                //     backExtra: {'pathName': pathName},
                //     detailRoute: DetailRoute.path,
                //     direction: SlideDirection.right,
                //   );
                // },
                style: AppTheme.groupRedButtonStyle,
                child: const Text('Set sail on a new course'),
              ),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '📍 This will resume where you last left off.',
                      ),
                    ),
                  );
                },
                style: AppTheme.groupRedButtonStyle,
                child: const Text('Resume your voyage'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // 🌊 Secondary instruction
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or Explore these courses:',
            style: AppTheme.subheadingStyle.copyWith(
              color: AppTheme.primaryBlue,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        // 📚 Chapter list
        Expanded(
          child:
              titles.isEmpty
                  ? const Center(child: Text('No chapters found.'))
                  : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: titles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index >= chapters.length) {
                        logger.w(
                          '⚠️ Index $index out of range for chapters in "$pathName"',
                        );
                        return const SizedBox.shrink();
                      }

                      final title = titles[index];
                      final chapter = chapters[index];

                      return GroupButton(
                        label: title,
                        onTap: () {
                          logger.i('📗 Tapped Chapter: $title (${chapter.id})');
                          final timestamp =
                              DateTime.now().millisecondsSinceEpoch;
                          context.push(
                            '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                            extra: {
                              'pathName': pathName,
                              'chapterId': chapter.id,
                              'transitionKey':
                                  'path_items_${chapter.id}_$timestamp',
                              'slideFrom': SlideDirection.right,
                              'detailRoute': DetailRoute.path,
                              'transitionType': TransitionType.slide,
                            },
                          );
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
