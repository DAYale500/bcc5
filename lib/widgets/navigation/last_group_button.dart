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

// // lib/widgets/navigation/last_group_button.dart

// import 'package:flutter/material.dart';

// import 'package:bcc5/theme/app_theme.dart';
// import 'package:bcc5/theme/slide_direction.dart';
// import 'package:bcc5/theme/transition_type.dart';
// import 'package:bcc5/utils/logger.dart';
// import 'package:bcc5/utils/string_extensions.dart';

// import 'package:bcc5/data/models/render_item.dart';
// import 'package:bcc5/navigation/detail_route.dart';
// import 'package:bcc5/widgets/end_of_group_modal.dart';

// // ✅ JSON-backed repos only
// import 'package:bcc5/data/repositories/paths/json_path_repository.dart';
// import 'package:bcc5/data/repositories/flashcards/json_flashcard_repository.dart';

// // ✅ Curated mapping for per-chapter flashcards
// import 'package:bcc5/data/repositories/flashcards/competent_crew_flashards.dart';

// class LastGroupButton extends StatefulWidget {
//   final RenderItemType type;
//   final DetailRoute detailRoute;
//   final Map<String, dynamic>? backExtra;
//   final int branchIndex;
//   final String backDestination;
//   final String label;

//   /// Parent supplies “what’s next” items (JSON-only upstream).
//   final Future<List<RenderItem>?> Function() getNextRenderItems;

//   /// Parent performs navigation to next group.
//   final void Function(List<RenderItem> renderItems)? onNavigateToNextGroup;

//   /// Parent restarts at the first group.
//   final VoidCallback? onRestartAtFirstGroup;

//   const LastGroupButton({
//     super.key,
//     required this.type,
//     required this.detailRoute,
//     required this.backExtra,
//     required this.branchIndex,
//     required this.backDestination,
//     required this.label,
//     required this.getNextRenderItems,
//     this.onNavigateToNextGroup,
//     this.onRestartAtFirstGroup,
//   });

//   @override
//   State<LastGroupButton> createState() => _LastGroupButtonState();
// }

// class _LastGroupButtonState extends State<LastGroupButton> {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () async {
//         logger.i('⏭️ LastGroupButton tapped (${widget.label})');

//         // Capture BEFORE awaits; guard later with `.mounted`.
//         final localContext = context;

//         final isPath = widget.detailRoute == DetailRoute.path;
//         final pathName = widget.backExtra?['pathName'] as String?;
//         final chapterId = widget.backExtra?['chapterId'] as String?;

//         // 1) Ask parent for the next group’s render items (JSON-only upstream).
//         final nextRenderItems = await widget.getNextRenderItems();

//         // 2) Curated flashcards (if any) using JSON repo by IDs.
//         final curated = <RenderItem>[];
//         if (isPath && chapterId != null) {
//           final curatedIds = curatedChapterFlashcards[chapterId];
//           if (curatedIds != null && curatedIds.isNotEmpty) {
//             final curatedCards =
//                 await JsonFlashcardRepository.getFlashcardsByIds(curatedIds);
//             curated.addAll(curatedCards.map(RenderItem.fromFlashcard));
//           }
//         }

//         // 3) Determine if a *next chapter* exists via JSON repo (no legacy).
//         bool hasNextChapter = false;
//         if (isPath && pathName != null && chapterId != null) {
//           final nextChapter = await JsonPathRepository.getNextChapter(
//             pathName,
//             chapterId,
//           );
//           hasNextChapter = nextChapter != null;
//         }

//         // ✅ Guard the exact BuildContext being used after awaits.
//         if (!localContext.mounted) return;

//         _showEndOfGroupModal(
//           context: localContext,
//           renderItems: nextRenderItems ?? const <RenderItem>[],
//           curatedFlashcards: curated,
//           isPath: isPath,
//           pathName: pathName,
//           chapterId: chapterId,
//           hasNextChapter: hasNextChapter,
//         );
//       },
//       style: AppTheme.navigationButton,
//       child: Text('Next ${widget.label.toTitleCase()}'),
//     );
//   }

