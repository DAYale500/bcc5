// lib/widgets/dialogs/emergency_reminder_dialog.dart

import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/emergency_info_modal.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/utils/settings_manager.dart';
import 'package:bcc5/utils/vessel_formatting.dart';

Future<void> showEmergencyReminderDialog(BuildContext context) async {
  final boatName = await SettingsManager.getBoatName();
  final vesselType = await SettingsManager.getVesselType();
  final vesselLength = await SettingsManager.getVesselLength();
  final lengthUnit = await SettingsManager.getLengthUnit();
  final minDepth = await SettingsManager.getMinimumDepth();
  final vesselDescription = await SettingsManager.getVesselDescription();
  final adults = await SettingsManager.getSoulsAdults();
  final children = await SettingsManager.getSoulsChildren();
  final mmsi = await SettingsManager.getMMSI();
  final emergencyPhone = await SettingsManager.getEmergencyContact();
  final captainPhone = await SettingsManager.getCaptainPhone();
  final coastGuardPhone = await SettingsManager.getCoastGuardPhone();
  final emergencyName = await SettingsManager.getEmergencyContactName();
  final formattedDepth = lengthUnit == 'meters' ? '$minDepth m' : minDepth;

  final prefix = getVesselPrefix(vesselType);

  logger.i('''
🛟 Emergency Reminder Data:
- Vessel: $prefix $boatName
- Length: $vesselLength $lengthUnit
- Min Depth: $minDepth
- Description: $vesselDescription
- Adults: $adults
- Children: $children
- MMSI: $mmsi
- Coast Guard: $coastGuardPhone
- Captain: $captainPhone
- Emergency Contact: $emergencyName
- Emergency Phone: $emergencyPhone
''');

  if (context.mounted) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(24),
          titlePadding: EdgeInsets.zero,
          title: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Review Vessel & Safety Info',
                  style: AppTheme.modalTitle,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$prefix $boatName'),
              Text('Length: $vesselLength $lengthUnit'),
              if (minDepth.isNotEmpty) Text('Minimum Depth: $formattedDepth'),
              if (vesselDescription.isNotEmpty)
                Text('Description: $vesselDescription'),
              Text(
                'Souls Aboard: $adults adult${adults != 1 ? 's' : ''}, $children child${children != 1 ? 'ren' : ''}',
              ),
              if (mmsi.isNotEmpty) Text('MMSI: $mmsi'),
              if (coastGuardPhone.isNotEmpty)
                Text('Coast Guard Emergency: $coastGuardPhone'),
              Text("Captain's Phone: $captainPhone"),
              if (emergencyName.isNotEmpty)
                Text('Emergency Contact: $emergencyName'),
              if (emergencyPhone.isNotEmpty)
                Text('Emergency Phone: $emergencyPhone'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                logger.i('✅ User tapped "Looks Good" — saving reviewedAt');
                await SettingsManager.setEmergencyInfoReviewedNow();
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Looks Good'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showEmergencyInfoModal(context);
              },
              child: const Text('Edit Emergency Info'),
            ),
          ],
        );
      },
    );
  }
}







// import 'package:bcc5/theme/app_theme.dart';
// import 'package:bcc5/widgets/emergency_info_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:bcc5/utils/settings_manager.dart';
// import 'package:bcc5/utils/vessel_formatting.dart';

// Future<void> showEmergencyReminderDialog(BuildContext context) async {
//   final boatName = await SettingsManager.getBoatName();
//   final vesselType = await SettingsManager.getVesselType();
//   final vesselLength = await SettingsManager.getVesselLength();
//   final lengthUnit = await SettingsManager.getLengthUnit();
//   final minDepth = await SettingsManager.getMinimumDepth();
//   final vesselDescription = await SettingsManager.getVesselDescription();
//   final adults = await SettingsManager.getSoulsAdults();
//   final children = await SettingsManager.getSoulsChildren();
//   final mmsi = await SettingsManager.getMMSI();
//   final emergencyPhone = await SettingsManager.getEmergencyContact();
//   final captainPhone = await SettingsManager.getCaptainPhone();
//   final coastGuardPhone = await SettingsManager.getCoastGuardPhone(); // ✅ NEW
//   final emergencyName = await SettingsManager.getEmergencyContactName();

