import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';

class GroupButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const GroupButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isSelected
            ? AppTheme.groupButtonSelected
            : AppTheme.groupButtonUnselected;

    return FractionallySizedBox(
      widthFactor: 0.6,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: AppTheme.groupButtonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.buttonCornerRadius),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTheme.buttonTextStyle,
        ),
      ),
    );
  }
}