//   void _showEndOfGroupModal({
//     required BuildContext context,
//     required List<RenderItem> renderItems,
//     required List<RenderItem> curatedFlashcards,
//     required bool isPath,
//     required String? pathName,
//     required String? chapterId,
//     required bool hasNextChapter,
//   }) {
//     final hasNextGroup = renderItems.isNotEmpty;

//     final backRoute =
//         isPath
//             ? (hasNextChapter
//                 ? '/learning-paths/${pathName!.toLowerCase().replaceAll(' ', '-')}'
//                 : '/')
//             : widget.backDestination;

//     final backLabel =
//         isPath
//             ? (hasNextChapter
//                 ? 'Back to ${pathName!.toTitleCase()} Chapters'
//                 : '🎉 Congrats! Return to Home')
//             : 'Back to ${_pluralize(widget.label.toTitleCase())}';

//     final forwardLabel =
//         isPath
//             ? (hasNextChapter
//                 ? 'Next ${pathName!.toTitleCase()} Chapter'
//                 : 'Restart ${pathName!.toTitleCase()}')
//             : (hasNextGroup
//                 ? 'Next ${widget.label.toTitleCase()}'
//                 : 'Start Over at Beginning');

//     final backExtra = <String, dynamic>{
//       if (isPath && pathName != null) 'pathName': pathName,
//       if (isPath && hasNextChapter) 'chapterId': chapterId,
//       if (!isPath && widget.backExtra != null) ...widget.backExtra!,
//       'branchIndex': widget.branchIndex,
//       'transitionKey': UniqueKey().toString(),
//       'slideFrom': SlideDirection.left,
//       'transitionType': TransitionType.slide,
//       'detailRoute': widget.detailRoute,
//     };

//     showModalBottomSheet(
//       context: context,
//       showDragHandle: true,
//       builder:
//           (_) => EndOfGroupModal(
//             title:
//                 (hasNextChapter || hasNextGroup)
//                     ? '📘 End of this ${widget.label}'
//                     : '🎉 You’ve completed all ${_pluralize(widget.label)}!',
//             message:
//                 (hasNextChapter || hasNextGroup)
//                     ? 'Nice job! Would you like to return to the main list or begin the next ${widget.label}?'
//                     : 'You’ve completed the full path! Return to home or restart the first ${widget.label}.',
//             backButtonLabel: backLabel,
//             backRoute: backRoute,
//             forwardButtonLabel: forwardLabel,
//             onNextGroup:
//                 (hasNextChapter || hasNextGroup)
//                     ? () => widget.onNavigateToNextGroup?.call(renderItems)
//                     : widget.onRestartAtFirstGroup,
//             backExtra: backExtra,
//             branchIndex: widget.branchIndex,
//             detailRoute: widget.detailRoute,
//             curatedFlashcards: curatedFlashcards, // ✅ same UX, JSON-fed
//           ),
//     );
//   }

//   String _pluralize(String word) => word.endsWith('s') ? word : '${word}s';
// }

// // // lib/widgets/navigation/last_group_button.dart

// // import 'package:flutter/material.dart';

// // import 'package:bcc5/theme/app_theme.dart';
// // import 'package:bcc5/theme/slide_direction.dart';
// // import 'package:bcc5/theme/transition_type.dart';
// // import 'package:bcc5/utils/logger.dart';
// // import 'package:bcc5/utils/string_extensions.dart';

// // import 'package:bcc5/data/models/render_item.dart';
// // import 'package:bcc5/navigation/detail_route.dart';
// // import 'package:bcc5/widgets/end_of_group_modal.dart';

// // // ✅ JSON-backed repos
// // import 'package:bcc5/data/repositories/paths/json_path_repository.dart';
// // import 'package:bcc5/data/repositories/flashcards/json_flashcard_repository.dart';

// // // ✅ Your curated mapping (IDs per chapter) — keep for now
// // import 'package:bcc5/data/repositories/flashcards/competent_crew_flashards.dart';

// // class LastGroupButton extends StatefulWidget {
// //   final RenderItemType type;
// //   final DetailRoute detailRoute;
// //   final Map<String, dynamic>? backExtra;
// //   final int branchIndex;
// //   final String backDestination;
// //   final String label;

// //   /// Parent supplies “what’s next” items (already JSON-only upstream).
// //   final Future<List<RenderItem>?> Function() getNextRenderItems;

