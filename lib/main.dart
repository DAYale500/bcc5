import 'package:flutter/material.dart';
import 'package:bcc5/bcc5_app.dart';
import 'package:bcc5/utils/logger.dart'; // Make sure this is imported

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  logger.i('''
🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀
🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
🌕🌕🌕🌕🌕 APP LAUNCH 🌕🌕🌕🌕🌕
''');

  runApp(const Bcc5App());
}
