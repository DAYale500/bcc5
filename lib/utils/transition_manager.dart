import 'dart:ui';

import 'package:bcc5/theme/transition_type.dart';
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
    required ValueKey<String> transitionKey,
    required Widget child,
    SlideDirection slideFrom = SlideDirection.none,
    TransitionType transitionType = TransitionType.instant,
  }) {
    final extra = state.extra;

    final detailRoute =
        extra is Map<String, dynamic> && extra['detailRoute'] is DetailRoute
            ? extra['detailRoute'] as DetailRoute
            : (() {
              logger.w(
                '[TransitionManager] ❗ Missing detailRoute in .extra — defaulting to DetailRoute.branch',
              );
              return DetailRoute.branch;
            })();

    final effectiveSlideFrom =
        extra is Map<String, dynamic> && extra['slideFrom'] is SlideDirection
            ? extra['slideFrom'] as SlideDirection
            : slideFrom;

    final effectiveTransitionType =
        extra is Map<String, dynamic> &&
                extra['transitionType'] is TransitionType
            ? extra['transitionType'] as TransitionType
            : transitionType;

    logger.i(
      '[TransitionManager] buildCustomTransition → '
      'detailRoute: $detailRoute | transitionType: $effectiveTransitionType | slideFrom: $effectiveSlideFrom',
    );

    // ✅ Add these additional transitions into your transitionsBuilder

    return CustomTransitionPage(
      key: transitionKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (effectiveTransitionType) {
          case TransitionType.instant:
            return buildInstantTransition(child);

          case TransitionType.slide:
            return buildSlideTransition(child, animation, effectiveSlideFrom);

          case TransitionType.fade:
            return FadeTransition(opacity: animation, child: child);

          case TransitionType.scale:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
              child: child,
            );

          case TransitionType.fadeScale:
            return buildScaleFadeTransition(
              child,
              animation,
              secondaryAnimation,
            );

          case TransitionType.rotation:
            return RotationTransition(turns: animation, child: child);

          case TransitionType.slideUp:
            return buildSlideTransition(child, animation, SlideDirection.up);

          case TransitionType.slideDown:
            return buildSlideTransition(child, animation, SlideDirection.down);

          case TransitionType.slideLeft:
            return buildSlideTransition(child, animation, SlideDirection.left);

          case TransitionType.slideRight:
            return buildSlideTransition(child, animation, SlideDirection.right);

          case TransitionType.zoomIn:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            );

          case TransitionType.zoomOut:
            return ScaleTransition(
              scale: Tween<double>(begin: 2.0, end: 1.0).animate(animation),
              child: child,
            );

          case TransitionType.blurFade:
            return FadeTransition(
              opacity: animation,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: child,
              ),
            );

          // You can fill in these with actual animations later
          case TransitionType.morph:
          case TransitionType.carousel:
          case TransitionType.sharedAxis:
          case TransitionType.ripple:
          case TransitionType.delayFade:
          case TransitionType.staggered:
          case TransitionType.cube:
          case TransitionType.flip:
          case TransitionType.slide3D:
            logger.w(
              '[TransitionManager] Transition type not yet implemented: $effectiveTransitionType',
            );
            return child;
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