// //   /// Parent performs navigation to next group.
// //   final void Function(List<RenderItem> renderItems)? onNavigateToNextGroup;

// //   /// Parent restarts at the first group.
// //   final VoidCallback? onRestartAtFirstGroup;

// //   const LastGroupButton({
// //     super.key,
// //     required this.type,
// //     required this.detailRoute,
// //     required this.backExtra,
// //     required this.branchIndex,
// //     required this.backDestination,
// //     required this.label,
// //     required this.getNextRenderItems,
// //     this.onNavigateToNextGroup,
// //     this.onRestartAtFirstGroup,
// //   });

// //   @override
// //   State<LastGroupButton> createState() => _LastGroupButtonState();
// // }

// // class _LastGroupButtonState extends State<LastGroupButton> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return ElevatedButton(
// //       onPressed: () async {
// //         logger.i('⏭️ LastGroupButton tapped (${widget.label})');

// //         // Capture BEFORE awaits and use BuildContext.mounted to guard later.
// //         final localContext = context;

// //         final isPath = widget.detailRoute == DetailRoute.path;
// //         final pathName = widget.backExtra?['pathName'] as String?;
// //         final chapterId = widget.backExtra?['chapterId'] as String?;

// //         // 1) Ask parent for the next group’s render items (JSON-only upstream).
// //         final nextRenderItems = await widget.getNextRenderItems();

// //         // 2) Curated flashcards (if any) using JSON repo by IDs.
// //         final curated = <RenderItem>[];
// //         if (isPath && chapterId != null) {
// //           final curatedIds = curatedChapterFlashcards[chapterId];
// //           if (curatedIds != null && curatedIds.isNotEmpty) {
// //             final curatedCards =
// //                 await JsonFlashcardRepository.getFlashcardsByIds(curatedIds);
// //             curated.addAll(curatedCards.map(RenderItem.fromFlashcard));
// //           }
// //         }

// //         // 3) Determine if a *next chapter* exists via JSON repo (no legacy).
// //         bool hasNextChapter = false;
// //         if (isPath && pathName != null && chapterId != null) {
// //           final nextChapter = await JsonPathRepository.getNextChapter(
// //             pathName,
// //             chapterId,
// //           );
// //           hasNextChapter = nextChapter != null;
// //         }

// //         // ✅ Guard the exact BuildContext we’re about to use after awaits.
// //         if (!localContext.mounted) return;

// //         _showEndOfGroupModal(
// //           context: localContext,
// //           renderItems: nextRenderItems ?? const <RenderItem>[],
// //           curatedFlashcards: curated,
// //           isPath: isPath,
// //           pathName: pathName,
// //           chapterId: chapterId,
// //           hasNextChapter: hasNextChapter,
// //         );
// //       },
// //       style: AppTheme.navigationButton,
// //       child: Text('Next ${widget.label.toTitleCase()}'),
// //     );
// //   }

// //   void _showEndOfGroupModal({
// //     required BuildContext context,
// //     required List<RenderItem> renderItems,
// //     required List<RenderItem> curatedFlashcards,
// //     required bool isPath,
// //     required String? pathName,
// //     required String? chapterId,
// //     required bool hasNextChapter, // ← JSON-driven result
// //   }) {
// //     final hasNextGroup = renderItems.isNotEmpty;

// //     final backRoute =
// //         isPath
// //             ? (hasNextChapter
// //                 ? '/learning-paths/${pathName!.toLowerCase().replaceAll(' ', '-')}'
// //                 : '/')
// //             : widget.backDestination;

// //     final backLabel =
// //         isPath
// //             ? (hasNextChapter
// //                 ? 'Back to ${pathName!.toTitleCase()} Chapters'
// //                 : '🎉 Congrats! Return to Home')
// //             : 'Back to ${_pluralize(widget.label.toTitleCase())}';

// //     final forwardLabel =
// //         isPath
// //             ? (hasNextChapter
// //                 ? 'Next ${pathName!.toTitleCase()} Chapter'
// //                 : 'Restart ${pathName!.toTitleCase()}')
// //             : (hasNextGroup
// //                 ? 'Next ${widget.label.toTitleCase()}'
// //                 : 'Start Over at Beginning');

