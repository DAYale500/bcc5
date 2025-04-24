import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/widgets/learning_path_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/transition_manager.dart';

import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/widgets/navigation/last_group_button.dart';

class ToolDetailScreen extends StatefulWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra;
  final DetailRoute detailRoute;
  final String transitionKey;

  const ToolDetailScreen({
    super.key,
    required this.renderItems,
    required this.currentIndex,
    required this.branchIndex,
    required this.backDestination,
    required this.backExtra,
    required this.detailRoute,
    required this.transitionKey,
  });

  @override
  State<ToolDetailScreen> createState() => _ToolDetailScreenState();
}

class _ToolDetailScreenState extends State<ToolDetailScreen> {
  late int currentIndex;
  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;

    final item = widget.renderItems[currentIndex];
    if (item.type != RenderItemType.tool) {
      logger.w('⚠️ Redirecting from non-tool type: ${item.id} (${item.type})');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TransitionManager.goToDetailScreen(
          context: context,
          screenType: item.type,
          renderItems: widget.renderItems,
          currentIndex: currentIndex,
          branchIndex: widget.branchIndex,
          backDestination: widget.backDestination,
          backExtra: widget.backExtra,
          detailRoute: widget.detailRoute,
          direction: SlideDirection.none,
          replace: true, // ✅ ensures redirect doesn’t stack
        );
      });
    }
  }

  void _navigateTo(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.renderItems.length) {
      logger.w('⚠️ Navigation index out of bounds: $newIndex');
      return;
    }

    final targetItem = widget.renderItems[newIndex];

    TransitionManager.goToDetailScreen(
      context: context,
      screenType: targetItem.type,
      renderItems: widget.renderItems,
      currentIndex: newIndex,
      branchIndex: widget.branchIndex,
      backDestination: widget.backDestination,
      backExtra: widget.backExtra, // ✅ Unchanged, clean
      detailRoute: widget.detailRoute,
      direction: SlideDirection.none,
      transitionType: TransitionType.fadeScale,
      replace: true, // ✅ Still correct
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.renderItems[currentIndex];
    // logger.d('[ToolDetail] AppBar keys assigned.');

    if (item.type != RenderItemType.tool) {
      return const Scaffold(body: SizedBox());
    }

    const toolbagTitle = 'Tools';
    final toolTitle = item.title;
    // final toolbagId = widget.backExtra?['toolbag'] as String?;

    // logger.d('[ToolDetail] Content blocks: ${item.content.length}');

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: buildScaleFadeTransition,
      child: _buildScaffold(item, toolTitle, toolbagTitle),
    );
  }

  Widget _buildScaffold(
    RenderItem item,
    String toolTitle,
    String toolbagTitle,
  ) {
    // final subtitleText = toolTitle;
    return Scaffold(
      key: ValueKey(widget.transitionKey),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/images/navigation_lights.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              CustomAppBarWidget(
                title: toolbagTitle,
                showBackButton: true,
                showSearchIcon: true,
                showSettingsIcon: true,
                mobKey: mobKey,
                settingsKey: settingsKey,
                searchKey: searchKey,
                titleKey: titleKey,

                onBack: () {
                  logger.i('🔙 Back tapped → ${widget.backDestination}');

                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    logger.w('⚠️ No pages left to pop. Redirecting manually.');
                    context.go(
                      widget.backDestination,
                      extra: {
                        ...?widget.backExtra,
                        'transitionKey': UniqueKey().toString(),
                        'slideFrom': SlideDirection.left,
                        'transitionType': TransitionType.slide,
                      },
                    );
                  }
                },
              ),
              if (widget.detailRoute == DetailRoute.path)
                LearningPathProgressBar(
                  pathName: widget.backExtra?['pathName'] ?? '',
                ),

              /// the bottom of insert area
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                widget.detailRoute == DetailRoute.path
                                    ? (widget.backExtra?['pathName'] as String?)
                                            ?.toTitleCase() ??
                                        ''
                                    : 'Tools',
                            style: AppTheme.branchBreadcrumbStyle,
                          ),
                          const TextSpan(
                            text: ' / ',
                            style: TextStyle(color: Colors.black87),
                          ),
                          TextSpan(
                            text:
                                widget.detailRoute == DetailRoute.path
                                    ? PathRepositoryIndex.getChapterTitleForPath(
                                          widget.backExtra?['pathName'] ?? '',
                                          widget.backExtra?['chapterId'] ?? '',
                                        )?.toTitleCase() ??
                                        ''
                                    : (widget.backExtra?['toolbag'] as String?)
                                            ?.toTitleCase() ??
                                        '',
                            style: AppTheme.groupBreadcrumbStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Text(
                  toolTitle,
                  style: AppTheme.scaledTextTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ContentBlockRenderer(
                    key: ValueKey(item.id),
                    blocks: item.content,
                  ),
                ),
              ),
              NavigationButtons(
                isPreviousEnabled: currentIndex > 0,
                isNextEnabled: currentIndex < widget.renderItems.length - 1,
                onPrevious: () {
                  logger.i('⬅️ Previous tapped on ToolDetailScreen');
                  _navigateTo(currentIndex - 1);
                },
                onNext: () {
                  logger.i('➡️ Next tapped on ToolDetailScreen');
                  _navigateTo(currentIndex + 1);
                },
                customNextButton:
                    currentIndex == widget.renderItems.length - 1
                        ? LastGroupButton(
                          type: RenderItemType.tool,
                          detailRoute: widget.detailRoute,
                          backExtra: widget.backExtra,
                          branchIndex: widget.branchIndex,
                          backDestination:
                              widget.detailRoute == DetailRoute.path
                                  ? '/learning-paths/${(widget.backExtra?['pathName'] as String).replaceAll(' ', '-').toLowerCase()}/items'
                                  : '/tools/items',
                          label:
                              widget.detailRoute == DetailRoute.path
                                  ? 'chapter'
                                  : 'toolbag',
                          getNextRenderItems: () async {
                            if (widget.detailRoute == DetailRoute.path) {
                              final pathName =
                                  widget.backExtra?['pathName'] as String?;
                              final chapterId =
                                  widget.backExtra?['chapterId'] as String?;
                              if (pathName == null || chapterId == null) {
                                return null;
                              }

                              final nextChapter =
                                  PathRepositoryIndex.getNextChapter(
                                    pathName,
                                    chapterId,
                                  );
                              if (nextChapter == null) return null;

                              return buildRenderItems(
                                ids:
                                    nextChapter.items
                                        .map((e) => e.pathItemId)
                                        .toList(),
                              );
                            } else {
                              final currentToolbag =
                                  widget.backExtra?['toolbag'] as String?;
                              if (currentToolbag == null) return null;

                              final nextToolbag =
                                  ToolRepositoryIndex.getNextToolbag(
                                    currentToolbag,
                                  );
                              if (nextToolbag == null) return null;

                              final tools = ToolRepositoryIndex.getToolsForBag(
                                nextToolbag,
                              );
                              return buildRenderItems(
                                ids: tools.map((e) => e.id).toList(),
                              );
                            }
                          },
                          onNavigateToNextGroup: (renderItems) {
                            if (renderItems.isEmpty) return;

                            final isPath =
                                widget.detailRoute == DetailRoute.path;
                            final nextBackExtra = {
                              if (isPath)
                                'chapterId':
                                    PathRepositoryIndex.getNextChapter(
                                      widget.backExtra?['pathName'],
                                      widget.backExtra?['chapterId'],
                                    )?.id,
                              if (isPath)
                                'pathName': widget.backExtra?['pathName'],
                              if (!isPath)
                                'toolbag': ToolRepositoryIndex.getNextToolbag(
                                  widget.backExtra?['toolbag'],
                                ),
                              if (widget.backExtra?['cameFromMob'] == true)
                                'cameFromMob': true,
                              'branchIndex': widget.branchIndex,
                            };

                            final route =
                                isPath
                                    ? '/learning-paths/${(widget.backExtra?['pathName'] as String).replaceAll(' ', '-').toLowerCase()}/items'
                                    : '/tools/items';

                            TransitionManager.goToDetailScreen(
                              context: context,
                              screenType: RenderItemType.tool,
                              renderItems: renderItems,
                              currentIndex: 0,
                              branchIndex: widget.branchIndex,
                              backDestination: route,
                              backExtra: nextBackExtra,
                              detailRoute: widget.detailRoute,
                              direction: SlideDirection.right,
                              replace: true,
                            );
                          },
                          onRestartAtFirstGroup: () {
                            final isPath =
                                widget.detailRoute == DetailRoute.path;

                            if (isPath) {
                              final pathName =
                                  widget.backExtra?['pathName'] as String?;
                              final firstChapter =
                                  pathName == null
                                      ? null
                                      : PathRepositoryIndex.getChaptersForPath(
                                        pathName,
                                      ).first;
                              if (pathName == null || firstChapter == null) {
                                return;
                              }

                              final renderItems = buildRenderItems(
                                ids:
                                    firstChapter.items
                                        .map((e) => e.pathItemId)
                                        .toList(),
                              );

                              if (renderItems.isEmpty) return;

                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: RenderItemType.tool,
                                renderItems: renderItems,
                                currentIndex: 0,
                                branchIndex: widget.branchIndex,
                                backDestination:
                                    '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                                backExtra: {
                                  'pathName': pathName,
                                  'chapterId': firstChapter.id,
                                  'branchIndex': widget.branchIndex,
                                },
                                detailRoute: widget.detailRoute,
                                direction: SlideDirection.right,
                                replace: true,
                              );
                            } else {
                              final firstToolbag =
                                  ToolRepositoryIndex.getToolbagNames().first;
                              final firstTools =
                                  ToolRepositoryIndex.getToolsForBag(
                                    firstToolbag,
                                  );
                              final renderItems = buildRenderItems(
                                ids: firstTools.map((e) => e.id).toList(),
                              );

                              if (renderItems.isEmpty) return;

                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: RenderItemType.tool,
                                renderItems: renderItems,
                                currentIndex: 0,
                                branchIndex: widget.branchIndex,
                                backDestination: '/tools/items',
                                backExtra: {
                                  'toolbag': firstToolbag,
                                  'branchIndex': widget.branchIndex,
                                  if (widget.backExtra?['cameFromMob'] == true)
                                    'cameFromMob': true,
                                },
                                detailRoute: widget.detailRoute,
                                direction: SlideDirection.right,
                                replace: true,
                              );
                            }
                          },
                        )
                        : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
