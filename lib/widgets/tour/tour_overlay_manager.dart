// lib/widgets/tour/tour_overlay_manager.dart

import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/tour/tour_overlay_controls.dart'; // ✅ updated import
import 'package:flutter/material.dart';

class TourOverlayManager extends StatefulWidget {
  final GlobalKey? highlightKey;
  final String? description;
  final VoidCallback onNext;
  final VoidCallback onEnd;
  final VoidCallback onReset;
  final Widget child;
  final String? currentStepId;

  const TourOverlayManager({
    super.key,
    required this.highlightKey,
    required this.description,
    required this.onNext,
    required this.onEnd,
    required this.onReset,
    required this.child,
    required this.currentStepId,
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
      final bubbleHeightEstimate = 140.0;
      final availableSpaceBelow = mediaHeight - (position!.dy + size!.height);

      showBubbleAbove =
          availableSpaceBelow < bubbleHeightEstimate ||
          _isAdvancedRefreshersStep();
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
          // Description bubble + controls
          Positioned(
            left: 24,
            right: 24,
            top:
                showBubbleAbove
                    ? position!.dy - 220
                    : position!.dy + size!.height + 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                TourOverlayControls(onNext: widget.onNext, onEnd: widget.onEnd),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
