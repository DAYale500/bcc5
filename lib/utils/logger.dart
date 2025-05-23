import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.none, // ✅ Modern replacement for printTime
  ),
);
