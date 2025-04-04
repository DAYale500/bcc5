import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum TransitionDirection { forward, backward }

class TransitionManager {
  static void goToDetailScreen({
    required BuildContext context,
    required String route,
    required List<String> sequenceIds,
    required int currentIndex,
    required int branchIndex,
    required String backDestination,
    required Map<String, dynamic>? backExtra,
    required TransitionDirection direction,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    context.go(
      route,
      extra: {
        'renderItems': sequenceIds,
        'currentIndex': currentIndex,
        'branchIndex': branchIndex,
        'backDestination': backDestination,
        'backExtra': backExtra,
        'transitionKey': 'detail_${currentIndex}_$timestamp',
        'direction': direction.name,
      },
    );
  }
}
