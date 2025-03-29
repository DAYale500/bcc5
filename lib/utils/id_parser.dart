// 🟠 lib/utils/id_parser.dart

/// Extracts the [type] from a content ID, e.g. 'lesson' from 'lesson_docking_1.00'
String getTypeFromId(String id) {
  final parts = id.split('_');
  return parts.isNotEmpty ? parts[0] : 'unknown';
}

/// Extracts the [group] from a content ID, e.g. 'docking' from 'lesson_docking_1.00'
String getGroupFromId(String id) {
  final parts = id.split('_');
  return parts.length >= 2 ? parts[1] : 'unknown';
}

/// Extracts the [sequence number] from a content ID, e.g. '1.00' from 'lesson_docking_1.00'
String getSequenceFromId(String id) {
  final parts = id.split('_');
  return parts.length >= 3 ? parts[2] : 'unknown';
}
