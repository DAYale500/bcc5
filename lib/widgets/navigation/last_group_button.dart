// lib/widgets/navigation/last_group_button.dart

import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/widgets/end_of_group_modal.dart';

class LastGroupButton extends StatefulWidget {
  final RenderItemType type;
  final DetailRoute detailRoute;
  final Map<String, dynamic>? backExtra;
  final int branchIndex;
  final String backDestination;
  final String label;
  final Future<List<RenderItem>?> Function() getNextRenderItems;
  final void Function(List<RenderItem> renderItems)? onNavigateToNextGroup;
  final VoidCallback? onRestartAtFirstGroup;

  const LastGroupButton({
    super.key,
    required this.type,
    required this.detailRoute,
    required this.backExtra,
    required this.branchIndex,
    required this.backDestination,
    required this.label,
    required this.getNextRenderItems,
    this.onNavigateToNextGroup,
    this.onRestartAtFirstGroup,
  });

  @override
  State<LastGroupButton> createState() => _LastGroupButtonState();
}

class _LastGroupButtonState extends State<LastGroupButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        logger.i('⏭️ LastGroupButton tapped (${widget.label})');

        final renderItems = await widget.getNextRenderItems();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          _showEndOfGroupModal(context, renderItems ?? []);
        });
      },
      style: AppTheme.navigationButton,
      child: Text('Next ${widget.label.toTitleCase()}'),
    );
  }

  void _showEndOfGroupModal(
    BuildContext context,
    List<RenderItem> renderItems,
  ) {
    final isPath = widget.detailRoute == DetailRoute.path;
    final pathName = widget.backExtra?['pathName'] as String?;
    final chapterId = widget.backExtra?['chapterId'] as String?;

    final nextChapter =
        (isPath && pathName != null && chapterId != null)
            ? PathRepositoryIndex.getNextChapter(pathName, chapterId)
            : null;

    final hasNextGroup = renderItems.isNotEmpty;

    final backRoute =
        isPath
            ? (nextChapter != null
                ? '/learning-paths/${pathName!.toLowerCase().replaceAll(' ', '-')}'
                : '/landing')
            : widget.backDestination;

    final backLabel =
        isPath
            ? (nextChapter != null
                ? 'Back to ${pathName!.toTitleCase()} Chapters'
                : '🎉 Congrats! Return to Home')
            : 'Back to ${_pluralize(widget.label.toTitleCase())}';

    final forwardLabel =
        isPath
            ? (nextChapter != null
                ? 'Next ${pathName!.toTitleCase()} Chapter'
                : 'Restart ${pathName!.toTitleCase()}')
            : (hasNextGroup
                ? 'Next ${widget.label.toTitleCase()}'
                : 'Start Over at Beginning');

    final backExtra = {
      if (isPath && pathName != null) 'pathName': pathName,
      if (isPath && nextChapter != null) 'chapterId': chapterId,
      if (!isPath && widget.backExtra != null) ...widget.backExtra!,
      'branchIndex': widget.branchIndex,
      'transitionKey': UniqueKey().toString(),
      'slideFrom': SlideDirection.left,
      'transitionType': TransitionType.slide,
      'detailRoute': widget.detailRoute,
    };

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder:
          (_) => EndOfGroupModal(
            title:
                nextChapter != null || hasNextGroup
                    ? '📘 End of this ${widget.label}'
                    : '🎉 You’ve completed all ${_pluralize(widget.label)}!',
            message:
                nextChapter != null || hasNextGroup
                    ? 'Nice job! Would you like to return to the main list or begin the next ${widget.label}?'
                    : 'You’ve completed the full path! Return to home or restart the first ${widget.label}.',
            backButtonLabel: backLabel,
            backRoute: backRoute,
            forwardButtonLabel: forwardLabel,
            onNextGroup:
                (nextChapter != null || hasNextGroup)
                    ? () => widget.onNavigateToNextGroup?.call(renderItems)
                    : widget.onRestartAtFirstGroup,
            backExtra: backExtra,
            branchIndex: widget.branchIndex,
            detailRoute: widget.detailRoute,
          ),
    );
  }

  // String _normalizeToTopLevelRoute(String route) {
  //   if (route.startsWith('/learning-paths') && route.contains('/items')) {
  //     return route.replaceAll('/items', '');
  //   }
  //   if (route.endsWith('/items')) {
  //     return route.replaceAll('/items', '');
  //   }
  //   return route;
  // }

  String _pluralize(String word) => word.endsWith('s') ? word : '${word}s';
}
