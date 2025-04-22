import 'package:bcc5/screens/emergency/mob_emergency_screen.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bcc5/utils/location_helper.dart';

Future<void> showMOBModal(BuildContext context) async {
  final localContext = context;
  final now = DateTime.now();
  final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  final position = await getCurrentLocation();
  final gpsText =
      position != null
          ? '${position.latitude}, ${position.longitude}'
          : 'Unavailable';

  logger.i('🚨 MOB Modal triggered at $formattedTime with coords: $gpsText');

  // ✅ SAFELY use context after await
  if (!localContext.mounted) return;

  // ⚠️ Navigates away from the modal — do not pop the dialog
  // Back button will return here; ensure app stack is preserved.
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const MOBEmergencyScreen(),
    ),
  );

  // final tools = ToolRepositoryIndex.getToolsForBag('emergencies');
  // final renderItems = buildRenderItems(ids: tools.map((t) => t.id).toList());

  // GoRouter.of(context).go(
  //   '/tools/items',
  //   extra: {
  //     'toolbag': 'emergencies',
  //     'renderItems': renderItems,
  //     'mobKey': GlobalKey(debugLabel: 'MOBKey'),
  //     'settingsKey': GlobalKey(debugLabel: 'SettingsKey'),
  //     'searchKey': GlobalKey(debugLabel: 'SearchKey'),
  //     'titleKey': GlobalKey(debugLabel: 'TitleKey'),
  //     'transitionKey': 'emergencies_${DateTime.now().millisecondsSinceEpoch}',
  //     'transitionType': TransitionType.slide,
  //     'slideFrom': SlideDirection.left,
  //   },
  // );
}

//   showDialog(
//     context: localContext,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text(
//           '🚨 Man Overboard!',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Timestamp:', style: TextStyle(fontWeight: FontWeight.bold)),
//             SelectableText(formattedTime),
//             const SizedBox(height: 12),
//             Text(
//               'GPS Coordinates:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             SelectableText(gpsText),
//             const SizedBox(height: 16),
//             const Text(
//               'Immediate Steps:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             const Text('1. Shout "Man Overboard"'),
//             const Text('2. Assign a spotter'),
//             const Text('3. Activate MOB alarm/GPS'),
//             const Text('4. Begin safe retrieval'),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.warning_amber_rounded),
//               label: const Text('Other Emergencies'),
//               onPressed: () {
//                 logger.i('🆘 Other Emergencies button tapped');
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: const Text('Close'),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ],
//       );
//     },
//   );
// }
