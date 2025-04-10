import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';

class NavigationButtons extends StatefulWidget {
  final bool isPreviousEnabled;
  final bool isNextEnabled;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Widget? customNextButton;

  const NavigationButtons({
    super.key,
    required this.isPreviousEnabled,
    required this.isNextEnabled,
    required this.onPrevious,
    required this.onNext,
    this.customNextButton, // ✅ new
  });

  @override
  State<NavigationButtons> createState() => _NavigationButtonsState();
}

class _NavigationButtonsState extends State<NavigationButtons> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed:
                        widget.isPreviousEnabled ? widget.onPrevious : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: AppTheme.navigationButton,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child:
                      widget.customNextButton ??
                      ElevatedButton(
                        onPressed: widget.isNextEnabled ? widget.onNext : null,
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
