// 📄 lib/screens/lessons/lesson_module_screen.dart

import 'package:bcc5/widgets/group_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/utils/logger.dart';

class LessonModuleScreen extends StatelessWidget {
  const LessonModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moduleNames = LessonRepositoryIndex.getModuleNames();
    logger.i('🟦 Entered LessonModuleScreen');

    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Choose a Module',
        showBackButton: false,
        showSearchIcon: true,
        showSettingsIcon: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: moduleNames.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final moduleName = moduleNames[index];
          return GroupButton(
            label: moduleName,
            onTap: () {
              logger.i('📘 Tapped Module: $moduleName');
              context.push('/lessons/items', extra: {'module': moduleName});
            },
          );
        },
      ),
    );
  }
}
