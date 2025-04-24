import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/theme/app_theme.dart';

class EndOfGroupModal extends StatelessWidget {
  final String title;
  final String message;
  final String backButtonLabel;
  final String backRoute;
  final String? forwardButtonLabel;
  final VoidCallback? onNextGroup;

  const EndOfGroupModal({
    super.key,
    required this.title,
    required this.message,
    required this.backButtonLabel,
    required this.backRoute,
    this.forwardButtonLabel,
    this.onNextGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(backRoute);
            },
            style: AppTheme.navigationButton,
            child: Text(backButtonLabel),
          ),
          if (onNextGroup != null && forwardButtonLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onNextGroup?.call();
                },
                style: AppTheme.navigationButton,
                child: Text(forwardButtonLabel!),
              ),
            ),
        ],
      ),
    );
  }
}
