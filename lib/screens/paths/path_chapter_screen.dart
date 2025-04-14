import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/utils/resume_manager.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/string_extensions.dart';

class PathChapterScreen extends StatefulWidget {
  final String pathName;
  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;

  const PathChapterScreen({
    super.key,
    required this.pathName,
    required this.mobKey,
    required this.settingsKey,
    required this.searchKey,
    required this.titleKey,
  });

  @override
  State<PathChapterScreen> createState() => _PathChapterScreenState();
}

class _PathChapterScreenState extends State<PathChapterScreen> {
  @override
  Widget build(BuildContext context) {
    final pathName = widget.pathName;
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
          mobKey: widget.mobKey,
          settingsKey: widget.settingsKey,
          searchKey: widget.searchKey,
          titleKey: widget.titleKey,
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
                    mobKey: widget.mobKey,
                    settingsKey: widget.settingsKey,
                    searchKey: widget.searchKey,
                    titleKey: widget.titleKey,
                  );
                },
                style: AppTheme.groupRedButtonStyle,
                child: const Text('Set sail on a new course'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () async {
                  logger.i('📍 Resume tapped for "$pathName"');
                  final resume = await ResumeManager.getResumePoint();

                  if (!context.mounted) return;

                  if (resume == null) {
                    logger.w('⚠️ No resume point found');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No saved location to resume.'),
                      ),
                    );
                    return;
                  }

                  final savedPath = resume['pathName'];
                  final chapterId = resume['chapterId'];
                  final itemId = resume['itemId'];

                  if (savedPath != pathName) {
                    logger.w(
                      '⚠️ Resume point belongs to different path: $savedPath',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No resume point for this path.'),
                      ),
                    );
                    return;
                  }

                  final chapter = PathRepositoryIndex.getChapterById(
                    pathName,
                    chapterId!,
                  );
                  if (chapter == null) {
                    logger.w('⚠️ Chapter not found for ID: $chapterId');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved chapter not found.')),
                    );
                    return;
                  }

                  final itemIndex = chapter.items.indexWhere(
                    (i) => i.pathItemId == itemId,
                  );
                  if (itemIndex == -1) {
                    logger.w(
                      '⚠️ Saved item $itemId not found in chapter $chapterId',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved item not found.')),
                    );
                    return;
                  }

                  final renderItems = buildRenderItems(
                    ids: chapter.items.map((e) => e.pathItemId).toList(),
                  );
                  final targetItem = renderItems[itemIndex];

                  TransitionManager.goToDetailScreen(
                    context: context,
                    screenType: targetItem.type,
                    renderItems: renderItems,
                    currentIndex: itemIndex,
                    branchIndex: 0,
                    backDestination:
                        '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                    backExtra: {
                      'pathName': pathName,
                      'chapterId': chapterId,
                      'mobKey': widget.mobKey,
                      'settingsKey': widget.settingsKey,
                      'searchKey': widget.searchKey,
                      'titleKey': widget.titleKey,
                    },
                    detailRoute: DetailRoute.path,
                    direction: SlideDirection.right,
                    mobKey: widget.mobKey,
                    settingsKey: widget.settingsKey,
                    searchKey: widget.searchKey,
                    titleKey: widget.titleKey,
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
