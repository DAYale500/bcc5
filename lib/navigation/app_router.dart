import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/screens/common/content_screen_navigator.dart';
import 'package:bcc5/screens/flashcards/flashcard_detail_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_item_screen.dart';
import 'package:bcc5/screens/paths/path_chapter_screen.dart';
import 'package:bcc5/screens/paths/path_item_screen.dart';
import 'package:bcc5/screens/lessons/lesson_item_screen.dart';
import 'package:bcc5/screens/parts/part_item_screen.dart';
import 'package:bcc5/screens/tools/tool_item_screen.dart';
import 'package:bcc5/screens/home/landing_screen.dart';
import 'package:bcc5/screens/lessons/lesson_module_screen.dart';
import 'package:bcc5/screens/parts/part_zone_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_category_screen.dart';
import 'package:bcc5/screens/tools/tools_screen.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/utils/logger.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'landing',
      pageBuilder: (context, state) {
        logger.i('🏁 Entering LandingScreen');
        return buildCustomTransition(
          context: context,
          child: const MainScaffold(branchIndex: 0, child: LandingScreen()),
        );
      },
    ),

    GoRoute(
      path: '/content',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final sequenceIds = extras['sequenceIds'] as List<String>? ?? [];
        final startIndex = extras['startIndex'] as int? ?? 0;
        final branchIndex = extras['branchIndex'] as int? ?? 0;
        final backDestination = extras['backDestination'] as String? ?? '/';
        final backExtra = extras['backExtra'] as Map<String, dynamic>?;

        logger.i('📦 Navigating to ContentScreenNavigator');
        logger.i('   └── sequenceIds: $sequenceIds');
        logger.i('   └── startIndex: $startIndex');
        logger.i('   └── branchIndex: $branchIndex');
        logger.i('   └── backDestination: $backDestination');
        logger.i('   └── backExtra: $backExtra');

        return ContentScreenNavigator(
          sequenceIds: sequenceIds,
          startIndex: startIndex,
          branchIndex: branchIndex,
          backDestination: backDestination,
        );
      },
    ),

    GoRoute(
      path: '/learning-paths/:pathName',
      name: 'learning-path',
      pageBuilder: (context, state) {
        final pathName =
            state.pathParameters['pathName']?.replaceAll('-', ' ') ?? 'Unknown';
        logger.i('🧭 Navigating to PathChapterScreen for "$pathName"');
        return buildCustomTransition(
          context: context,
          child: MainScaffold(
            branchIndex: 0,
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

        logger.i('📘 Navigating to PathItemScreen: $pathName / $chapterId');

        if (chapterId == null) {
          logger.e('❌ Missing chapterId for path $pathName');
          return buildCustomTransition(
            context: context,
            child: const Scaffold(
              body: Center(child: Text('❌ Missing chapter ID')),
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
      pageBuilder: (context, state) {
        logger.i('📘 Entering LessonModuleScreen');
        return buildCustomTransition(
          context: context,
          child: const MainScaffold(
            branchIndex: 1,
            child: LessonModuleScreen(),
          ),
        );
      },
    ),

    GoRoute(
      path: '/lessons/items',
      name: 'lesson-items',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final module = extras['module'] as String?;

        logger.i('📘 Navigating to LessonItemScreen for module: $module');

        if (module == null) {
          logger.e('❌ Missing module parameter for LessonItemScreen');
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
      pageBuilder: (context, state) {
        logger.i('🧩 Entering PartZoneScreen');
        return buildCustomTransition(
          context: context,
          child: const MainScaffold(branchIndex: 2, child: PartZoneScreen()),
        );
      },
    ),

    GoRoute(
      path: '/parts/items',
      name: 'part-items',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final zone = extras['zone'] as String? ?? '';
        logger.i('🧩 Navigating to PartItemScreen for zone: $zone');

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
      pageBuilder: (context, state) {
        logger.i('📇 Entering FlashcardCategoryScreen');
        return buildCustomTransition(
          context: context,
          child: const MainScaffold(
            branchIndex: 3,
            child: FlashcardCategoryScreen(),
          ),
        );
      },
    ),

    GoRoute(
      path: '/flashcards/items/:category',
      name: 'flashcardItems',
      pageBuilder: (context, state) {
        final category = state.pathParameters['category'] ?? 'all';
        logger.i(
          '📇 Navigating to FlashcardItemScreen for category: $category',
        );
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
        logger.i('🃏 Entering FlashcardDetailScreen with extra: $extra');
        return MainScaffold(
          branchIndex: extra['branchIndex'] ?? 0,
          child: FlashcardDetailScreen(extra: extra),
        );
      },
    ),

    GoRoute(
      path: '/tools',
      name: 'tools',
      pageBuilder: (context, state) {
        logger.i('🛠️ Entering ToolsScreen');
        return buildCustomTransition(
          context: context,
          child: const MainScaffold(branchIndex: 4, child: ToolsScreen()),
        );
      },
    ),

    GoRoute(
      path: '/tools/items',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final toolbag = extras['toolbag'] as String? ?? '';
        logger.i('🛠️ Navigating to ToolItemScreen for toolbag: $toolbag');
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
      const begin = Offset(1.0, 0.0);
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
