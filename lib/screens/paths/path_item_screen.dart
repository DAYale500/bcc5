// 📄 lib/screens/paths/path_item_screen.dart

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/navigation/path_ending_actions.dart'; // NEW

class PathItemScreen extends StatefulWidget {
  final String pathName;
  final String chapterId;

  const PathItemScreen({
    super.key,
    required this.pathName,
    required this.chapterId,
  });

  @override
  State<PathItemScreen> createState() => _PathItemScreenState();
}

class _PathItemScreenState extends State<PathItemScreen> {
  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

  @override
  Widget build(BuildContext context) {
    final chapter = PathRepositoryIndex.getChapterById(
      widget.pathName,
      widget.chapterId,
    );

    if (chapter == null) {
      logger.e(
        '❌ Could not find chapter for id: "${widget.chapterId}" in path: "${widget.pathName}"',
      );
      return const Center(child: Text('Chapter not found'));
    }

    final sequenceIds = chapter.items.map((e) => e.pathItemId).toList();

    return FutureBuilder<List<RenderItem>>(
      future: buildRenderItems(ids: sequenceIds),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final renderItems = snapshot.data!;
        final isFinalChapter = _isLastChapter(
          widget.chapterId,
          widget.pathName,
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
                logger.i('🔙 Returning to PathChapterScreen');
                context.go(
                  '/learning-paths/${widget.pathName.replaceAll(' ', '-').toLowerCase()}',
                  extra: {
                    'slideFrom': SlideDirection.left,
                    'transitionType': TransitionType.slide,
                    'detailRoute': DetailRoute.path,
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              chapter.title,
              style: AppTheme.headingStyle.copyWith(
                fontSize: 20,
                color: AppTheme.primaryBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Select a starting point',
              style: AppTheme.subheadingStyle.copyWith(
                color: AppTheme.primaryBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: renderItems.length,
                  itemBuilder: (context, index) {
                    final renderItem = renderItems[index];
                    final title = renderItem.title;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ItemButton(
                        label: title,
                        onTap: () {
                          logger.i('🟦 Tapped PathItem → $title');

                          TransitionManager.goToDetailScreen(
                            context: context,
                            screenType: renderItem.type,
                            renderItems: renderItems,
                            currentIndex: index,
                            branchIndex: 0,
                            backDestination:
                                '/learning-paths/${widget.pathName.replaceAll(' ', '-').toLowerCase()}/items',
                            backExtra: {
                              'pathName': widget.pathName,
                              'chapterId': widget.chapterId,
                            },
                            detailRoute: DetailRoute.path,
                            direction: SlideDirection.right,
                            transitionType: TransitionType.slide,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            if (chapter.showFlashcardEnding && isFinalChapter)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PathEndingActions(
                  pathName: widget.pathName,
                  chapterId: widget.chapterId,
                ),
              ),
          ],
        );
      },
    );
  }

  bool _isLastChapter(String chapterId, String pathName) {
    final chapters = PathRepositoryIndex.getChaptersForPath(pathName);
    return chapters.isNotEmpty && chapters.last.id == chapterId;
  }

  // String? _getNextPathName(String currentPath) {
  //   final allPaths = PathRepositoryIndex.getPathNames();
  //   final currentIndex = allPaths.indexOf(currentPath.toLowerCase());
  //   if (currentIndex == -1 || currentIndex + 1 >= allPaths.length) return null;
  //   return allPaths[currentIndex + 1];
  // }
}
