import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/screens/common/content_detail_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_item_screen.dart';
import 'package:bcc5/screens/lessons/lesson_item_screen.dart';
import 'package:bcc5/screens/parts/part_item_screen.dart';
import 'package:bcc5/screens/tools/tool_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/screens/home/landing_screen.dart';
import 'package:bcc5/screens/lessons/lesson_module_screen.dart';
import 'package:bcc5/screens/parts/part_zone_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_category_screen.dart';
import 'package:bcc5/screens/tools/tools_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'landing',
      pageBuilder:
          (context, state) => buildCustomTransition(
            context: context,
            child: const MainScaffold(branchIndex: 0, child: LandingScreen()),
          ),
    ),
    GoRoute(
      path: '/content',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final title = extras['title'] as String? ?? 'Default Title';
        final content = extras['content'] as List<ContentBlock>? ?? [];

        return ContentDetailScreen(
          title: title,
          content: content,
          // Pass other necessary callbacks or data
        );
      },
    ),

    GoRoute(
      path: '/lessons',
      name: 'lessons',
      pageBuilder:
          (context, state) => buildCustomTransition(
            context: context,
            child: const MainScaffold(
              branchIndex: 1,
              child: LessonModuleScreen(),
            ),
          ),
    ),
    GoRoute(
      path: '/lessons/items',
      name: 'lesson-items',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final module = extras['module'] as String?;
        if (module == null) {
          return buildCustomTransition(
            context: context,
            child: const Scaffold(body: Center(child: Text('Missing module!'))),
          );
        }
        return buildCustomTransition(
          context: context,
          child: MainScaffold(
            branchIndex: 1,
            child: LessonItemScreen(module: module),
          ),
        );
      },
    ),

    GoRoute(
      path: '/parts',
      name: 'parts',
      pageBuilder:
          (context, state) => buildCustomTransition(
            context: context,
            child: const MainScaffold(branchIndex: 2, child: PartZoneScreen()),
          ),
    ),
    GoRoute(
      path: '/parts/items',
      name: 'part-items',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final zone = extras['zone'] as String?;

        if (zone == null || zone.trim().isEmpty) {
          return buildCustomTransition(
            context: context,
            child: const Scaffold(
              body: Center(child: Text('❌ Missing or malformed zone')),
            ),
          );
        }

        return buildCustomTransition(
          context: context,
          child: MainScaffold(
            branchIndex: 2,
            child: PartItemScreen(zone: zone),
          ),
        );
      },
    ),

    GoRoute(
      path: '/flashcards',
      name: 'flashcards',
      pageBuilder:
          (context, state) => buildCustomTransition(
            context: context,
            child: const MainScaffold(
              branchIndex: 3,
              child: FlashcardCategoryScreen(),
            ),
          ),
    ),
    GoRoute(
      path: '/flashcards/items',
      name: 'flashcard-items',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final category = extras['category'] as String?;

        if (category == null || category.trim().isEmpty) {
          return buildCustomTransition(
            context: context,
            child: const Scaffold(
              body: Center(child: Text('❌ Missing or malformed category')),
            ),
          );
        }

        return buildCustomTransition(
          context: context,
          child: MainScaffold(
            branchIndex: 3,
            child: FlashcardItemScreen(category: category),
          ),
        );
      },
    ),

    GoRoute(
      path: '/tools',
      name: 'tools',
      pageBuilder:
          (context, state) => buildCustomTransition(
            context: context,
            child: const MainScaffold(branchIndex: 4, child: ToolsScreen()),
          ),
    ),
    GoRoute(
      path: '/tools/items',
      name: 'tool-items',
      pageBuilder:
          (context, state) => buildCustomTransition(
            context: context,
            child: const MainScaffold(branchIndex: 4, child: ToolItemScreen()),
          ),
    ),
  ],
);

CustomTransitionPage buildCustomTransition({
  required BuildContext context,
  required Widget child,
}) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Slide from right
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
