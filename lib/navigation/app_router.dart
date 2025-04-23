import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/screens/paths/path_item_screen.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/screens/landing_screen/landing_screen.dart';
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
        // logger.d('[Router] Navigated to /landing');

        final showReminder =
            (state.extra as Map<String, dynamic>?)?['showReminder'] as bool? ??
            false;

        // ✅ Onboarding GlobalKeys (created once in this route scope)
        final mobKey = GlobalKey(debugLabel: 'MOBKey');
        final settingsKey = GlobalKey(debugLabel: 'SettingsKey');
        final searchKey = GlobalKey(debugLabel: 'SearchKey');
        final titleKey = GlobalKey(debugLabel: 'TitleKey');
        final harborKey = GlobalKey(debugLabel: 'HarborIconKey');

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(state.pageKey.toString()),

          child: MainScaffold(
            branchIndex: 0,
            harborKey: harborKey,
            child: LandingScreen(
              showReminder: showReminder,
              harborKey: harborKey,
              mobKey: mobKey,
              settingsKey: settingsKey,
              searchKey: searchKey,
              titleKey: titleKey,
            ),
          ),
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
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final slideFrom =
            extras['slideFrom'] as SlideDirection? ?? SlideDirection.none;
        final transitionType =
            extras['transitionType'] as TransitionType? ??
            TransitionType.instant;

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(state.pageKey.toString()),
          slideFrom: slideFrom,
          transitionType: transitionType,
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

        // // ✅ Fix: Fallback GlobalKeys
        // final mobKey =
        //     extras['mobKey'] as GlobalKey? ?? GlobalKey(debugLabel: 'MOBKey');
        // final settingsKey =
        //     extras['settingsKey'] as GlobalKey? ??
        //     GlobalKey(debugLabel: 'SettingsKey');
        // final searchKey =
        //     extras['searchKey'] as GlobalKey? ??
        //     GlobalKey(debugLabel: 'SearchKey');
        // final titleKey =
        //     extras['titleKey'] as GlobalKey? ??
        //     GlobalKey(debugLabel: 'TitleKey');

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(state.pageKey.toString()),
          slideFrom: slideFrom,
          child: MainScaffold(
            branchIndex: 0,
            child: PathItemScreen(
              pathName: pathName,
              chapterId: chapterId ?? '',
              // mobKey: mobKey,
              // settingsKey: settingsKey,
              // searchKey: searchKey,
              // titleKey: titleKey,
            ),
          ),
        );
      },
    ),

    // 📘 Lessons
    GoRoute(
      path: '/lessons',
      name: 'lessons',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final slideFrom =
            extras['slideFrom'] as SlideDirection? ?? SlideDirection.none;
        final transitionType =
            extras['transitionType'] as TransitionType? ??
            TransitionType.instant;

        logger.i('📘 Entering LessonModuleScreen');
        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(state.pageKey.toString()),
          slideFrom: slideFrom,
          transitionType: transitionType,
          child: MainScaffold(branchIndex: 1, child: LessonModuleScreen()),
        );
      },
    ),

    // refactored april 21 1256
    GoRoute(
      path: '/lessons/items',
      name: 'lesson-items',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {}; // ✅
        final module = extras['module'] as String?;
        final slideFrom =
            extras['slideFrom'] as SlideDirection? ?? SlideDirection.none;
        final transitionType =
            extras['transitionType'] as TransitionType? ??
            TransitionType.instant;
        final detailRoute =
            extras['detailRoute'] as DetailRoute? ?? DetailRoute.branch;

        if (module == null) {
          logger.e('❌ Missing module parameter for LessonItemScreen');
          return TransitionManager.buildCustomTransition(
            context: context,
            state: state,
            transitionKey: state.pageKey,
            slideFrom: slideFrom,
            transitionType: transitionType,
            child: MainScaffold(
              branchIndex: 1,
              child:
                  const LessonModuleScreen(), // ✅ Refactored: no keys passed in
            ),
          );
        }

        logger.i(
          '📘 Navigating to LessonItemScreen for module: $module | detailRoute: $detailRoute',
        );

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          slideFrom: slideFrom,
          transitionType: transitionType,
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
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final slideFrom =
            extras['slideFrom'] as SlideDirection? ?? SlideDirection.none;
        final transitionType =
            extras['transitionType'] as TransitionType? ??
            TransitionType.instant;

        // logger.i('🧩 Entering PartZoneScreen');

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          slideFrom: slideFrom,
          transitionType: transitionType,
          child: MainScaffold(branchIndex: 2, child: PartZoneScreen()),
        );
      },
    ),

    GoRoute(
      path: '/parts/items',
      name: 'part-items',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {}; // ✅
        final zone = extras['zone'] as String? ?? '';
        final slideFrom =
            extras['slideFrom'] as SlideDirection? ?? SlideDirection.none;
        final transitionType =
            extras['transitionType'] as TransitionType? ??
            TransitionType.instant;
        final detailRoute =
            extras['detailRoute'] as DetailRoute? ?? DetailRoute.branch;

        logger.i(
          '🧩 Navigating to PartItemScreen for zone: $zone | detailRoute: $detailRoute',
        );

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          slideFrom: slideFrom,
          transitionType: transitionType,
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
        final extras = state.extra as Map<String, dynamic>? ?? {};
        final slideFrom =
            extras['slideFrom'] as SlideDirection? ?? SlideDirection.none;
        final transitionType =
            extras['transitionType'] as TransitionType? ??
            TransitionType.instant;

        // logger.d('[Router] Navigated to /tools');

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          slideFrom: slideFrom,
          transitionType: transitionType,
          child: MainScaffold(branchIndex: 3, child: ToolBagScreen()),
        );
      },
    ),

    GoRoute(
      path: '/tools/items',
      name: 'tool-items',
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {}; // ✅
        final toolbag = extras['toolbag'] as String? ?? '';
        final slideFrom =
            extras['slideFrom'] as SlideDirection? ?? SlideDirection.none;
        final transitionType =
            extras['transitionType'] as TransitionType? ??
            TransitionType.instant;
        final detailRoute =
            extras['detailRoute'] as DetailRoute? ?? DetailRoute.branch;

        logger.i(
          '🛠️ Navigating to ToolItemScreen for toolbag: $toolbag | detailRoute: $detailRoute',
        );

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          slideFrom: slideFrom,
          transitionType: transitionType,
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
    // 🃏 Flashcards
    GoRoute(
      path: '/flashcards',
      name: 'flashcards',
      pageBuilder: (context, state) {
        // logger.i('📇 Entering FlashcardCategoryScreen');

        final extras = state.extra as Map<String, dynamic>? ?? {};
        final slideFrom =
            extras['slideFrom'] as SlideDirection? ?? SlideDirection.left;
        final transitionType =
            extras['transitionType'] as TransitionType? ?? TransitionType.slide;

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          slideFrom: slideFrom,
          transitionType: transitionType,
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
        final slideFrom =
            extras['slideFrom'] as SlideDirection? ?? SlideDirection.none;
        final transitionType =
            extras['transitionType'] as TransitionType? ??
            TransitionType.instant;
        final detailRoute =
            extras['detailRoute'] as DetailRoute? ?? DetailRoute.branch;

        logger.i(
          '📇 Navigating to FlashcardItemScreen for category: $category | detailRoute: $detailRoute',
        );

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: state.pageKey,
          slideFrom: slideFrom,
          transitionType: transitionType,
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
        final extras = state.extra as Map<String, dynamic>;

        final renderItems = extras['renderItems'] as List<RenderItem>;
        final currentIndex =
            extras['currentIndex'] ?? extras['startIndex'] ?? 0;
        final branchIndex = extras['branchIndex'] ?? 4;
        final backDestination = extras['backDestination'] ?? '/';
        final backExtra = extras['backExtra'] as Map<String, dynamic>?;
        final detailRoute = extras['detailRoute'] as DetailRoute;
        final transitionKey = extras['transitionKey'] as String;

        // logger.i('🃏 Entering FlashcardDetailScreen with extra: $extras');

        return TransitionManager.buildCustomTransition(
          context: context,
          state: state,
          transitionKey: ValueKey(transitionKey),
          child: MainScaffold(
            branchIndex: branchIndex,
            child: FlashcardDetailScreen(
              key: ValueKey(currentIndex),
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
  ],
);
