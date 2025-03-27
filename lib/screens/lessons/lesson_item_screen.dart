import 'package:flutter/material.dart';
import '../../widgets/item_button.dart';
import '../../models/content_block.dart';
import '../common/content_navigator.dart';
import '../../navigation/main_scaffold.dart';
import '../../utils/logger.dart';

class LessonItemScreen extends StatelessWidget {
  final String moduleName;

  const LessonItemScreen({super.key, required this.moduleName});

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered LessonItemScreen for $moduleName');

    final List<String> lessons = [
      'Lesson 1 - Intro',
      'Lesson 2 - Terminology',
      'Lesson 3 - Safety',
    ];

    final contentMap = {
      'Lesson 1 - Intro': [ContentBlock.text('Intro')],
      'Lesson 2 - Terminology': [ContentBlock.text('Terms')],
      'Lesson 3 - Safety': [ContentBlock.text('Safety')],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons in $moduleName'),
        backgroundColor: Colors.blueGrey[50],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            logger.i('⬅️ Back from LessonItemScreen to LessonModuleScreen');
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: lessons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 2.8,
          ),
          itemBuilder: (context, index) {
            final lessonTitle = lessons[index];
            return ItemButton(
              label: lessonTitle,
              onTap: () {
                logger.i('📗 Tapped Lesson: $lessonTitle');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => MainScaffold(
                          selectedIndex: 1,
                          child: ContentScreenNavigator(
                            title: lessonTitle,
                            sequenceTitles: lessons,
                            contentMap: contentMap,
                            startIndex: index,
                          ),
                        ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
