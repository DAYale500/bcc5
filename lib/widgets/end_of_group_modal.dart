import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/theme/app_theme.dart';

class EndOfGroupModal extends StatelessWidget {
  final String title;
  final String message;
  final String backButtonLabel;
  final String backRoute;
  final Map<String, dynamic>? backExtra;
  final int branchIndex;
  final DetailRoute detailRoute;
  final String? forwardButtonLabel;
  final VoidCallback? onNextGroup;

  const EndOfGroupModal({
    super.key,
    required this.title,
    required this.message,
    required this.backButtonLabel,
    required this.backRoute,
    required this.backExtra,
    required this.branchIndex,
    required this.detailRoute,
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
          if (onNextGroup != null && forwardButtonLabel != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                // Next or Restart (TOP button)
                onPressed: () {
                  Navigator.of(context).pop();
                  onNextGroup?.call();
                },
                style: AppTheme.navigationButton,
                child: Text(forwardButtonLabel!),
              ),
            ),

          ElevatedButton(
            // Back to List (BOTTOM button)
            onPressed: () {
              Navigator.of(context).pop();
              context.go(
                backRoute,
                extra: {
                  if (backExtra?['zone'] != null) 'zone': backExtra!['zone'],
                  if (backExtra?['module'] != null)
                    'module': backExtra!['module'],
                  if (backExtra?['toolbag'] != null)
                    'toolbag': backExtra!['toolbag'],
                  if (backExtra?['category'] != null)
                    'category': backExtra!['category'],
                  if (backExtra?['chapterId'] != null)
                    'chapterId': backExtra!['chapterId'],
                  if (backExtra?['pathName'] != null)
                    'pathName': backExtra!['pathName'],
                  'branchIndex': branchIndex,
                  'transitionKey': UniqueKey().toString(),
                  'slideFrom': SlideDirection.left,
                  'transitionType': TransitionType.slide,
                  'detailRoute': detailRoute,
                },
              );
            },
            style: AppTheme.navigationButton,
            child: Text(backButtonLabel),
          ),
        ],
      ),
    );
  }
}
