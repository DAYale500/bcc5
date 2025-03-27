import 'package:flutter/material.dart';
import '../config/app_theme.dart';

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
            ? AppTheme.primaryBlue.withAlpha(229)
            : AppTheme.primaryBlue.withAlpha(153);

    return FractionallySizedBox(
      widthFactor: 0.6,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
