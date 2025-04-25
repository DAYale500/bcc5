import 'package:flutter/material.dart';

class TourOverlayFooter extends StatelessWidget {
  final VoidCallback onEnd;
  final VoidCallback? onReset;

  const TourOverlayFooter({super.key, required this.onEnd, this.onReset});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Column(
        children: [
          ElevatedButton(onPressed: onEnd, child: const Text('Close Tour')),
          const SizedBox(height: 12),
          if (onReset != null)
            ElevatedButton(
              onPressed: onReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Start tour from beginning'),
            ),
        ],
      ),
    );
  }
}