// //     final backExtra = {
// //       if (isPath && pathName != null) 'pathName': pathName,
// //       if (isPath && hasNextChapter) 'chapterId': chapterId,
// //       if (!isPath && widget.backExtra != null) ...widget.backExtra!,
// //       'branchIndex': widget.branchIndex,
// //       'transitionKey': UniqueKey().toString(),
// //       'slideFrom': SlideDirection.left,
// //       'transitionType': TransitionType.slide,
// //       'detailRoute': widget.detailRoute,
// //     };

// //     showModalBottomSheet(
// //       context: context,
// //       showDragHandle: true,
// //       builder:
// //           (_) => EndOfGroupModal(
// //             title:
// //                 (hasNextChapter || hasNextGroup)
// //                     ? '📘 End of this ${widget.label}'
// //                     : '🎉 You’ve completed all ${_pluralize(widget.label)}!',
// //             message:
// //                 (hasNextChapter || hasNextGroup)
// //                     ? 'Nice job! Would you like to return to the main list or begin the next ${widget.label}?'
// //                     : 'You’ve completed the full path! Return to home or restart the first ${widget.label}.',
// //             backButtonLabel: backLabel,
// //             backRoute: backRoute,
// //             forwardButtonLabel: forwardLabel,
// //             onNextGroup:
// //                 (hasNextChapter || hasNextGroup)
// //                     ? () => widget.onNavigateToNextGroup?.call(renderItems)
// //                     : widget.onRestartAtFirstGroup,
// //             backExtra: backExtra,
// //             branchIndex: widget.branchIndex,
// //             detailRoute: widget.detailRoute,
// //             curatedFlashcards: curatedFlashcards, // ✅ same UX, JSON-fed
// //           ),
// //     );
// //   }

// //   String _pluralize(String word) => word.endsWith('s') ? word : '${word}s';
// // }

// // // // lib/widgets/navigation/last_group_button.dart

// // // import 'package:flutter/material.dart';

// // // import 'package:bcc5/theme/app_theme.dart';
// // // import 'package:bcc5/theme/slide_direction.dart';
// // // import 'package:bcc5/theme/transition_type.dart';
// // // import 'package:bcc5/utils/logger.dart';
// // // import 'package:bcc5/utils/string_extensions.dart';

// // // import 'package:bcc5/data/models/render_item.dart';
// // // import 'package:bcc5/navigation/detail_route.dart';
// // // import 'package:bcc5/widgets/end_of_group_modal.dart';

// // // import 'package:bcc5/data/repositories/paths/path_repository_index.dart';

// // // // ✅ JSON-backed flashcards
// // // import 'package:bcc5/data/repositories/flashcards/json_flashcard_repository.dart';

// // // // ✅ Your curated mapping (IDs per chapter)
// // // import 'package:bcc5/data/repositories/flashcards/competent_crew_flashards.dart';

// // // class LastGroupButton extends StatefulWidget {
// // //   final RenderItemType type;
// // //   final DetailRoute detailRoute;
// // //   final Map<String, dynamic>? backExtra;
// // //   final int branchIndex;
// // //   final String backDestination;
// // //   final String label;

// // //   /// Parent supplies “what’s next” (already JSON-only in your Detail screen).
// // //   final Future<List<RenderItem>?> Function() getNextRenderItems;

// // //   /// Parent performs navigation to next group.
// // //   final void Function(List<RenderItem> renderItems)? onNavigateToNextGroup;

// // //   /// Parent restarts at the first group.
// // //   final VoidCallback? onRestartAtFirstGroup;

// // //   const LastGroupButton({
// // //     super.key,
// // //     required this.type,
// // //     required this.detailRoute,
// // //     required this.backExtra,
// // //     required this.branchIndex,
// // //     required this.backDestination,
// // //     required this.label,
// // //     required this.getNextRenderItems,
// // //     this.onNavigateToNextGroup,
// // //     this.onRestartAtFirstGroup,
// // //   });

// // //   @override
// // //   State<LastGroupButton> createState() => _LastGroupButtonState();
// // // }

// // // class _LastGroupButtonState extends State<LastGroupButton> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return ElevatedButton(
// // //       onPressed: () async {
// // //         logger.i('⏭️ LastGroupButton tapped (${widget.label})');

