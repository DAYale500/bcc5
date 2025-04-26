// lib/widgets/tour/tour_overlay_controls.dart

import 'package:bcc5/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TourOverlayControls extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onEnd;

  const TourOverlayControls({
    super.key,
    required this.onNext,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: AppTheme.tourNextButton,
          onPressed: onNext,
          child: const Text('Next'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          style: AppTheme.tourExitButton,
          onPressed: onEnd,
          child: const Text('Exit'),
        ),
      ],
    );
  }
}
