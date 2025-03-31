// 📄 lib/widgets/navigation_buttons.dart

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Padding(
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
                  style:
                      isPreviousEnabled
                          ? AppTheme.navigationButton
                          : AppTheme.disabledNavigationButton,
                ),
              ),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: isNextEnabled ? onNext : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  style:
                      isNextEnabled
                          ? AppTheme.navigationButton
                          : AppTheme.disabledNavigationButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
