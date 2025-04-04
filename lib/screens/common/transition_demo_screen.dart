import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransitionDemoScreen extends StatelessWidget {
  const TransitionDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transition Demos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDemoButton(context, 'Slide from Right', 'slide'),
            _buildDemoButton(context, 'Fade In', 'fade'),
            _buildDemoButton(context, 'Scale In', 'scale'),
            _buildDemoButton(context, 'Slide from Bottom', 'bottom'),
            _buildDemoButton(context, 'No Animation', 'none'),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoButton(BuildContext context, String label, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () => context.push('/transition-demo/$type'),
        child: Text(label),
      ),
    );
  }
}

class TransitionTargetScreen extends StatelessWidget {
  final String type;

  const TransitionTargetScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$type Transition')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.push('/transition-demo'),
          child: const Text('Back to Demo Menu'),
        ),
      ),
    );
  }
}

CustomTransitionPage buildDemoTransitionPage(Widget child, String type) {
  final duration = const Duration(milliseconds: 300);

  return CustomTransitionPage(
    transitionDuration: duration,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (type) {
        case 'slide':
          return SlideTransition(
            position: Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        case 'fade':
          return FadeTransition(opacity: animation, child: child);
        case 'scale':
          return ScaleTransition(scale: animation, child: child);
        case 'bottom':
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        case 'none':
        default:
          return child;
      }
    },
  );
}
