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
    logger.i(
      '📘 Building PathItemScreen for path "${widget.pathName}", chapter "${widget.chapterId}"',
    );

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
    final renderItems = buildRenderItems(ids: sequenceIds);

    logger.i(
      '🟩 Found chapter "${chapter.title}" with ${renderItems.length} items',
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
          'Resume your voyage, or chart any path below.',
          style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryBlue),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: renderItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, index) {
                final renderItem = renderItems[index];
                final id = renderItem.id;
                final title = renderItem.title;

                logger.i('📦 Rendering button: $id → "$title" (index $index)');

                return ItemButton(
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
