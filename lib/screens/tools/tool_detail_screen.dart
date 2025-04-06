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

class ToolDetailScreen extends StatefulWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra;

  const ToolDetailScreen({
    super.key,
    required this.renderItems,
    required this.currentIndex,
    required this.branchIndex,
    required this.backDestination,
    this.backExtra,
  });

  @override
  State<ToolDetailScreen> createState() => _ToolDetailScreenState();
}

class _ToolDetailScreenState extends State<ToolDetailScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  void _navigateTo(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.renderItems.length) {
      logger.w('⚠️ Navigation index out of bounds: $newIndex');
      return;
    }
    setState(() {
      currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final RenderItem item = widget.renderItems[currentIndex];

    if (item.type != RenderItemType.tool) {
      logger.w('⚠️ Redirecting from non-tool type: ${item.id} (${item.type})');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateTo(currentIndex);
      });
      return const Scaffold(body: SizedBox());
    }

    final String toolTitle = item.title;
    final String toolbagTitle =
        (widget.backExtra?['toolbag'] as String?)?.toTitleCase() ?? 'Tool';

    logger.i('🛠️ ToolDetailScreen: $toolTitle');
    logger.i('📄 Content blocks: ${item.content.length}');

    return Stack(
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
              onBack: () {
                logger.i('🔙 Back tapped → ${widget.backDestination}');
                if (widget.backExtra != null) {
                  context.go(widget.backDestination, extra: widget.backExtra);
                } else {
                  context.go(widget.backDestination);
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                child: PageTransitionSwitcher(
                  transitionBuilder:
                      (child, animation, secondaryAnimation) =>
                          buildScaleFadeTransition(
                            child,
                            animation,
                            secondaryAnimation,
                          ),
                  child: ContentBlockRenderer(
                    key: ValueKey(item.id),
                    blocks: item.content,
                  ),
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
            ),
          ],
        ),
      ],
    );
  }
}
