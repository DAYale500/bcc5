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

  const PathChapterScreen({super.key, required this.pathName});

  @override
  State<PathChapterScreen> createState() => _PathChapterScreenState();
}

class _PathChapterScreenState extends State<PathChapterScreen> {
  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

  @override
  Widget build(BuildContext context) {
    final pathName = widget.pathName;
    final chapters = PathRepositoryIndex.getChaptersForPath(pathName);
    final titles = PathRepositoryIndex.getChapterTitles(pathName);

    logger.i(
      '🟢 Entered PathChapterScreen for "$pathName" with ${chapters.length} chapters',
    );

    return Column(
      children: [
        CustomAppBarWidget(
          title: pathName.toTitleCase(),
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          mobKey: mobKey,
          settingsKey: settingsKey,
          searchKey: searchKey,
          titleKey: titleKey,
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

        // 🚀 Set Sail and Resume
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (chapters.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No chapters found for this path.'),
                      ),
                    );
                    return;
                  }

                  final firstChapter = chapters.first;
                  final renderItems = buildRenderItems(
                    ids: firstChapter.items.map((e) => e.pathItemId).toList(),
                  );

                  if (renderItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This chapter has no items.'),
                      ),
                    );
                    return;
                  }

                  TransitionManager.goToDetailScreen(
                    context: context,
                    screenType: renderItems.first.type,
                    renderItems: renderItems,
                    currentIndex: 0,
                    branchIndex: 0,
                    backDestination:
                        '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                    backExtra: {
                      'pathName': pathName,
                      'chapterId': firstChapter.id,
                    },
                    detailRoute: DetailRoute.path,
                    direction: SlideDirection.right,
                  );
                },
                style: AppTheme.groupRedButtonStyle,
                child: const Text('Set sail on a new course'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final resume = await ResumeManager.getResumePoint();

                  if (!context.mounted ||
                      resume == null ||
                      resume['pathName'] != pathName) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No resume point for this path.'),
                        ),
                      );
                    }
                    return;
                  }

                  final chapter = PathRepositoryIndex.getChapterById(
                    pathName,
                    resume['chapterId']!,
                  );
                  if (!context.mounted) return;
                  if (chapter == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved chapter not found.')),
                    );
                    return;
                  }

                  final index = chapter.items.indexWhere(
                    (i) => i.pathItemId == resume['itemId'],
                  );
                  if (!context.mounted) return;
                  if (index == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved item not found.')),
                    );
                    return;
                  }

                  final renderItems = buildRenderItems(
                    ids: chapter.items.map((e) => e.pathItemId).toList(),
                  );

                  TransitionManager.goToDetailScreen(
                    context: context,
                    screenType: renderItems[index].type,
                    renderItems: renderItems,
                    currentIndex: index,
                    branchIndex: 0,
                    backDestination:
                        '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                    backExtra: {
                      'pathName': pathName,
                      'chapterId': resume['chapterId']!,
                    },
                    detailRoute: DetailRoute.path,
                    direction: SlideDirection.right,
                  );
                },
                style: AppTheme.groupRedButtonStyle,
                child: const Text('Resume your voyage'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // 🌊 Chapter List
        if (titles.isEmpty)
          const Expanded(child: Center(child: Text('No chapters found.')))
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: titles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final title = titles[index];
                final chapter = chapters[index];
                final timestamp = DateTime.now().millisecondsSinceEpoch;

                return GroupButton(
                  label: title,
                  onTap: () {
                    context.push(
                      '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                      extra: {
                        'pathName': pathName,
                        'chapterId': chapter.id,
                        'transitionKey': 'path_items_${chapter.id}_$timestamp',
                        'slideFrom': SlideDirection.right,
                        'transitionType': TransitionType.slide,
                        'detailRoute': DetailRoute.path,
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
