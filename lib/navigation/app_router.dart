import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/screens/common/content_screen_navigator.dart';
import 'package:bcc5/screens/flashcards/flashcard_detail_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_item_screen.dart';
import 'package:bcc5/screens/paths/path_chapter_screen.dart';
import 'package:bcc5/screens/paths/path_item_screen.dart';
import 'package:bcc5/screens/lessons/lesson_item_screen.dart';
import 'package:bcc5/screens/parts/part_item_screen.dart';
import 'package:bcc5/screens/tools/tool_item_screen.dart';
import 'package:bcc5/utils/logger.dart';
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
        final sequenceTitles = extras['sequenceTitles'] as List<String>? ?? [];
        final contentMap =
            extras['contentMap'] as Map<String, List<ContentBlock>>? ?? {};
        final startIndex = extras['startIndex'] as int? ?? 0;
        final branchIndex =
            extras['branchIndex'] as int? ?? 0; // ✅ Add this line
        final backDestination = extras['backDestination'] as String? ?? '/';
        final backExtra = extras['backExtra'] as Map<String, dynamic>?;

        return ContentScreenNavigator(
          title: sequenceTitles[startIndex],
          sequenceTitles: sequenceTitles,
          contentMap: contentMap,
          startIndex: startIndex,
          branchIndex: branchIndex, // ✅ Fix passed here
          onBack: () {
            if (backExtra != null) {
              context.go(backDestination, extra: backExtra);
            } else {
              context.go(backDestination);
            }
          },
        );
      },
    ),

    GoRoute(
      path: '/learning-paths/:pathName',
      name: 'learning-path',
      pageBuilder: (context, state) {
        final pathName =
            state.pathParameters['pathName']?.replaceAll('-', ' ') ?? 'Unknown';
        logger.i('🧭 Navigating to PathChapterScreen for $pathName');

        return buildCustomTransition(
          context: context,
          child: MainScaffold(
            branchIndex: 0, // or whatever makes sense
            child: PathChapterScreen(pathName: pathName),
          ),
        );
      },
    ),

    GoRoute(
      path: '/learning-paths/:pathName/items',
      name: 'learning-path-items',
      pageBuilder: (context, state) {
        final pathName =
            state.pathParameters['pathName']?.replaceAll('-', ' ') ?? 'Unknown';
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final chapterId = extras['chapterId'] as String?;

        logger.i('📥 Received pathName=$pathName, chapterId=$chapterId');

        if (chapterId == null) {
          logger.e('❌ Missing chapterId for $pathName');
          return buildCustomTransition(
            context: context,
            child: const Scaffold(
              body: Center(child: Text('Missing chapter ID')),
            ),
          );
        }

        return buildCustomTransition(
          context: context,
          child: MainScaffold(
            branchIndex: 0,
            child: PathItemScreen(pathName: pathName, chapterId: chapterId),
          ),
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
      path: '/flashcards/items/:category',
      name: 'flashcardItems',
      pageBuilder: (context, state) {
        final category = state.pathParameters['category'] ?? 'all';
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
      path: '/flashcards/detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return MainScaffold(
          branchIndex: extra['branchIndex'] ?? 0,
          child: FlashcardDetailScreen(extra: extra),
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
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final toolbag = extras['toolbag'] as String? ?? '';

        return ToolItemScreen(toolbag: toolbag);
      },
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
