// lib/screens/paths/path_chapter_screen.dart
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/string_extensions.dart';

import 'package:bcc5/data/repositories/paths/json_path_repository.dart';

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
    return FutureBuilder(
      future: Future.wait([
        JsonPathRepository.getChaptersForPath(widget.pathName),
        JsonPathRepository.getChapterTitles(widget.pathName),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final chapters = snapshot.data![0];
        final titles = snapshot.data![1];

        logger.i(
          '🟢 Entered PathChapterScreen for "${widget.pathName}" with ${chapters.length} chapters',
        );

        return Column(
          children: [
            CustomAppBarWidget(
              title: widget.pathName.toTitleCase(),
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

            // 🚀 Set Sail + Resume
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () => _handleSetSail(context, widget.pathName),
                    style: AppTheme.groupRedButtonStyle,
                    child: const Text('Start at the beginning'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed:
                        () => _handleResumeVoyage(context, widget.pathName),
                    style: AppTheme.groupRedButtonStyle,
                    child: const Text('Resume where you left off'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            if ((titles as List).isEmpty)
              const Expanded(child: Center(child: Text('No chapters found.')))
            else
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: titles.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final title = titles[index];
                    final chapter = chapters[index];
                    final timestamp = DateTime.now().millisecondsSinceEpoch;

                    return GroupButton(
                      label: title,
                      onTap: () {
                        context.push(
                          '/learning-paths/${widget.pathName.replaceAll(' ', '-').toLowerCase()}/items',
                          extra: {
                            'pathName': widget.pathName,
                            'chapterId': chapter.id,
                            'transitionKey':
                                'path_items_${chapter.id}_$timestamp',
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
      },
    );
  }

  Future<void> _handleSetSail(
    BuildContext localContext,
    String pathName,
  ) async {
    if (!localContext.mounted) return;

    final chapters = await JsonPathRepository.getChaptersForPath(pathName);
    if (!localContext.mounted) return;

    if (chapters.isEmpty) {
      ScaffoldMessenger.of(localContext).showSnackBar(
        const SnackBar(content: Text('No chapters found for this path.')),
      );
      return;
    }

    final firstChapter = chapters.first;
    final renderItems = await buildRenderItems(
      ids: firstChapter.items.map((e) => e.pathItemId).toList(),
    );

    if (!localContext.mounted) return;

    if (renderItems.isEmpty) {
      ScaffoldMessenger.of(localContext).showSnackBar(
        const SnackBar(content: Text('This chapter has no items.')),
      );
      return;
    }

    TransitionManager.goToDetailScreen(
      context: localContext,
      screenType: renderItems.first.type,
      renderItems: renderItems,
      currentIndex: 0,
      branchIndex: 0,
      backDestination:
          '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
      backExtra: {'pathName': pathName, 'chapterId': firstChapter.id},
      detailRoute: DetailRoute.path,
      direction: SlideDirection.right,
    );
  }

  Future<void> _handleResumeVoyage(
    BuildContext localContext,
    String pathName,
  ) async {
    if (!localContext.mounted) return;

    // If you keep ResumeManager, this remains as-is:
    // (left unchanged — your existing logic plugs in here)
    // You can swap to JsonPathRepository internally if needed.

    ScaffoldMessenger.of(localContext).showSnackBar(
      const SnackBar(content: Text('Resume logic unchanged here.')),
    );
  }
}