// // //         final localContext = context; // ✅ capture BEFORE awaits

// // //         final isPath = widget.detailRoute == DetailRoute.path;
// // //         final pathName = widget.backExtra?['pathName'] as String?;
// // //         final chapterId = widget.backExtra?['chapterId'] as String?;

// // //         // 1) Ask parent for the next group’s render items (JSON-only upstream).
// // //         final nextRenderItems = await widget.getNextRenderItems();

// // //         // 2) Build curated flashcards (if any) using JSON repo by IDs.
// // //         final curated = <RenderItem>[];
// // //         if (isPath && chapterId != null) {
// // //           final curatedIds = curatedChapterFlashcards[chapterId];
// // //           if (curatedIds != null && curatedIds.isNotEmpty) {
// // //             final curatedCards =
// // //                 await JsonFlashcardRepository.getFlashcardsByIds(curatedIds);
// // //             curated.addAll(curatedCards.map(RenderItem.fromFlashcard));
// // //           }
// // //         }

// // //         // ✅ Guard the exact BuildContext we’re about to use
// // //         if (!localContext.mounted) return;

// // //         _showEndOfGroupModal(
// // //           context: localContext,
// // //           renderItems: nextRenderItems ?? const <RenderItem>[],
// // //           curatedFlashcards: curated,
// // //           isPath: isPath,
// // //           pathName: pathName,
// // //           chapterId: chapterId,
// // //         );
// // //       },
// // //       style: AppTheme.navigationButton,
// // //       child: Text('Next ${widget.label.toTitleCase()}'),
// // //     );
// // //   }

// // //   void _showEndOfGroupModal({
// // //     required BuildContext context,
// // //     required List<RenderItem> renderItems,
// // //     required List<RenderItem> curatedFlashcards,
// // //     required bool isPath,
// // //     required String? pathName,
// // //     required String? chapterId,
// // //   }) {
// // //     final nextChapter =
// // //         (isPath && pathName != null && chapterId != null)
// // //             ? PathRepositoryIndex.getNextChapter(pathName, chapterId)
// // //             : null;

// // //     final hasNextGroup = renderItems.isNotEmpty;

// // //     final backRoute =
// // //         isPath
// // //             ? (nextChapter != null
// // //                 ? '/learning-paths/${pathName!.toLowerCase().replaceAll(' ', '-')}'
// // //                 : '/')
// // //             : widget.backDestination;

// // //     final backLabel =
// // //         isPath
// // //             ? (nextChapter != null
// // //                 ? 'Back to ${pathName!.toTitleCase()} Chapters'
// // //                 : '🎉 Congrats! Return to Home')
// // //             : 'Back to ${_pluralize(widget.label.toTitleCase())}';

// // //     final forwardLabel =
// // //         isPath
// // //             ? (nextChapter != null
// // //                 ? 'Next ${pathName!.toTitleCase()} Chapter'
// // //                 : 'Restart ${pathName!.toTitleCase()}')
// // //             : (hasNextGroup
// // //                 ? 'Next ${widget.label.toTitleCase()}'
// // //                 : 'Start Over at Beginning');

// // //     final backExtra = {
// // //       if (isPath && pathName != null) 'pathName': pathName,
// // //       if (isPath && nextChapter != null) 'chapterId': chapterId,
// // //       if (!isPath && widget.backExtra != null) ...widget.backExtra!,
// // //       'branchIndex': widget.branchIndex,
// // //       'transitionKey': UniqueKey().toString(),
// // //       'slideFrom': SlideDirection.left,
// // //       'transitionType': TransitionType.slide,
// // //       'detailRoute': widget.detailRoute,
// // //     };

