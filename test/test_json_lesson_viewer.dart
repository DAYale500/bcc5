import 'package:flutter/material.dart';
import 'package:bcc5/data/loaders/content_loader.dart';
import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';

class TestJsonLessonViewer extends StatefulWidget {
  final String lessonId;

  const TestJsonLessonViewer({required this.lessonId, super.key});

  @override
  State<TestJsonLessonViewer> createState() => _TestJsonLessonViewerState();
}

class _TestJsonLessonViewerState extends State<TestJsonLessonViewer> {
  Lesson? _lesson;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final lesson = await ContentLoader.loadLessonById(widget.lessonId);
    setState(() {
      _lesson = lesson;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_lesson == null) return const Center(child: Text("Lesson not found"));

    return Scaffold(
      appBar: AppBar(title: Text(_lesson!.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [ContentBlockRenderer(blocks: _lesson!.content)],
      ),
    );
  }
}
