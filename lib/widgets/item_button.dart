import 'package:bcc5/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ItemButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const ItemButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppTheme.primaryRed, // 🟠 Default to red (DetailButton style)
    this.borderRadius = 12.0, // 🟠 Default rounded rectangle
    this.padding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 8,
    ), // 🟠 Default compact padding
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 🟠 Clean tap handler
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTheme.buttonTextStyle.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
