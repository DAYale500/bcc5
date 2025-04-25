import 'package:flutter/material.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/tour/tour_overlay_footer.dart';

class TourOverlayManager extends StatefulWidget {
  final GlobalKey? highlightKey;
  final VoidCallback onNext;
  final VoidCallback onEnd;
  final Widget child;

  const TourOverlayManager({
    super.key,
    required this.highlightKey,
    required this.onNext,
    required this.onEnd,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final context = widget.highlightKey?.currentContext;
      if (context == null) {
        logger.w('❌ Highlight key context is null — skipping.');
        return;
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
      return widget.child;
    }

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
            left: position!.dx - 8,
            top: position!.dy - 8,
            width: size!.width + 16,
            height: size!.height + 16,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellowAccent, width: 3),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // "Next" button
          Positioned(
            top: position!.dy + size!.height + 24,
            left: position!.dx,
            child: ElevatedButton(
              onPressed: widget.onNext,
              child: const Text('Next'),
            ),
          ),
          // Footer with "Don't show again" and "Close Tour"
          TourOverlayFooter(
            onEnd: () {
              logger.i('🛑 TourOverlayManager received close request');
              widget.onEnd(); // Triggers tourController.endTour
              setState(() {
                position = null;
                size = null;
              });
            },
          ),
        ],
      ],
    );
  }
}
