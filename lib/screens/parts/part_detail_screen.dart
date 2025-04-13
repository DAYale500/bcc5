import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/widgets/learning_path_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/transition_manager.dart';

import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';

import 'package:bcc5/widgets/group_picker_dropdown.dart';

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
    required this.mobKey,
    required this.settingsKey,
    required this.searchKey,
    required this.titleKey,
  });
  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;

  @override
  State<PartDetailScreen> createState() => _PartDetailScreenState();
}

class _PartDetailScreenState extends State<PartDetailScreen> {
  late int currentIndex;

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
      transitionType: TransitionType.fadeScale, // ✅ NEW LINE
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.renderItems[currentIndex];

    if (item.type != RenderItemType.part) {
      return const Scaffold(body: SizedBox());
    }

    final partTitle = item.title;
    // final zoneId = widget.backExtra?['zone'] as String?;
    const zoneTitle = 'Parts';

    logger.i('🧩 PartDetailScreen: $partTitle');
    logger.i('📄 Content blocks: ${item.content.length}');

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: buildScaleFadeTransition,
      child: _buildScaffold(item, partTitle, zoneTitle),
    );
  }

  Widget _buildScaffold(RenderItem item, String partTitle, String zoneTitle) {
    final zoneId = widget.backExtra?['zone'] as String?;
    final subtitleText = item.title;

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
                mobKey: widget.mobKey,
                settingsKey: widget.settingsKey,
                searchKey: widget.searchKey,
                titleKey: widget.titleKey,
                onBack: () {
                  logger.i('🔙 Back tapped → ${widget.backDestination}');
                  context.go(
                    widget.backDestination,
                    extra: {
                      ...?widget.backExtra,
                      'transitionKey': UniqueKey().toString(),
                      'slideFrom': SlideDirection.left,
                      'transitionType': TransitionType.slide, // ✅ Add this line
                    },
                  );
                },
              ),
              if (widget.detailRoute == DetailRoute.path)
                LearningPathProgressBar(
                  pathName: widget.backExtra?['pathName'] ?? '',
                ),

              if (widget.detailRoute == DetailRoute.branch)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GroupPickerDropdown(
                    label: 'Zone',
                    selectedId: zoneId?.toLowerCase() ?? '',
                    ids: PartRepositoryIndex.getZoneNames(),
                    idToTitle: {
                      for (final id in PartRepositoryIndex.getZoneNames())
                        id: id.toTitleCase(),
                    },
                    onChanged: (selectedZoneId) {
                      if (selectedZoneId == zoneId) {
                        logger.i('🟡 Same zone selected → no action');
                        return;
                      }

                      final parts = PartRepositoryIndex.getPartsForZone(
                        selectedZoneId,
                      );
                      final renderItems = buildRenderItems(
                        ids: parts.map((p) => p.id).toList(),
                      );

                      if (renderItems.isEmpty) {
                        logger.w('⚠️ Selected zone has no renderable items');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Selected zone has no items.'),
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
                        backDestination: '/parts/items',
                        backExtra: {
                          'zone': selectedZoneId,
                          'branchIndex': widget.branchIndex,
                        },
                        detailRoute: widget.detailRoute,
                        direction: SlideDirection.right,
                      );
                    },
                  ),
                ),

              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Text(
                  subtitleText,
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
                  logger.i('⬅️ Previous tapped on PartDetailScreen');
                  _navigateTo(currentIndex - 1);
                },
                onNext: () {
                  logger.i('➡️ Next tapped on PartDetailScreen');
                  _navigateTo(currentIndex + 1);
                },
                customNextButton:
                    (currentIndex == widget.renderItems.length - 1)
                        ? ElevatedButton(
                          onPressed: () {
                            logger.i(
                              '⏭️ Next Chapter tapped on PartDetailScreen',
                            );

                            if (widget.detailRoute == DetailRoute.branch) {
                              final currentZoneId =
                                  widget.backExtra?['zone'] as String?;
                              if (currentZoneId == null) {
                                logger.w('⚠️ No zone ID found in backExtra');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cannot find next zone.'),
                                  ),
                                );
                                return;
                              }

                              final nextZoneId =
                                  PartRepositoryIndex.getNextZone(
                                    currentZoneId,
                                  );
                              if (nextZoneId == null) {
                                logger.i(
                                  '⛔ No more zones after $currentZoneId',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'You’ve reached the final zone.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final partItems =
                                  PartRepositoryIndex.getPartsForZone(
                                    nextZoneId,
                                  );
                              final renderItems = buildRenderItems(
                                ids: partItems.map((p) => p.id).toList(),
                              );

                              if (renderItems.isEmpty) {
                                logger.w(
                                  '⚠️ Next zone has no renderable items',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Next zone has no items.'),
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
                                backDestination: '/parts/items',
                                backExtra: {
                                  'zone': nextZoneId,
                                  'branchIndex': widget.branchIndex,
                                },
                                detailRoute: widget.detailRoute,
                                direction: SlideDirection.right,
                              );
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
