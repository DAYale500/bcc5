import 'package:bcc5/theme/transition_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/string_extensions.dart'; // ✅ for toTitleCase

class LessonModuleScreen extends StatelessWidget {
  const LessonModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moduleNames = LessonRepositoryIndex.getModuleNames();
    logger.i('🟦 Entered LessonModuleScreen');

    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Lessons',
        showBackButton: false,
        showSearchIcon: true,
        showSettingsIcon: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Choose a Module',
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
                        'transitionType': TransitionType.instant, // ✅ Add this
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
