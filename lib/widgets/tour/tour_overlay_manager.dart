// lib/widgets/tour/tour_overlay_manager.dart

import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';

class TourOverlayManager extends StatelessWidget {
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
  Widget build(BuildContext context) {
    logger.i('🟡 TourOverlayManager build | highlightKey: $highlightKey');

    final renderBox =
        highlightKey?.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    final size = renderBox?.size;

    return Stack(
      children: [
        child, // ✅ Always render the main UI

        if (renderBox != null && position != null && size != null) ...[
          // Dark overlay background
          Positioned.fill(
            child: GestureDetector(
              onTap: onNext,
              child: Container(color: Colors.black54),
            ),
          ),

          // Highlight box
          Positioned(
            left: position.dx - 8,
            top: position.dy - 8,
            width: size.width + 16,
            height: size.height + 16,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellowAccent, width: 3),
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
              ),
            ),
          ),

          // Next/End buttons
          Positioned(
            top: position.dy + size.height + 24,
            left: position.dx,
            child: Row(
              children: [
                ElevatedButton(onPressed: onNext, child: const Text('Next')),
                const SizedBox(width: 8),
                TextButton(onPressed: onEnd, child: const Text('End Tour')),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
