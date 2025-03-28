import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';

class DisabledItemButton extends StatelessWidget {
  final String label;

  const DisabledItemButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.itemButtonPadding,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(AppTheme.buttonCornerRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTheme.buttonTextStyle.copyWith(
          color: Colors.white.withAlpha(153), // ✅ No error
        ),
      ),
    );
  }
}
