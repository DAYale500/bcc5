import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/string_extensions.dart'; // ✅ for toTitleCase

class LessonModuleScreen extends StatefulWidget {
  // ✅ Converted to StatefulWidget
  const LessonModuleScreen({super.key});

  @override
  State<LessonModuleScreen> createState() => _LessonModuleScreenState(); // ✅
}

class _LessonModuleScreenState extends State<LessonModuleScreen> {
  // ✅
  // ✅ These keys now belong to LessonModuleScreen
  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey'); // ✅
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey'); // ✅
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey'); // ✅
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey'); // ✅

  @override
  Widget build(BuildContext context) {
    final moduleNames = LessonRepositoryIndex.getModuleNames();
    logger.i('🟦 Entered LessonModuleScreen');

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Courses',
        showBackButton: false,
        showSearchIcon: true,
        showSettingsIcon: true,
        mobKey: mobKey,
        settingsKey: settingsKey,
        searchKey: searchKey,
        titleKey: titleKey,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Select a course to embark upon:',
            style: AppTheme.subheadingStyle.copyWith(
              color: AppTheme.primaryBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: moduleNames.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final moduleName = moduleNames[index];
                final label = moduleName.toTitleCase(); // ✅ Title Case

                return GroupButton(
                  label: label,
                  onTap: () {
                    logger.i('📘 Tapped Module: $moduleName');
                    final timestamp = DateTime.now().millisecondsSinceEpoch;

                    context.push(
                      '/lessons/items',
                      extra: {
                        'module': moduleName,
                        'transitionKey': 'lesson_items_${index}_$timestamp',
                        'transitionType': TransitionType.slide,
                        'slideFrom': SlideDirection.right,
                        'detailRoute': DetailRoute.branch,
                        // ❌ REMOVED: no more GlobalKeys passed in
                        // 'mobKey': GlobalKey(debugLabel: 'MOBKey'), // ❌
                        // 'settingsKey': GlobalKey(debugLabel: 'SettingsKey'), // ❌
                        // 'searchKey': GlobalKey(debugLabel: 'SearchKey'), // ❌
                        // 'titleKey': GlobalKey(debugLabel: 'TitleKey'), // ❌
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
