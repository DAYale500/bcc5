// lib/data/repositories/tools/tool_utilities_repository.dart
import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/models/content_block.dart';

class ToolUtilitiesRepository {
  static const String bagKey = 'utilities';

  // For now: a single tool item; ToolItemScreen will show this one.
  static final List<ToolItem> toolItems = [
    ToolItem(
      id: 'tool_utilities_gps_conversion_1.00', // note: bag prefix "utilities"
      title: 'GPS Conversion', // keeps exact caps on item screen
      content: [
        ContentBlock.heading('Enter Coordinates to Convert:'),
        ContentBlock.gpsConverter(), // 🟩 now at the top
        ContentBlock.divider(),
        ContentBlock.text(
          // 🟩 explanatory text below
          'Paste or type coordinates in any of the common formats '
          '(DD, DMM, or DMS). You’ll see all three formats below the field.',
        ),
      ],
      flashcards: const [],
    ),
  ];
}
