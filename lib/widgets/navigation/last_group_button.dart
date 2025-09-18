// lib/widgets/navigation/last_group_button.dart
import 'package:flutter/material.dart';

import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/string_extensions.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/widgets/end_of_group_modal.dart';

// ✅ JSON repos only
import 'package:bcc5/data/repositories/paths/json_path_repository.dart';

class LastGroupButton extends StatefulWidget {
  final RenderItemType type;
  final DetailRoute detailRoute;
  final Map<String, dynamic>? backExtra;
  final int branchIndex;
  final String backDestination;
  final String label;

  /// Parent supplies “what’s next” items (JSON-only upstream).
  final Future<List<RenderItem>?> Function() getNextRenderItems;

  /// Parent performs navigation to next group.
  final void Function(List<RenderItem> renderItems)? onNavigateToNextGroup;

  /// Parent restarts at the first group.
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

        // Capture before awaits; guard later with .mounted
        final localContext = context;

        final isPath = widget.detailRoute == DetailRoute.path;
        final pathName = widget.backExtra?['pathName'] as String?;
        final chapterId = widget.backExtra?['chapterId'] as String?;

        // 1) Ask parent for the next group’s render items (JSON-only upstream).
        final nextRenderItems = await widget.getNextRenderItems();

        // 2) Determine if a *next chapter* exists via JSON repo (no legacy, no curated).
        bool hasNextChapter = false;
        if (isPath && pathName != null && chapterId != null) {
          final nextChapter = await JsonPathRepository.getNextChapter(
            pathName,
            chapterId,
          );
          hasNextChapter = nextChapter != null;
        }

        // Guard the exact BuildContext being used after awaits.
        if (!localContext.mounted) return;

        _showEndOfGroupModal(
          context: localContext,
          renderItems: nextRenderItems ?? const <RenderItem>[],
          isPath: isPath,
          pathName: pathName,
          chapterId: chapterId,
          hasNextChapter: hasNextChapter,
        );
      },
      style: AppTheme.navigationButton,
      child: Text('Next ${widget.label.toTitleCase()}'),
    );
  }

  void _showEndOfGroupModal({
    required BuildContext context,
    required List<RenderItem> renderItems,
    required bool isPath,
    required String? pathName,
    required String? chapterId,
    required bool hasNextChapter,
  }) {
    final hasNextGroup = renderItems.isNotEmpty;

    final backRoute =
        isPath
            ? (hasNextChapter
                ? '/learning-paths/${pathName!.toLowerCase().replaceAll(' ', '-')}'
                : '/')
            : widget.backDestination;

    final backLabel =
        isPath
            ? (hasNextChapter
                ? 'Back to ${pathName!.toTitleCase()} Chapters'
                : '🎉 Congrats! Return to Home')
            : 'Back to ${_pluralize(widget.label.toTitleCase())}';

    final forwardLabel =
        isPath
            ? (hasNextChapter
                ? 'Next ${pathName!.toTitleCase()} Chapter'
                : 'Restart ${pathName!.toTitleCase()}')
            : (hasNextGroup
                ? 'Next ${widget.label.toTitleCase()}'
                : 'Start Over at Beginning');

    final backExtra = <String, dynamic>{
      if (isPath && pathName != null) 'pathName': pathName,
      if (isPath && hasNextChapter) 'chapterId': chapterId,
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
                (hasNextChapter || hasNextGroup)
                    ? '📘 End of this ${widget.label}'
                    : '🎉 You’ve completed all ${_pluralize(widget.label)}!',
            message:
                (hasNextChapter || hasNextGroup)
                    ? 'Nice job! Would you like to return to the main list or begin the next ${widget.label}?'
                    : 'You’ve completed the full path! Return to home or restart the first ${widget.label}.',
            backButtonLabel: backLabel,
            backRoute: backRoute,
            forwardButtonLabel: forwardLabel,
            onNextGroup:
                (hasNextChapter || hasNextGroup)
                    ? () => widget.onNavigateToNextGroup?.call(renderItems)
                    : widget.onRestartAtFirstGroup,
            backExtra: backExtra,
            branchIndex: widget.branchIndex,
            detailRoute: widget.detailRoute,
            curatedFlashcards: const <RenderItem>[], // removed curated mapping
          ),
    );
  }

  String _pluralize(String word) => word.endsWith('s') ? word : '${word}s';
}
