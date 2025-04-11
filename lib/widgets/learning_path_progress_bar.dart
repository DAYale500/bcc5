import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';

class LearningPathProgressBar extends StatelessWidget {
  final String pathName;

  const LearningPathProgressBar({super.key, required this.pathName});

  @override
  Widget build(BuildContext context) {
    if (pathName.isEmpty) return const SizedBox.shrink();

    logger.i('🧭 LearningPathProgressBar: $pathName');

    return Container(
      width: double.infinity,
      color: Colors.red[50],
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: Text(
          pathName,
          style: AppTheme.scaledTextTheme.labelLarge?.copyWith(
            color: AppTheme.primaryRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
