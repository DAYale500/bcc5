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

  /// Route-level transition builder for GoRouter `pageBuilder`
  static CustomTransitionPage buildCustomTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    final extra = state.extra;
    final detailRoute =
        extra is Map<String, dynamic> && extra['detailRoute'] is DetailRoute
            ? extra['detailRoute'] as DetailRoute
            : DetailRoute.branch;

    final slideFrom =
        extra is Map<String, dynamic> && extra['slideFrom'] is SlideDirection
            ? extra['slideFrom'] as SlideDirection
            : SlideDirection.none;

    logger.i(
      '[TransitionManager] buildCustomTransition → '
      'detailRoute: $detailRoute | slideFrom: $slideFrom',
    );

    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (detailRoute) {
          case DetailRoute.branch:
          case DetailRoute.search:
            return buildInstantTransition(child);
          case DetailRoute.path:
            return buildSlideTransition(child, animation, slideFrom);
        }
      },
    );
  }
}

/// Used for in-group transitions (Next/Previous)
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

/// Used for instant appearance (default)
Widget buildInstantTransition(Widget child) {
  return child;
}

/// Used for initial entry into detail screen via path/search
Widget buildSlideTransition(
  Widget child,
  Animation<double> animation,
  SlideDirection direction,
) {
  late final Offset beginOffset;
  switch (direction) {
    case SlideDirection.right:
      beginOffset = const Offset(1.0, 0.0);
      break;
    case SlideDirection.left:
      beginOffset = const Offset(-1.0, 0.0);
      break;
    case SlideDirection.down:
      beginOffset = const Offset(0.0, 1.0);
      break;
    case SlideDirection.up:
      beginOffset = const Offset(0.0, -1.0);
      break;
    case SlideDirection.none:
      return child;
  }

  return SlideTransition(
    position: Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}
