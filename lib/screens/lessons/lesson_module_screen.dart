import 'package:bcc5/screens/lessons/lesson_item_screen.dart';
import 'package:flutter/material.dart';
import '../../navigation/main_scaffold.dart';
import '../../widgets/group_button.dart';
import '../../utils/logger.dart';
import '../../data/repositories/lessons/lesson_repository_index.dart';

class LessonModuleScreen extends StatelessWidget {
  const LessonModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moduleNames = LessonRepositoryIndex.getModuleNames();

    logger.i('🟦 Entered LessonModuleScreen');

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Choose a Module'),
      //   backgroundColor: Colors.blue.shade100,
      // ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => MainScaffold(
                        selectedIndex: 1,
                        child: LessonItemScreen(module: moduleName),
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
