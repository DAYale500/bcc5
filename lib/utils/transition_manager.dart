import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/models/render_item.dart';
import '../navigation/detail_route.dart';
import '../theme/slide_direction.dart';

class TransitionManager {
  static void goToDetailScreen({
    required BuildContext context,
    required RenderItemType screenType,
    required List<RenderItem> renderItems,
    required int currentIndex,
    required int branchIndex,
    required String backDestination,
    required Map<String, dynamic>? backExtra,
    required DetailRoute detailRoute,
    SlideDirection direction = SlideDirection.none,
  }) {
    final route = _getRouteForScreenType(screenType);
    final transitionKey = UniqueKey().toString();

    logger.i(
      '[TransitionManager] goToDetailScreen → '
      'type: $screenType | route: $route | index: $currentIndex\n'
      '→ detailRoute: $detailRoute | direction: $direction\n'
      '→ backDestination: $backDestination | transitionKey: $transitionKey',
    );

    context.go(
      route,
      extra: {
        'renderItems': renderItems,
        'currentIndex': currentIndex,
        'branchIndex': branchIndex,
        'backDestination': backDestination,
        'backExtra': backExtra,
        'detailRoute': detailRoute,
        'transitionKey': transitionKey,
        'slideFrom': direction,
      },
    );
  }

  static String _getRouteForScreenType(RenderItemType type) {
    switch (type) {
      case RenderItemType.lesson:
        return '/lessons/detail';
      case RenderItemType.part:
        return '/parts/detail';
      case RenderItemType.tool:
        return '/tools/detail';
      case RenderItemType.flashcard:
        return '/flashcards/detail';
    }
  }
}

Widget buildScaleFadeTransition(
  Widget child,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
) {
  return ScaleTransition(
    scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
    child: FadeTransition(opacity: animation, child: child),
  );
}
