import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';

class NavigationButtons extends StatelessWidget {
  final bool isPreviousEnabled;
  final bool isNextEnabled;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NavigationButtons({
    super.key,
    required this.isPreviousEnabled,
    required this.isNextEnabled,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.white.withValues(
              alpha: 0.6,
            ), // subtle background tint
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: isPreviousEnabled ? onPrevious : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: AppTheme.navigationButton,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isNextEnabled ? onNext : null,
                    style: AppTheme.navigationButton,
                    child: Row(
                      children: const [
                        Text('Next'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
