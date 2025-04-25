import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/widgets/tour/tour_overlay_footer.dart';

class TourOverlayManager extends StatefulWidget {
  final GlobalKey? highlightKey;
  final String? description;
  final VoidCallback onNext;
  final VoidCallback onEnd;
  final VoidCallback? onReset;
  final Widget child;

  const TourOverlayManager({
    super.key,
    required this.highlightKey,
    required this.description,
    required this.onNext,
    required this.onEnd,
    this.onReset,
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
        Future.delayed(
          const Duration(milliseconds: 50),
          _resolveHighlightPosition,
        );
        return;
      }

      final newPosition = renderBox.localToGlobal(Offset.zero);
      final newSize = renderBox.size;

      if (newSize == Size.zero) {
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

    return Stack(
      children: [
        widget.child,
        if (position != null && size != null) ...[
          // Background
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onNext,
              child: Container(color: Colors.black54),
            ),
          ),
          // Highlight Box
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
          // Centered Description
          Positioned(
            top: position!.dy + size!.height + 12,
            left: MediaQuery.of(context).size.width / 2 - 140,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.description ?? '',
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ),
          // Lowered Next button
          Positioned(
            top: position!.dy + size!.height + 100,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: ElevatedButton(
              onPressed: widget.onNext,
              child: const Text('Next'),
            ),
          ),
          // Footer
          TourOverlayFooter(
            onEnd: widget.onEnd,
            onReset: widget.onReset ?? () {},
          ),
        ],
      ],
    );
  }
}
