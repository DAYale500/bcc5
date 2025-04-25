// lib/widgets/tour/tour_overlay_footer.dart

import 'package:flutter/material.dart';

class TourOverlayFooter extends StatelessWidget {
  final VoidCallback onEnd;
  final VoidCallback onReset;

  const TourOverlayFooter({
    super.key,
    required this.onEnd,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onEnd,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Close Tour'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Text('Restart Tour'),
          ),
        ],
      ),
    );
  }
}
