// Relative path: lib/utils/navigation_transitions.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 🚀 NavigationContext
/// Defines different navigation scenarios to apply context-specific transitions.
enum NavigationContext {
  drillDown, // No transition when navigating deeper within a hierarchy.
  branchChange, // Slide from right when switching sections via BottomNavigationBar.
  settings, // Scale animation for the Settings screen.
  backNavigation, // Slide from left for back navigation.
  sameScreenNavigation, // No transition when using previous/next buttons.
  modalPresentation, // Slide from bottom for modal-like screens.
  fadeTransition, // Fade effect for subtle transitions.
  rotationTransition, // Rotates the screen during navigation (for creative effects).
  scaleFadeCombination, // Combines scale and fade for a smooth effect.
  noTransition, // Explicit no-animation navigation.
}

CustomTransitionPage<T> buildCustomTransition<T>({
  required Widget child,
  required NavigationContext contextType,
}) {
  // Curve used across most transitions for consistency
  const curve = Curves.easeInOut;

  /// 📚 Transition Builders
  /// Define the animation for each NavigationContext.
  Widget Function(
    BuildContext,
    Animation<double>,
    Animation<double>,
    Widget,
  ) transitionsBuilder;

  switch (contextType) {
    case NavigationContext.drillDown:
    case NavigationContext.sameScreenNavigation:
    case NavigationContext.noTransition:
      // 🚫 No animation (instant screen change)
      transitionsBuilder =
          (context, animation, secondaryAnimation, child) => child;
      break;

    case NavigationContext.branchChange:
      // ➡️ Slide from right (BottomNavigationBar branch changes)
      transitionsBuilder = (context, animation, _, child) {
        final tween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      };
      break;

    case NavigationContext.backNavigation:
      // ⬅️ Slide from left (back navigation)
      transitionsBuilder = (context, animation, _, child) {
        final tween =
            Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
                .chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      };
      break;

    case NavigationContext.settings:
      // 🔍 Scale transition (Settings screen)
      transitionsBuilder = (context, animation, _, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0)
              .chain(CurveTween(curve: curve))
              .animate(animation),
          child: child,
        );
      };
      break;

    case NavigationContext.modalPresentation:
      // ⬆️ Slide from bottom (modal screens)
      transitionsBuilder = (context, animation, _, child) {
        final tween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      };
      break;

    case NavigationContext.fadeTransition:
      // 🌫️ Fade in/out
      transitionsBuilder = (context, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      };
      break;

    case NavigationContext.rotationTransition:
      // 🔄 Rotation transition (for creative use)
      transitionsBuilder = (context, animation, _, child) {
        return RotationTransition(
          turns: Tween<double>(begin: 0.75, end: 1.0)
              .chain(CurveTween(curve: curve))
              .animate(animation),
          child: child,
        );
      };
      break;

    case NavigationContext.scaleFadeCombination:
      // ✨ Scale + fade transition
      transitionsBuilder = (context, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0)
                .chain(CurveTween(curve: curve))
                .animate(animation),
            child: child,
          ),
        );
      };
      break;
  }

  // ✅ CustomTransitionPage provides the final animation.
  return CustomTransitionPage<T>(
    child: child,
    transitionsBuilder: transitionsBuilder,
  );
}
