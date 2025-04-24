// PartDetailScreen.dart

// ✅ No import changes needed
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/widgets/learning_path_progress_bar.dart';
import 'package:bcc5/widgets/navigation/last_group_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/transition_manager.dart';

import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';

// import 'package:bcc5/widgets/end_of_group_modal.dart';

class PartDetailScreen extends StatefulWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra;
  final DetailRoute detailRoute;
  final String transitionKey;

  const PartDetailScreen({
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
  State<PartDetailScreen> createState() => _PartDetailScreenState();
}

class _PartDetailScreenState extends State<PartDetailScreen> {
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
    if (item.type != RenderItemType.part) {
      logger.w('⚠️ Redirecting from non-part type: ${item.id} (${item.type})');
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
          replace: true,
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
      backExtra: widget.backExtra,
      detailRoute: widget.detailRoute,
      direction: SlideDirection.none,
      transitionType: TransitionType.fadeScale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.renderItems[currentIndex];
    if (item.type != RenderItemType.part) {
      return const Scaffold(body: SizedBox());
    }

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: buildScaleFadeTransition,
      child: _buildScaffold(item, item.title, 'Parts'),
    );
  }

  Widget _buildScaffold(RenderItem item, String partTitle, String zoneTitle) {
    // final zoneId = widget.backExtra?['zone'] as String?;

    return Scaffold(
      key: ValueKey(widget.transitionKey),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/images/deck_parts_montage.webp',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              CustomAppBarWidget(
                title: zoneTitle,
                showBackButton: true,
                showSearchIcon: true,
                showSettingsIcon: true,
                mobKey: mobKey,
                settingsKey: settingsKey,
                searchKey: searchKey,
                titleKey: titleKey,
                onBack: () {
                  logger.i('🔙 Back tapped → ${widget.backDestination}');
                  context.go(
                    widget.backDestination,
                    extra: {
                      ...?widget.backExtra,
                      'transitionKey': UniqueKey().toString(),
                      'slideFrom': SlideDirection.left,
                      'transitionType': TransitionType.slide,
                    },
                  );
                },
              ),
              if (widget.detailRoute == DetailRoute.path)
                LearningPathProgressBar(
                  pathName: widget.backExtra?['pathName'] ?? '',
                ),
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
                                    : 'Parts',
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
                                    : (widget.backExtra?['zone'] as String?)
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
                  partTitle,
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
                onPrevious: () => _navigateTo(currentIndex - 1),
                onNext: () => _navigateTo(currentIndex + 1),
                customNextButton:
                    (currentIndex == widget.renderItems.length - 1)
                        ? LastGroupButton(
                          type: RenderItemType.part,
                          detailRoute: widget.detailRoute,
                          backExtra: widget.backExtra,
                          branchIndex: widget.branchIndex,
                          backDestination:
                              widget.detailRoute == DetailRoute.path
                                  ? '/learning-paths/${(widget.backExtra?['pathName'] as String).replaceAll(' ', '-').toLowerCase()}/items'
                                  : '/parts/items',
                          label:
                              widget.detailRoute == DetailRoute.path
                                  ? 'chapter'
                                  : 'zone',
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
                              final currentZoneId =
                                  widget.backExtra?['zone'] as String?;
                              if (currentZoneId == null) return null;

                              final nextZoneId =
                                  PartRepositoryIndex.getNextZone(
                                    currentZoneId,
                                  );
                              if (nextZoneId == null) return null;

                              return buildRenderItems(
                                ids:
                                    PartRepositoryIndex.getPartsForZone(
                                      nextZoneId,
                                    ).map((e) => e.id).toList(),
                              );
                            }
                          },
                          onNavigateToNextGroup: (renderItems) {
                            if (renderItems.isEmpty) return;

                            final nextBackExtra = {
                              if (widget.detailRoute == DetailRoute.path)
                                'chapterId':
                                    PathRepositoryIndex.getNextChapter(
                                      widget.backExtra?['pathName'],
                                      widget.backExtra?['chapterId'],
                                    )?.id,
                              if (widget.detailRoute == DetailRoute.path)
                                'pathName': widget.backExtra?['pathName'],
                              if (widget.detailRoute == DetailRoute.branch)
                                'zone': PartRepositoryIndex.getNextZone(
                                  widget.backExtra?['zone'],
                                ),
                              'branchIndex': widget.branchIndex,
                            };

                            final route =
                                widget.detailRoute == DetailRoute.path
                                    ? '/learning-paths/${(widget.backExtra?['pathName'] as String).replaceAll(' ', '-').toLowerCase()}/items'
                                    : '/parts/items';

                            TransitionManager.goToDetailScreen(
                              context: context,
                              screenType: RenderItemType.part,
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
                            final firstZoneId =
                                PartRepositoryIndex.getZoneNames().first;
                            final firstItems =
                                PartRepositoryIndex.getPartsForZone(
                                  firstZoneId,
                                );
                            final renderItems = buildRenderItems(
                              ids: firstItems.map((p) => p.id).toList(),
                            );

                            if (renderItems.isEmpty) return;

                            TransitionManager.goToDetailScreen(
                              context: context,
                              screenType: RenderItemType.part,
                              renderItems: renderItems,
                              currentIndex: 0,
                              branchIndex: widget.branchIndex,
                              backDestination: '/parts/items',
                              backExtra: {
                                'zone': firstZoneId,
                                'branchIndex': widget.branchIndex,
                              },
                              detailRoute: widget.detailRoute,
                              direction: SlideDirection.right,
                              replace: true,
                            );
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