// // //     showModalBottomSheet(
// // //       context: context,
// // //       showDragHandle: true,
// // //       builder:
// // //           (_) => EndOfGroupModal(
// // //             title:
// // //                 (nextChapter != null || hasNextGroup)
// // //                     ? '📘 End of this ${widget.label}'
// // //                     : '🎉 You’ve completed all ${_pluralize(widget.label)}!',
// // //             message:
// // //                 (nextChapter != null || hasNextGroup)
// // //                     ? 'Nice job! Would you like to return to the main list or begin the next ${widget.label}?'
// // //                     : 'You’ve completed the full path! Return to home or restart the first ${widget.label}.',
// // //             backButtonLabel: backLabel,
// // //             backRoute: backRoute,
// // //             forwardButtonLabel: forwardLabel,
// // //             onNextGroup:
// // //                 (nextChapter != null || hasNextGroup)
// // //                     ? () => widget.onNavigateToNextGroup?.call(renderItems)
// // //                     : widget.onRestartAtFirstGroup,
// // //             backExtra: backExtra,
// // //             branchIndex: widget.branchIndex,
// // //             detailRoute: widget.detailRoute,
// // //             curatedFlashcards: curatedFlashcards, // ✅ same UX, JSON-fed
// // //           ),
// // //     );
// // //   }

// // //   String _pluralize(String word) => word.endsWith('s') ? word : '${word}s';
// // // }

// // // // // lib/widgets/navigation/last_group_button.dart

// // // // import 'package:bcc5/data/repositories/flashcards/competent_crew_flashards.dart';
// // // // import 'package:bcc5/data/repositories/flashcards/flashcard_repository_index.dart';
// // // // import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
// // // // import 'package:bcc5/theme/slide_direction.dart';
// // // // import 'package:bcc5/theme/transition_type.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:bcc5/theme/app_theme.dart';
// // // // import 'package:bcc5/utils/logger.dart';
// // // // import 'package:bcc5/utils/string_extensions.dart';
// // // // import 'package:bcc5/data/models/render_item.dart';
// // // // import 'package:bcc5/navigation/detail_route.dart';
// // // // import 'package:bcc5/widgets/end_of_group_modal.dart';

// // // // class LastGroupButton extends StatefulWidget {
// // // //   final RenderItemType type;
// // // //   final DetailRoute detailRoute;
// // // //   final Map<String, dynamic>? backExtra;
// // // //   final int branchIndex;
// // // //   final String backDestination;
// // // //   final String label;
// // // //   final Future<List<RenderItem>?> Function() getNextRenderItems;
// // // //   final void Function(List<RenderItem> renderItems)? onNavigateToNextGroup;
// // // //   final VoidCallback? onRestartAtFirstGroup;

// // // //   const LastGroupButton({
// // // //     super.key,
// // // //     required this.type,
// // // //     required this.detailRoute,
// // // //     required this.backExtra,
// // // //     required this.branchIndex,
// // // //     required this.backDestination,
// // // //     required this.label,
// // // //     required this.getNextRenderItems,
// // // //     this.onNavigateToNextGroup,
// // // //     this.onRestartAtFirstGroup,
// // // //   });

// // // //   @override
// // // //   State<LastGroupButton> createState() => _LastGroupButtonState();
// // // // }

// // // // class _LastGroupButtonState extends State<LastGroupButton> {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return ElevatedButton(
// // // //       onPressed: () async {
// // // //         final isPath = widget.detailRoute == DetailRoute.path;
// // // //         final pathName = widget.backExtra?['pathName'] as String?;
// // // //         final chapterId = widget.backExtra?['chapterId'] as String?;
// // // //         logger.i('⏭️ LastGroupButton tapped (${widget.label})');

// // // //         final renderItems = await widget.getNextRenderItems();

// // // //         WidgetsBinding.instance.addPostFrameCallback((_) {
// // // //           if (!mounted) return;

// // // //           final curatedFlashcards = <RenderItem>[];
// // // //           if (isPath && pathName != null && chapterId != null) {
// // // //             final curatedIds = curatedChapterFlashcards[chapterId];
// // // //             if (curatedIds != null && curatedIds.isNotEmpty) {
// // // //               curatedFlashcards.addAll(
// // // //                 curatedIds
// // // //                     .map(
// // // //                       (id) => getAllFlashcards().firstWhere((f) => f.id == id),
// // // //                     )
// // // //                     .map(RenderItem.fromFlashcard),
// // // //               );
// // // //             }
// // // //           }

// // // //           _showEndOfGroupModal(
// // // //             context,
// // // //             renderItems ?? [],
// // // //             curatedFlashcards,
// // // //             isPath,
// // // //             pathName,
// // // //             chapterId,
// // // //           );
// // // //         });
// // // //       },
// // // //       style: AppTheme.navigationButton,
// // // //       child: Text('Next ${widget.label.toTitleCase()}'),
// // // //     );
// // // //   }

// // // //   void _showEndOfGroupModal(
// // // //     BuildContext context,
// // // //     List<RenderItem> renderItems,
// // // //     List<RenderItem> curatedFlashcards,
// // // //     bool isPath,
// // // //     String? pathName,
// // // //     String? chapterId,
// // // //   ) {
// // // //     final nextChapter =
// // // //         (isPath && pathName != null && chapterId != null)
// // // //             ? PathRepositoryIndex.getNextChapter(pathName, chapterId)
// // // //             : null;

// // // //     final hasNextGroup = renderItems.isNotEmpty;

// // // //     final backRoute =
// // // //         isPath
// // // //             ? (nextChapter != null
// // // //                 ? '/learning-paths/${pathName!.toLowerCase().replaceAll(' ', '-')}'
// // // //                 : '/')
// // // //             : widget.backDestination;

// // // //     final backLabel =
// // // //         isPath
// // // //             ? (nextChapter != null
// // // //                 ? 'Back to ${pathName!.toTitleCase()} Chapters'
// // // //                 : '🎉 Congrats! Return to Home')
// // // //             : 'Back to ${_pluralize(widget.label.toTitleCase())}';

// // // //     final forwardLabel =
// // // //         isPath
// // // //             ? (nextChapter != null
// // // //                 ? 'Next ${pathName!.toTitleCase()} Chapter'
// // // //                 : 'Restart ${pathName!.toTitleCase()}')
// // // //             : (hasNextGroup
// // // //                 ? 'Next ${widget.label.toTitleCase()}'
// // // //                 : 'Start Over at Beginning');

// // // //     final backExtra = {
// // // //       if (isPath && pathName != null) 'pathName': pathName,
// // // //       if (isPath && nextChapter != null) 'chapterId': chapterId,
// // // //       if (!isPath && widget.backExtra != null) ...widget.backExtra!,
// // // //       'branchIndex': widget.branchIndex,
// // // //       'transitionKey': UniqueKey().toString(),
// // // //       'slideFrom': SlideDirection.left,
// // // //       'transitionType': TransitionType.slide,
// // // //       'detailRoute': widget.detailRoute,
// // // //     };

// // // //     showModalBottomSheet(
// // // //       context: context,
// // // //       showDragHandle: true,
// // // //       builder:
// // // //           (_) => EndOfGroupModal(
// // // //             title:
// // // //                 nextChapter != null || hasNextGroup
// // // //                     ? '📘 End of this ${widget.label}'
// // // //                     : '🎉 You’ve completed all ${_pluralize(widget.label)}!',
// // // //             message:
// // // //                 nextChapter != null || hasNextGroup
// // // //                     ? 'Nice job! Would you like to return to the main list or begin the next ${widget.label}?'
// // // //                     : 'You’ve completed the full path! Return to home or restart the first ${widget.label}.',
// // // //             backButtonLabel: backLabel,
// // // //             backRoute: backRoute,
// // // //             forwardButtonLabel: forwardLabel,
// // // //             onNextGroup:
// // // //                 (nextChapter != null || hasNextGroup)
// // // //                     ? () => widget.onNavigateToNextGroup?.call(renderItems)
// // // //                     : widget.onRestartAtFirstGroup,
// // // //             backExtra: backExtra,
// // // //             branchIndex: widget.branchIndex,
// // // //             detailRoute: widget.detailRoute,
// // // //             curatedFlashcards: curatedFlashcards, // ✅ add this correctly here
// // // //           ),
// // // //     );
// // // //   }

// // // //   // String _normalizeToTopLevelRoute(String route) {
// // // //   //   if (route.startsWith('/learning-paths') && route.contains('/items')) {
// // // //   //     return route.replaceAll('/items', '');
// // // //   //   }
// // // //   //   if (route.endsWith('/items')) {
// // // //   //     return route.replaceAll('/items', '');
// // // //   //   }
// // // //   //   return route;
// // // //   // }

// // // //   String _pluralize(String word) => word.endsWith('s') ? word : '${word}s';
// // // // }
