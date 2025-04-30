// lib/widgets/tour/tour_overlay_manager.dart

// import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';

class TourOverlayManager extends StatefulWidget {
  final GlobalKey? highlightKey;
  final String? description;
  final VoidCallback onNext;
  final VoidCallback onEnd;
  final VoidCallback onReset;
  final Widget child;
  final String? currentStepId;
  final bool isLastStep;

  const TourOverlayManager({
    super.key,
    required this.highlightKey,
    required this.description,
    required this.onNext,
    required this.onEnd,
    required this.onReset,
    required this.child,
    required this.currentStepId,
    required this.isLastStep,
  });

  @override
  State<TourOverlayManager> createState() => _TourOverlayManagerState();
}

class _TourOverlayManagerState extends State<TourOverlayManager> {
  Offset? position;
  Size? size;

  @override
  void initState() {
    super.initState();
    _resolveHighlightPosition();
  }

  @override
  void didUpdateWidget(TourOverlayManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resolveHighlightPosition();
  }

  void _resolveHighlightPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final highlightContext = widget.highlightKey?.currentContext;
      if (highlightContext == null) {
        logger.w('❌ Highlight key context is null — skipping.');
        return;
      }

      final renderBox = highlightContext.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        logger.w('❌ RenderBox is null — retrying...');
        Future.delayed(
          const Duration(milliseconds: 50),
          _resolveHighlightPosition,
        );
        return;
      }

      final newPosition = renderBox.localToGlobal(Offset.zero);
      final newSize = renderBox.size;

      if (newSize == Size.zero) {
        logger.w('❌ Size is zero — retrying...');
        Future.delayed(
          const Duration(milliseconds: 50),
          _resolveHighlightPosition,
        );
        return;
      }

      logger.i('📐 Resolved position=$newPosition size=$newSize');

      setState(() {
        position = newPosition;
        size = newSize;
      });
    });
  }

  bool _isAdvancedRefreshersStep() =>
      widget.currentStepId == 'advancedRefreshers';

  bool _isLastStep() =>
      widget.highlightKey != null && widget.description == null;

  @override
  Widget build(BuildContext context) {
    logger.i(
      '🟡 TourOverlayManager build | highlightKey: ${widget.highlightKey}',
    );

    if (widget.highlightKey == null) {
      logger.i('🛑 TourOverlayManager skipped — highlightKey is null');

      if (position != null || size != null) {
        setState(() {
          position = null;
          size = null;
        });
      }

      return widget.child;
    }

    final mediaHeight = MediaQuery.of(context).size.height;

    bool showBubbleAbove = false;
    if (position != null && size != null) {
      final bubbleHeightEstimate = 200.0;
      final availableSpaceBelow = mediaHeight - (position!.dy + size!.height);

      showBubbleAbove =
          availableSpaceBelow < bubbleHeightEstimate ||
          _isAdvancedRefreshersStep();
    }

    return Stack(
      children: [
        widget.child,
        if (position != null && size != null) ...[
          // Dim background except highlight area
          Positioned.fill(
            child: Stack(
              children: [
                Container(color: Colors.black54),
                Positioned(
                  left: position!.dx - 8,
                  top: position!.dy - 8,
                  width: size!.width + 16,
                  height: size!.height + 16,
                  child: IgnorePointer(
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),

          // Highlight box
          Positioned(
            left: position!.dx - 6,
            top: position!.dy - 6,
            width: size!.width + 12,
            height: size!.height + 12,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.yellowAccent.shade700,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Tap-to-advance description bubble
          Positioned(
            left: 24,
            right: 24,
            top:
                showBubbleAbove
                    ? position!.dy - 220
                    : position!.dy + size!.height + 24,
            child: GestureDetector(
              onTap: () {
                if (_isLastStep()) {
                  widget.onEnd();
                } else {
                  widget.onNext();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.description ??
                      'Tap to continue the tour or close this bubble.',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// // lib/widgets/tour/tour_overlay_manager.dart

// import 'package:bcc5/theme/app_theme.dart';
// import 'package:bcc5/utils/logger.dart';
// import 'package:flutter/material.dart';

// class TourOverlayManager extends StatefulWidget {
//   final GlobalKey? highlightKey;
//   final String? description;
//   final VoidCallback onNext;
//   final VoidCallback onEnd;
//   final VoidCallback onReset;
//   final Widget child;
//   final String? currentStepId;

//   const TourOverlayManager({
//     super.key,
//     required this.highlightKey,
//     required this.description,
//     required this.onNext,
//     required this.onEnd,
//     required this.onReset,
//     required this.child,
//     required this.currentStepId,
//   });

//   @override
//   State<TourOverlayManager> createState() => _TourOverlayManagerState();
// }

// class _TourOverlayManagerState extends State<TourOverlayManager> {
//   Offset? position;
//   Size? size;

//   @override
//   void initState() {
//     super.initState();
//     _resolveHighlightPosition();
//   }

//   @override
//   void didUpdateWidget(TourOverlayManager oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _resolveHighlightPosition();
//   }

//   void _resolveHighlightPosition() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       final highlightContext = widget.highlightKey?.currentContext;
//       if (highlightContext == null) {
//         logger.w('❌ Highlight key context is null — skipping.');
//         return;
//       }

//       final renderBox = highlightContext.findRenderObject() as RenderBox?;
//       if (renderBox == null) {
//         logger.w('❌ RenderBox is null — retrying...');
//         Future.delayed(
//           const Duration(milliseconds: 50),
//           _resolveHighlightPosition,
//         );
//         return;
//       }

//       final newPosition = renderBox.localToGlobal(Offset.zero);
//       final newSize = renderBox.size;

//       if (newSize == Size.zero) {
//         logger.w('❌ Size is zero — retrying...');
//         Future.delayed(
//           const Duration(milliseconds: 50),
//           _resolveHighlightPosition,
//         );
//         return;
//       }

//       logger.i('📐 Resolved position=$newPosition size=$newSize');

//       setState(() {
//         position = newPosition;
//         size = newSize;
//       });
//     });
//   }

//   bool _isAdvancedRefreshersStep() =>
//       widget.currentStepId == 'advancedRefreshers';

//   @override
//   Widget build(BuildContext context) {
//     logger.i(
//       '🟡 TourOverlayManager build | highlightKey: ${widget.highlightKey}',
//     );

//     if (widget.highlightKey == null) {
//       logger.i('🛑 TourOverlayManager skipped — highlightKey is null');

//       if (position != null || size != null) {
//         setState(() {
//           position = null;
//           size = null;
//         });
//       }

//       return widget.child;
//     }

//     final mediaHeight = MediaQuery.of(context).size.height;

//     bool showBubbleAbove = false;
//     if (position != null && size != null) {
//       final bubbleHeightEstimate = 200.0;
//       final availableSpaceBelow = mediaHeight - (position!.dy + size!.height);

//       showBubbleAbove =
//           availableSpaceBelow < bubbleHeightEstimate ||
//           _isAdvancedRefreshersStep();
//     }

//     return Stack(
//       children: [
//         widget.child,
//         if (position != null && size != null) ...[
//           // Dimmed background
//           // 🆕 Smarter dimming — not inside yellow box
//           Positioned.fill(
//             child: Stack(
//               children: [
//                 Container(color: Colors.black54),
//                 if (position != null && size != null)
//                   Positioned(
//                     left: position!.dx - 8,
//                     top: position!.dy - 8,
//                     width: size!.width + 16,
//                     height: size!.height + 16,
//                     child: IgnorePointer(
//                       child: Container(color: Colors.transparent),
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           // Positioned.fill(
//           //   child: Container(color: Colors.black54),
//           // ),
//           // Highlight box
//           // 🆕 Nicer yellow border
//           Positioned(
//             left: position!.dx - 6,
//             top: position!.dy - 6,
//             width: size!.width + 12,
//             height: size!.height + 12,
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.yellowAccent.shade700,
//                   width: 4,
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),

//           // Positioned(
//           //   left: position!.dx - 8,
//           //   top: position!.dy - 8,
//           //   width: size!.width + 16,
//           //   height: size!.height + 16,
//           //   child: Container(
//           //     decoration: BoxDecoration(
//           //       border: Border.all(color: Colors.yellowAccent, width: 3),
//           //       borderRadius: BorderRadius.circular(8),
//           //     ),
//           //   ),
//           // ),
//           // Controls and Description
//           Positioned(
//             left: 24,
//             right: 24,
//             top:
//                 showBubbleAbove
//                     ? position!.dy - 220
//                     : position!.dy + size!.height + 24,
//             child: IntrinsicHeight(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                         style: AppTheme.tourNextButtonSmall,
//                         onPressed: widget.onNext,
//                         child: const Text('Next'),
//                       ),
//                       ElevatedButton(
//                         style: AppTheme.tourExitButtonSmall,
//                         onPressed: widget.onEnd,
//                         child: const Text('Exit'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         widget.description ?? '',
//                         style: const TextStyle(fontSize: 16),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }
