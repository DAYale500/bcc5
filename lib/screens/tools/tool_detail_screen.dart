import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/widgets/group_picker_dropdown.dart';
import 'package:bcc5/widgets/learning_path_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/transition_manager.dart';

import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:go_router/go_router.dart';

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
      backExtra: {
        ...?widget.backExtra,
        'toolbag': widget.backExtra?['toolbag'],
        'cameFromMob': widget.backExtra?['cameFromMob'] == true,
        'transitionKey': UniqueKey().toString(),
        'slideFrom': SlideDirection.none,
        'transitionType': TransitionType.fadeScale,
      },
      detailRoute: widget.detailRoute,
      direction: SlideDirection.none,
      transitionType: TransitionType.fadeScale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.renderItems[currentIndex];
    logger.i(
      'ToolDetailScreen GlobalKeys → mob: $mobKey, settings: $settingsKey, search: $searchKey, title: $titleKey',
    );

    if (item.type != RenderItemType.tool) {
      return const Scaffold(body: SizedBox());
    }

    const toolbagTitle = 'Tools';
    final toolTitle = item.title;
    // final toolbagId = widget.backExtra?['toolbag'] as String?;

    logger.i('🛠️ ToolDetailScreen: $toolTitle');
    logger.i('📄 Content blocks: ${item.content.length}');

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
                    context.go(widget.backDestination, extra: widget.backExtra);
                  }
                },
              ),
              if (widget.detailRoute == DetailRoute.path)
                LearningPathProgressBar(
                  pathName: widget.backExtra?['pathName'] ?? '',
                ),

              // This section renders the GroupPickerDropdown used for switching between
              //toolbags in branch mode. When the user selects a different toolbag,
              //it rebuilds renderItems and navigates to the new tool.
              //
              if (widget.detailRoute == DetailRoute.branch)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GroupPickerDropdown(
                    label: 'Toolbag',
                    selectedId: widget.backExtra?['toolbag'] ?? '',
                    ids: ToolRepositoryIndex.getToolbagNames(),
                    idToTitle: {
                      for (final id in ToolRepositoryIndex.getToolbagNames())
                        id: id.toTitleCase(),
                    },
                    onChanged: (selectedToolbagId) {
                      if (selectedToolbagId == widget.backExtra?['toolbag']) {
                        logger.i('🟡 Same toolbag selected → no action');
                        return;
                      }

                      final tools = ToolRepositoryIndex.getToolsForBag(
                        selectedToolbagId,
                      );
                      final renderItems = buildRenderItems(
                        ids: tools.map((tool) => tool.id).toList(),
                      );

                      if (renderItems.isEmpty) {
                        logger.w('⚠️ Selected toolbag has no renderable items');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Selected toolbag has no items.'),
                          ),
                        );
                        return;
                      }

                      logger.i(
                        '🛠️ Navigating to ToolItemScreen for new toolbag: $selectedToolbagId',
                      );

                      // ✅ Step 1: Push to ToolItemScreen
                      context.push(
                        '/tools/items',
                        extra: {
                          'toolbag': selectedToolbagId,
                          'transitionKey':
                              'tool_items_${selectedToolbagId}_${DateTime.now().millisecondsSinceEpoch}',
                          'slideFrom': SlideDirection.right,
                          'transitionType': TransitionType.slide,
                          'detailRoute': DetailRoute.branch,
                          'cameFromMob':
                              widget.backExtra?['cameFromMob'] == true,
                        },
                      );

                      // ✅ Step 2: After frame, navigate to new tool detail
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        TransitionManager.goToDetailScreen(
                          context: context,
                          screenType: renderItems.first.type,
                          renderItems: renderItems,
                          currentIndex: 0,
                          branchIndex: widget.branchIndex,
                          backDestination: '/tools/items',
                          backExtra: {
                            'toolbag': selectedToolbagId,
                            'cameFromMob':
                                widget.backExtra?['cameFromMob'] == true,
                          },
                          detailRoute: widget.detailRoute,
                          direction: SlideDirection.right,
                          replace: true,
                        );
                      });
                    },
                  ),
                ),

              /// the bottom of insert area
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
                        ? ElevatedButton(
                          onPressed: () {
                            logger.i(
                              '⏭️ Next Chapter tapped on ToolDetailScreen',
                            );
                            // When in branch mode and on the last tool in the current
                            //toolbag, tapping “Next Chapter Branch Mode” navigates to the next
                            //toolbag (if one exists) and renders its items.
                            if (widget.detailRoute == DetailRoute.branch) {
                              final currentToolbag =
                                  widget.backExtra?['toolbag'] as String?;
                              if (currentToolbag == null) {
                                logger.w('⚠️ No toolbag ID found in backExtra');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cannot find next toolbag.'),
                                  ),
                                );
                                return;
                              }

                              final nextToolbag =
                                  ToolRepositoryIndex.getNextToolbag(
                                    currentToolbag,
                                  );
                              if (nextToolbag == null) {
                                logger.i(
                                  '⛔ No more toolbags after $currentToolbag',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'You’ve reached the final toolbag.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final tools = ToolRepositoryIndex.getToolsForBag(
                                nextToolbag,
                              );
                              final renderItems = buildRenderItems(
                                ids: tools.map((tool) => tool.id).toList(),
                              );

                              if (renderItems.isEmpty) {
                                logger.w(
                                  '⚠️ Next toolbag has no renderable items',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Next toolbag has no items.'),
                                  ),
                                );
                                return;
                              }

                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: renderItems.first.type,
                                renderItems: renderItems,
                                currentIndex: 0,
                                branchIndex: widget.branchIndex,
                                backDestination: '/tools/items',
                                backExtra: {
                                  'toolbag': nextToolbag,
                                  'cameFromMob':
                                      widget.backExtra?['cameFromMob'] == true,
                                },

                                detailRoute: widget.detailRoute,
                                direction: SlideDirection.right,
                                replace: true,
                              );

                              // If in path mode, and the current tool is the last in
                              // the chapter, the “Next Chapter Path Mode” button navigates to
                              // the next chapter using PathRepositoryIndex.getNextChapter.
                            } else if (widget.detailRoute == DetailRoute.path) {
                              final currentChapterId =
                                  widget.backExtra?['chapterId'] as String?;
                              final pathName =
                                  widget.backExtra?['pathName'] as String?;

                              if (currentChapterId == null ||
                                  pathName == null) {
                                logger.w(
                                  '⚠️ Missing path context in backExtra',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No path context found.'),
                                  ),
                                );
                                return;
                              }

                              final nextChapter =
                                  PathRepositoryIndex.getNextChapter(
                                    pathName,
                                    currentChapterId,
                                  );
                              if (nextChapter == null) {
                                logger.i(
                                  '⛔ No next chapter in $pathName after $currentChapterId',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'You’ve reached the final chapter.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final renderItems = buildRenderItems(
                                ids:
                                    nextChapter.items
                                        .map((item) => item.pathItemId)
                                        .toList(),
                              );

                              if (renderItems.isEmpty) {
                                logger.w(
                                  '⚠️ Next chapter has no renderable items',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Next chapter has no items.'),
                                  ),
                                );
                                return;
                              }

                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: renderItems.first.type,
                                renderItems: renderItems,
                                currentIndex: 0,
                                branchIndex: widget.branchIndex,
                                backDestination:
                                    '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                                backExtra: {
                                  'chapterId': nextChapter.id,
                                  'pathName': pathName,
                                  'branchIndex': widget.branchIndex,
                                },
                                detailRoute: widget.detailRoute,
                                direction: SlideDirection.right,
                                replace: true,
                              );
                            }
                          },
                          style: AppTheme.navigationButton,
                          child: const Text('Next Chapter'),
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
