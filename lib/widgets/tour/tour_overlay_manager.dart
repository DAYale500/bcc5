import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/tour/tour_overlay_footer.dart';
import 'package:flutter/material.dart';

class TourOverlayManager extends StatefulWidget {
  final GlobalKey? highlightKey;
  final String? description;
  final VoidCallback onNext;
  final VoidCallback onEnd;
  final VoidCallback onReset;
  final Widget child;

  const TourOverlayManager({
    super.key,
    required this.highlightKey,
    required this.description,
    required this.onNext,
    required this.onEnd,
    required this.onReset,
    required this.child,
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || widget.highlightKey == null) return;

      final context = widget.highlightKey!.currentContext;
      if (context == null) {
        logger.w('❌ Highlight key context is null — skipping.');
        return;
      }

      try {
        // ⛵ Scroll into view to ensure layout/rendering
        await Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          alignment: 0.5,
          curve: Curves.easeInOut,
        );
      } catch (e) {
        logger.w('⚠️ ensureVisible failed: $e');
      }

      final renderBox = context.findRenderObject() as RenderBox?;
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

    final double padding =
        (size != null && (size!.width < 30 || size!.height < 30)) ? 16.0 : 8.0;

    return Stack(
      children: [
        widget.child,
        if (position != null && size != null) ...[
          // Dimmed background
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onNext,
              child: Container(color: Colors.black54),
            ),
          ),
          // Highlight box
          Positioned(
            left: position!.dx - padding,
            top: position!.dy - padding,
            width: size!.width + (2 * padding),
            height: size!.height + (2 * padding),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellowAccent, width: 3),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Description + Next
          Positioned(
            top: position!.dy + size!.height + padding + 16,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.description ?? '',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: widget.onNext,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
          // Footer controls
          TourOverlayFooter(
            onEnd: () {
              logger.i('🛑 TourOverlayManager received close request');
              widget.onEnd();
              setState(() {
                position = null;
                size = null;
              });
            },
            onReset: widget.onReset,
          ),
        ],
      ],
    );
  }
}

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

//       final context = widget.highlightKey?.currentContext;
//       if (context == null) {
//         logger.w('❌ Highlight key context is null — skipping.');
//         return;
//       }

//       final renderBox = context.findRenderObject() as RenderBox?;
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

//     return Stack(
//       children: [
//         widget.child,
//         if (position != null && size != null) ...[
//           // Dimmed background
//           Positioned.fill(
//             child: GestureDetector(
//               onTap: widget.onNext,
//               child: Container(color: Colors.black54),
//             ),
//           ),
//           // Highlight box
//           Positioned(
//             left: position!.dx - 8,
//             top: position!.dy - 8,
//             width: size!.width + 16,
//             height: size!.height + 16,
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.yellowAccent, width: 3),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//           // Description bubble
//           Positioned(
//             top: position!.dy + size!.height + 24,
//             left: 24,
//             right: 24,
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     widget.description ?? '',
//                     style: const TextStyle(fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton(
//                   onPressed: widget.onNext,
//                   child: const Text('Next'),
//                 ),
//               ],
//             ),
//           ),
//           // Footer
//           TourOverlayFooter(
//             onEnd: () {
//               logger.i('🛑 TourOverlayManager received close request');
//               widget.onEnd();
//               setState(() {
//                 position = null;
//                 size = null;
//               });
//             },
//           ),
//         ],
//       ],
//     );
//   }
// }
