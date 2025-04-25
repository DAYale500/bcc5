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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: onEnd,
                child: const Text('Close Tour'),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: onReset,
                child: const Text(
                  'Start tour from beginning',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
