import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/utils/logger.dart';

import 'package:bcc5/screens/home/landing_screen.dart';
import 'package:bcc5/screens/lessons/lesson_module_screen.dart';
import 'package:bcc5/screens/lessons/lesson_item_screen.dart';
import 'package:bcc5/screens/lessons/lesson_detail_screen.dart';
import 'package:bcc5/screens/parts/part_zone_screen.dart';
import 'package:bcc5/screens/parts/part_item_screen.dart';
import 'package:bcc5/screens/parts/part_detail_screen.dart';
import 'package:bcc5/screens/tools/tools_bag_screen.dart';
import 'package:bcc5/screens/tools/tool_item_screen.dart';
import 'package:bcc5/screens/tools/tool_detail_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_category_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_item_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_detail_screen.dart';
import 'package:bcc5/screens/paths/path_chapter_screen.dart';
import 'package:bcc5/screens/paths/path_item_screen.dart';

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

    // ⛑️ Legacy /content fallback
    // GoRoute(
    //   path: '/content',
    //   builder: (context, state) {
    //     final extras = state.extra as Map<String, dynamic>? ?? {};
    //     final sequenceIds = extras['sequenceIds'] as List<String>? ?? [];
    //     final startIndex = extras['startIndex'] as int? ?? 0;
    //     final branchIndex = extras['branchIndex'] as int? ?? 0;
    //     final backDestination = extras['backDestination'] as String? ?? '/';

    //     logger.i('📦 Navigating to ContentScreenNavigator');
    //     logger.i('   └── sequenceIds: $sequenceIds');
    //     logger.i('   └── startIndex: $startIndex');
    //     logger.i('   └── branchIndex: $branchIndex');
    //     logger.i('   └── backDestination: $backDestination');

    //     return ContentScreenNavigator(
    //       sequenceIds: sequenceIds,
    //       startIndex: startIndex,
    //       branchIndex: branchIndex,
    //       backDestination: backDestination,
    //     );
    //   },
    // ),

    // 🧭 Learning Paths
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

        if (chapterId == null) {
          logger.e('❌ Missing chapterId for path $pathName');
          return buildCustomTransition(
            context: context,
            child: const Scaffold(
              body: Center(child: Text('❌ Missing chapter ID')),
            ),
          );
        }

        logger.i('📘 Navigating to PathItemScreen: $pathName / $chapterId');
        return buildCustomTransition(
          context: context,
          child: MainScaffold(
            branchIndex: 0,
            child: PathItemScreen(pathName: pathName, chapterId: chapterId),
          ),
        );
      },
    ),

    // 📘 Lessons
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
        if (module == null) {
          logger.e('❌ Missing module parameter for LessonItemScreen');
          return buildCustomTransition(
            context: context,
            child: const Scaffold(body: Center(child: Text('Missing module!'))),
          );
        }
        logger.i('📘 Navigating to LessonItemScreen for module: $module');
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
      path: '/lessons/detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        logger.i('📘 Entering LessonDetailScreen with extra: $extra');
        return MainScaffold(
          branchIndex: extra['branchIndex'],
          child: LessonDetailScreen(
            renderItems: extra['renderItems'],
            currentIndex: extra['currentIndex'],
            branchIndex: extra['branchIndex'],
            backDestination: extra['backDestination'] as String? ?? '/',
            backExtra: extra['backExtra'] as Map<String, dynamic>?,
          ),
        );
      },
    ),

    // 🧩 Parts
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
      path: '/parts/detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        logger.i('🧩 Entering PartDetailScreen with extra: $extra');
        return MainScaffold(
          branchIndex: extra['branchIndex'],
          child: PartDetailScreen(
            renderItems: extra['renderItems'],
            currentIndex: extra['currentIndex'],
            branchIndex: extra['branchIndex'],
            backDestination: extra['backDestination'],
            backExtra: extra['backExtra'] as Map<String, dynamic>?,
          ),
        );
      },
    ),

    // 🛠️ Tools
    GoRoute(
      path: '/tools',
      name: 'tools',
      pageBuilder: (context, state) {
        logger.i('🛠️ Entering ToolsScreen');
        return buildCustomTransition(
          context: context,
          child: const MainScaffold(branchIndex: 3, child: ToolsScreen()),
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
    GoRoute(
      path: '/tools/detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        logger.i('🛠️ Entering ToolDetailScreen with extra: $extra');
        return MainScaffold(
          branchIndex: extra['branchIndex'],
          child: ToolDetailScreen(
            renderItems: extra['renderItems'],
            currentIndex: extra['currentIndex'],
            branchIndex: extra['branchIndex'],
            backDestination: extra['backDestination'],
            backExtra: extra['backExtra'] as Map<String, dynamic>?,
          ),
        );
      },
    ),

    // 🃏 Flashcards
    GoRoute(
      path: '/flashcards',
      name: 'flashcards',
      pageBuilder: (context, state) {
        logger.i('📇 Entering FlashcardCategoryScreen');
        return buildCustomTransition(
          context: context,
          child: const MainScaffold(
            branchIndex: 4,
            child: FlashcardCategoryScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/flashcards/items',
      name: 'flashcardItems',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final category = extras['category'] as String? ?? 'all';
        logger.i('📇 Navigating to FlashcardItemScreen for category: category');
        return buildCustomTransition(
          context: context,
          child: MainScaffold(
            branchIndex: 4,
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

        final currentIndex = extra['currentIndex'] ?? extra['startIndex'] ?? 0;

        return MainScaffold(
          branchIndex: extra['branchIndex'] ?? 4,
          child: FlashcardDetailScreen(
            key: ValueKey(currentIndex), // 👈 forces rebuild when index changes
            extra: extra,
          ),
        );
      },
    ),

    // GoRoute(
    //   path: '/flashcards/detail',
    //   builder: (context, state) {
    //     final extra = state.extra as Map<String, dynamic>;
    //     logger.i('🃏 Entering FlashcardDetailScreen with extra: $extra');
    //     return MainScaffold(
    //       branchIndex: extra['branchIndex'] ?? 4,
    //       child: FlashcardDetailScreen(extra: extra),
    //     );
    //   },
    // ),
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
