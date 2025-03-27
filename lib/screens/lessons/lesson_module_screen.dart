import 'package:flutter/material.dart';
import '../../widgets/group_button.dart';
import 'lesson_item_screen.dart';
import '../../navigation/main_scaffold.dart';
import '../../utils/logger.dart';

class LessonModuleScreen extends StatelessWidget {
  const LessonModuleScreen({super.key});

  final List<String> modules = const ['Module 1', 'Module 2', 'Module 3'];

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered LessonModuleScreen');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Module'),
        backgroundColor: Colors.blueGrey[50], // ✅ Visualize appBar presence
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final moduleName = modules[index];
          return GroupButton(
            label: moduleName,
            // From lesson_module_screen.dart
            onTap: () {
              logger.i('📘 Tapped Module: $moduleName');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => MainScaffold(
                        selectedIndex: 1,
                        child: LessonItemScreen(moduleName: moduleName),
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
