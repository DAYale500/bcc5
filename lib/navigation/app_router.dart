import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/screens/paths/path_item_screen.dart';
import 'package:bcc5/theme/slide_direction.dart';
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
import 'package:bcc5/screens/tools/tool_bag_screen.dart';
import 'package:bcc5/screens/tools/tool_item_screen.dart';
import 'package:bcc5/screens/tools/tool_detail_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_category_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_item_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_detail_screen.dart';
import 'package:bcc5/screens/paths/path_chapter_screen.dart';
// import 'package:bcc5/screens/paths/path_item_screen.dart';
import 'package:bcc5/utils/transition_manager.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // 🏁 Landing
    GoRoute(
      path: '/',
      name: 'landing',
      pageBuilder: (context, state) {
        logger.i('🏁 Entering LandingScreen');
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(state.pageKey.toString()), // ✅ FIXED
          child: const MainScaffold(branchIndex: 0, child: LandingScreen()),
        );
      },
    ),

    // 🧭 Learning Paths
    GoRoute(
      path: '/learning-paths/:pathName',
      name: 'learning-path',
      pageBuilder: (context, state) {
        final pathName =
            state.pathParameters['pathName']?.replaceAll('-', ' ') ?? 'Unknown';
        logger.i('🧭 Navigating to PathChapterScreen for "$pathName"');
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(state.pageKey.toString()), // ✅ FIXED

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
        final slideFrom =
            extras['slideFrom'] as SlideDirection? ?? SlideDirection.none;

        // Optional: just for logging
        final detailRoute =
            extras['detailRoute'] as DetailRoute? ?? DetailRoute.branch;
        logger.i(
          '[PathItemRoute] detailRoute: $detailRoute | slideFrom: $slideFrom',
        );

        if (chapterId == null) {
          logger.e('❌ Missing chapterId for path $pathName');
          return TransitionManager.buildCustomTransition(
            context: context,
            state: state,
            transitionKey: ValueKey(state.pageKey.toString()),
            child: const MainScaffold(branchIndex: 0, child: LandingScreen()),
          );
        }

        logger.i('📘 Navigating to PathItemScreen: $pathName / $chapterId');
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(state.pageKey.toString()),
          slideFrom: slideFrom,
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
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(state.pageKey.toString()),
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
          return TransitionManager.buildCustomTransition(
            context: context,
            state: state,
            transitionKey: state.pageKey,
            child: const MainScaffold(
              branchIndex: 1,
              child: LessonModuleScreen(),
            ),
          );
        }
        logger.i('📘 Navigating to LessonItemScreen for module: $module');
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          child: MainScaffold(
            branchIndex: 1,
            child: LessonItemScreen(module: module),
          ),
        );
      },
    ),

    GoRoute(
      path: '/lessons/detail',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final renderItems = extras['renderItems'] as List<RenderItem>;
        final currentIndex = extras['currentIndex'] as int;
        final branchIndex = extras['branchIndex'] as int;
        final backDestination = extras['backDestination'] as String;
        final backExtra = extras['backExtra'] as Map<String, dynamic>?;
        final detailRoute = extras['detailRoute'] as DetailRoute;
        final transitionKey = extras['transitionKey'] as String;

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(transitionKey),
          child: MainScaffold(
            branchIndex: branchIndex,
            child: LessonDetailScreen(
              renderItems: renderItems,
              currentIndex: currentIndex,
              branchIndex: branchIndex,
              backDestination: backDestination,
              backExtra: backExtra,
              detailRoute: detailRoute,
              transitionKey: transitionKey,
            ),
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
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
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
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          child: MainScaffold(
            branchIndex: 2,
            child: PartItemScreen(zone: zone),
          ),
        );
      },
    ),

    GoRoute(
      path: '/parts/detail',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final renderItems = extras['renderItems'] as List<RenderItem>;
        final currentIndex = extras['currentIndex'] as int;
        final branchIndex = extras['branchIndex'] as int;
        final backDestination = extras['backDestination'] as String;
        final backExtra = extras['backExtra'] as Map<String, dynamic>?;
        final detailRoute = extras['detailRoute'] as DetailRoute;
        final transitionKey = extras['transitionKey'] as String;

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(transitionKey),
          child: MainScaffold(
            branchIndex: branchIndex,
            child: PartDetailScreen(
              renderItems: renderItems,
              currentIndex: currentIndex,
              branchIndex: branchIndex,
              backDestination: backDestination,
              backExtra: backExtra,
              detailRoute: detailRoute,
              transitionKey: transitionKey,
            ),
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
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          child: MainScaffold(branchIndex: 3, child: ToolBagScreen()),
        );
      },
    ),
    GoRoute(
      path: '/tools/items',
      name: 'tool-items',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final toolbag = extras['toolbag'] as String? ?? '';
        logger.i('🛠️ Navigating to ToolItemScreen for toolbag: $toolbag');
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          child: MainScaffold(
            branchIndex: 3,
            child: ToolItemScreen(toolbag: toolbag),
          ),
        );
      },
    ),
    GoRoute(
      path: '/tools/detail',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final renderItems = extras['renderItems'] as List<RenderItem>;
        final currentIndex = extras['currentIndex'] as int;
        final branchIndex = extras['branchIndex'] as int;
        final backDestination = extras['backDestination'] as String;
        final backExtra = extras['backExtra'] as Map<String, dynamic>?;
        final detailRoute = extras['detailRoute'] as DetailRoute;
        final transitionKey = extras['transitionKey'] as String;

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(transitionKey),
          child: MainScaffold(
            branchIndex: branchIndex,
            child: ToolDetailScreen(
              renderItems: renderItems,
              currentIndex: currentIndex,
              branchIndex: branchIndex,
              backDestination: backDestination,
              backExtra: backExtra,
              detailRoute: detailRoute,
              transitionKey: transitionKey,
            ),
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
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey, // ✅ added here
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
        logger.i(
          '📇 Navigating to FlashcardItemScreen for category: $category',
        );
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey, // ✅ added here
          child: MainScaffold(
            branchIndex: 4,
            child: FlashcardItemScreen(category: category),
          ),
        );
      },
    ),
    GoRoute(
      path: '/flashcards/detail',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        logger.i('🃏 Entering FlashcardDetailScreen with extra: $extra');
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey, // ✅ inserted here
          child: MainScaffold(
            branchIndex: extra['branchIndex'] ?? 4,
            child: FlashcardDetailScreen(
              key: ValueKey(extra['currentIndex'] ?? extra['startIndex'] ?? 0),
              renderItems: extra['renderItems'],
              currentIndex: extra['currentIndex'] ?? extra['startIndex'] ?? 0,
              branchIndex: extra['branchIndex'] ?? 4,
              backDestination: extra['backDestination'] ?? '/',
              backExtra: extra['backExtra'] as Map<String, dynamic>?,
              detailRoute: extra['detailRoute'],
              transitionKey: extra['transitionKey'],
            ),
          ),
        );
      },
    ),
  ],
);
