// lib/widgets/navigation/last_group_button.dart

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
    final labelCapitalized = widget.label.toTitleCase();
    final labelPlural = _pluralize(labelCapitalized);
    final hasNextGroup = renderItems.isNotEmpty;

    final nextGroupLabel =
        hasNextGroup ? 'Next $labelCapitalized' : 'Start Over at Beginning';

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder:
          (_) => EndOfGroupModal(
            title:
                hasNextGroup
                    ? '📘 End of this ${widget.label}'
                    : '🎉 You’ve completed all $labelPlural!',
            message:
                hasNextGroup
                    ? 'Nice job! Would you like to return to the main list or begin the next ${widget.label}?'
                    : 'Great job finishing this ${widget.label}. You can return to the main list or start over from the beginning.',
            backButtonLabel: 'Back to $labelPlural',
            backRoute: widget.backDestination,
            forwardButtonLabel: nextGroupLabel,
            onNextGroup: () {
              if (hasNextGroup && widget.onNavigateToNextGroup != null) {
                widget.onNavigateToNextGroup!(renderItems);
              } else if (!hasNextGroup &&
                  widget.onRestartAtFirstGroup != null) {
                widget.onRestartAtFirstGroup!();
              }
            },
          ),
    );
  }

  String _pluralize(String word) => word.endsWith('s') ? word : '${word}s';
}