//   if (context.mounted) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           insetPadding: const EdgeInsets.all(24),
//           titlePadding: EdgeInsets.zero,
//           title: Stack(
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   'Review Vessel & Safety Info',
//                   style: AppTheme.modalTitle,
//                 ),
//               ),
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: IconButton(
//                   icon: const Icon(Icons.close),
//                   tooltip: 'Close',
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('${getVesselPrefix(vesselType)} $boatName'),
//               Text('Phonetic: ${formatPhonetic(boatName)}'),
//               Text('Length: $vesselLength $lengthUnit'),
//               if (minDepth.isNotEmpty) Text('Minimum Depth: $minDepth'),
//               if (vesselDescription.isNotEmpty)
//                 Text('Description: $vesselDescription'),
//               Text(
//                 'Souls Aboard: $adults adult${adults != 1 ? 's' : ''}, $children child${children != 1 ? 'ren' : ''}',
//               ),
//               if (mmsi.isNotEmpty) Text('MMSI: $mmsi'),
//               if (coastGuardPhone.isNotEmpty)
//                 Text('Coast Guard Emergency: $coastGuardPhone'), // ✅ NEW
//               Text("Captain's Phone: $captainPhone"),
//               if (emergencyName.isNotEmpty)
//                 Text('Emergency Contact: $emergencyName'),
//               if (emergencyPhone.isNotEmpty)
//                 Text('Emergency Phone: $emergencyPhone'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 await SettingsManager.setEmergencyInfoReviewedNow();
//                 if (context.mounted) Navigator.of(context).pop();
//               },
//               child: const Text('Looks Good'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 showEmergencyInfoModal(context);
//               },
//               child: const Text('Edit Emergency Info'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }




// // import 'package:bcc5/theme/app_theme.dart';
// // import 'package:bcc5/widgets/emergency_info_modal.dart';
// // import 'package:flutter/material.dart';
// // import 'package:bcc5/utils/settings_manager.dart';

// // Future<void> showEmergencyReminderDialog(BuildContext context) async {
// //   final boatName = await SettingsManager.getBoatName();
// //   final vesselType = await SettingsManager.getVesselType();
// //   final vesselLength = await SettingsManager.getVesselLength();
// //   final lengthUnit = await SettingsManager.getLengthUnit();
// //   final minDepth = await SettingsManager.getMinimumDepth();
// //   final vesselDescription = await SettingsManager.getVesselDescription();
// //   final adults = await SettingsManager.getSoulsAdults();
// //   final children = await SettingsManager.getSoulsChildren();
// //   final mmsi = await SettingsManager.getMMSI();
// //   final emergencyPhone = await SettingsManager.getEmergencyContact();
// //   final captainPhone = await SettingsManager.getCaptainPhone();
// //   final emergencyName = await SettingsManager.getEmergencyContactName();

// //   if (context.mounted) {
// //     showDialog(
// //       context: context,
// //       builder: (_) {
// //         return AlertDialog(
// //           insetPadding: const EdgeInsets.all(24),
// //           titlePadding: EdgeInsets.zero,
// //           title: Stack(
// //             children: [
// //               const Padding(
// //                 padding: EdgeInsets.all(16.0),
// //                 child: Text(
// //                   'Review Vessel & Safety Info',
// //                   style: AppTheme.modalTitle,
// //                 ),
// //               ),
// //               Positioned(
// //                 top: 0,
// //                 right: 0,
// //                 child: IconButton(
// //                   icon: const Icon(Icons.close),
// //                   tooltip: 'Close',
// //                   onPressed: () {
// //                     Navigator.of(context).pop();
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text('$vesselType Vessel $boatName'),
// //               Text('Length: $vesselLength $lengthUnit'),
// //               if (minDepth.isNotEmpty) Text('Minimum Depth: $minDepth'),
// //               if (vesselDescription.isNotEmpty)
// //                 Text('Description: $vesselDescription'),
// //               Text(
// //                 'Souls Aboard: $adults adult${adults != 1 ? 's' : ''}, $children child${children != 1 ? 'ren' : ''}',
// //               ),
// //               if (mmsi.isNotEmpty) Text('MMSI: $mmsi'),
// //               Text("Captain's Phone: $captainPhone"),
// //               if (emergencyName.isNotEmpty)
// //                 Text('Emergency Contact: $emergencyName'),
// //               if (emergencyPhone.isNotEmpty)
// //                 Text('Emergency Phone: $emergencyPhone'),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () async {
// //                 await SettingsManager.setEmergencyInfoReviewedNow();
// //                 if (context.mounted) Navigator.of(context).pop();
// //               },
// //               child: const Text('Looks Good'),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //                 showEmergencyInfoModal(context);
// //               },
// //               child: const Text('Edit Emergency Info'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }




// // // import 'package:bcc5/theme/app_theme.dart';
// // // import 'package:bcc5/utils/logger.dart';
// // // import 'package:bcc5/widgets/emergency_info_modal.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:bcc5/utils/settings_manager.dart';

// // // Future<void> showEmergencyReminderDialog(BuildContext context) async {
// // //   logger.i('📦 Entered showEmergencyReminderDialog()');

// // //   final boatName = await SettingsManager.getBoatName();
// // //   final vesselType = await SettingsManager.getVesselType();
// // //   final vesselLength = await SettingsManager.getVesselLength();
// // //   final lengthUnit = await SettingsManager.getLengthUnit();
// // //   final minDepth = await SettingsManager.getMinimumDepth();
// // //   final vesselDescription = await SettingsManager.getVesselDescription();
// // //   final adults = await SettingsManager.getSoulsAdults();
// // //   final children = await SettingsManager.getSoulsChildren();
// // //   final mmsi = await SettingsManager.getMMSI();
// // //   final emergencyPhone = await SettingsManager.getEmergencyContact();
// // //   final captainPhone = await SettingsManager.getCaptainPhone();
// // //   final emergencyName = await SettingsManager.getEmergencyContactName();

// // //   logger.i('📦 Loaded all emergency settings');

// // //   if (context.mounted) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (_) {
// // //         return AlertDialog(
// // //           insetPadding: const EdgeInsets.all(24),
// // //           titlePadding: EdgeInsets.zero,
// // //           title: Stack(
// // //             children: [
// // //               const Padding(
// // //                 padding: EdgeInsets.all(16.0),
// // //                 child: Text(
// // //                   'Review Vessel & Safety Info',
// // //                   style: AppTheme.modalTitle,
// // //                 ),
// // //               ),
// // //               Positioned(
// // //                 top: 0,
// // //                 right: 0,
// // //                 child: IconButton(
// // //                   icon: const Icon(Icons.close),
// // //                   tooltip: 'Close',
// // //                   onPressed: () {
// // //                     Navigator.of(context).pop();
// // //                   },
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           content: Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text('Boat Name: $boatName'),
// // //               Text('Type: $vesselType'),
// // //               Text('Length: $vesselLength $lengthUnit'),
// // //               if (minDepth.isNotEmpty) Text('Minimum Depth: $minDepth'),
// // //               if (vesselDescription.isNotEmpty)
// // //                 Text('Description: $vesselDescription'),
// // //               Text(
// // //                 'Souls Aboard: $adults adult${adults != 1 ? 's' : ''}, $children child${children != 1 ? 'ren' : ''}',
// // //               ),
// // //               if (mmsi.isNotEmpty) Text('MMSI: $mmsi'),
// // //               Text("Captain's Phone: $captainPhone"),
// // //               if (emergencyName.isNotEmpty)
// // //                 Text('Emergency Contact: $emergencyName'),
// // //               if (emergencyPhone.isNotEmpty)
// // //                 Text('Emergency Phone: $emergencyPhone'),
// // //             ],
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () async {
// // //                 await SettingsManager.setEmergencyInfoReviewedNow();
// // //                 if (context.mounted) Navigator.of(context).pop();
// // //               },
// // //               child: const Text('Looks Good'),
// // //             ),
// // //             TextButton(
// // //               onPressed: () {
// // //                 Navigator.of(context).pop();
// // //                 showEmergencyInfoModal(context);
// // //               },
// // //               child: const Text('Edit Emergency Info'),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // // }




// // // // import 'package:bcc5/theme/app_theme.dart';
// // // // import 'package:bcc5/utils/logger.dart';
// // // // import 'package:bcc5/widgets/emergency_info_modal.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:bcc5/utils/settings_manager.dart';

// // // // Future<void> showEmergencyReminderDialog(BuildContext context) async {
// // // //   logger.i('📦 Entered showEmergencyReminderDialog()');

// // // //   final boatName = await SettingsManager.getBoatName();
// // // //   logger.i('📦 boatName = $boatName');

// // // //   final vesselType = await SettingsManager.getVesselType();
// // // //   logger.i('📦 vesselType = $vesselType');

// // // //   final vesselLength = await SettingsManager.getVesselLength();
// // // //   logger.i('📦 vesselLength = $vesselLength');

// // // //   final vesselDescription = await SettingsManager.getVesselDescription();
// // // //   logger.i('📦 vesselDescription = $vesselDescription');

// // // //   final adults = await SettingsManager.getSoulsAdults();
// // // //   logger.i('📦 adults = $adults');

// // // //   final children = await SettingsManager.getSoulsChildren();
// // // //   logger.i('📦 children = $children');

// // // //   final mmsi = await SettingsManager.getMMSI();
// // // //   logger.i('📦 mmsi = $mmsi');

// // // //   final emergencyPhone = await SettingsManager.getEmergencyContact();
// // // //   logger.i('📦 emergencyPhone = $emergencyPhone');

// // // //   final captainPhone = await SettingsManager.getCaptainPhone();
// // // //   logger.i('📦 captainPhone = $captainPhone');

// // // //   if (context.mounted) {
// // // //     logger.i('📦 Showing AlertDialog...');

// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (_) {
// // // //         logger.i('📦 AlertDialog builder executed');

// // // //         return AlertDialog(
// // // //           insetPadding: const EdgeInsets.all(24),
// // // //           titlePadding: EdgeInsets.zero,
// // // //           title: Stack(
// // // //             children: [
// // // //               const Padding(
// // // //                 padding: EdgeInsets.all(16.0),
// // // //                 child: Text(
// // // //                   'Review Vessel & Safety Info',
// // // //                   style: AppTheme.modalTitle,
// // // //                 ),
// // // //               ),
// // // //               Positioned(
// // // //                 top: 0,
// // // //                 right: 0,
// // // //                 child: IconButton(
// // // //                   icon: const Icon(Icons.close),
// // // //                   tooltip: 'Close',
// // // //                   onPressed: () {
// // // //                     Navigator.of(context).pop();
// // // //                   },
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           content: Column(
// // // //             mainAxisSize: MainAxisSize.min,
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               Text('Boat Name: $boatName'),
// // // //               Text('Type: $vesselType'),
// // // //               Text('Length: $vesselLength'),
// // // //               Text('Description: $vesselDescription'),
// // // //               Text('Souls Aboard: $adults adults, $children children'),
// // // //               Text('MMSI: $mmsi'),
// // // //               Text('Emergency Contact: $emergencyPhone'),
// // // //               Text("Captain's Phone: $captainPhone"),
// // // //             ],
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () async {
// // // //                 await SettingsManager.setEmergencyInfoReviewedNow();
// // // //                 if (context.mounted) Navigator.of(context).pop();
// // // //               },
// // // //               child: const Text('Looks Good'),
// // // //             ),
// // // //             TextButton(
// // // //               onPressed: () {
// // // //                 Navigator.of(context).pop();
// // // //                 showEmergencyInfoModal(context);
// // // //               },
// // // //               child: const Text('Edit Emergency Info'),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // // }


// // // //             // TextButton(
// // // //             //   onPressed: () {
// // // //             //     Navigator.pop(context);
// // // //             //     SettingsManager.setEmergencyInfoReviewedNow(); // ✅ this is your actual method name
// // // //             //   },
// // // //             //   child: const Text('Looks Good'),
// // // //             // ),