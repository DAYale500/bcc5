import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/utils/settings_manager.dart';
import 'package:bcc5/widgets/settings_modal.dart';
import 'package:go_router/go_router.dart';

Future<void> showEmergencyReminderDialog(BuildContext context) async {
  logger.i('📦 Entered showEmergencyReminderDialog()');

  final boatName = await SettingsManager.getBoatName();
  logger.i('📦 boatName = $boatName');

  final vesselType = await SettingsManager.getVesselType();
  logger.i('📦 vesselType = $vesselType');

  final vesselLength = await SettingsManager.getVesselLength();
  logger.i('📦 vesselLength = $vesselLength');

  final vesselDescription = await SettingsManager.getVesselDescription();
  logger.i('📦 vesselDescription = $vesselDescription');

  final adults = await SettingsManager.getSoulsAdults();
  logger.i('📦 adults = $adults');

  final children = await SettingsManager.getSoulsChildren();
  logger.i('📦 children = $children');

  final mmsi = await SettingsManager.getMMSI();
  logger.i('📦 mmsi = $mmsi');

  final emergencyPhone = await SettingsManager.getEmergencyContact();
  logger.i('📦 emergencyPhone = $emergencyPhone');

  final captainPhone = await SettingsManager.getCaptainPhone();
  logger.i('📦 captainPhone = $captainPhone');

  if (context.mounted) {
    logger.i('📦 Showing AlertDialog...');

    showDialog(
      context: context,
      builder: (_) {
        logger.i('📦 AlertDialog builder executed');
        return AlertDialog(
          title: const Text('Review Vessel & Safety Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Boat Name: $boatName'),
              Text('Type: $vesselType'),
              Text('Length: $vesselLength'),
              Text('Description: $vesselDescription'),
              Text('Souls Aboard: $adults adults, $children children'),
              Text('MMSI: $mmsi'),
              Text('Emergency Contact: $emergencyPhone'),
              Text("Captain's Phone: $captainPhone"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                SettingsManager.setEmergencyInfoReviewedNow(); // ✅ this is your actual method name
              },
              child: const Text('Looks Good'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                final routeName =
                    GoRouter.of(
                      context,
                    ).routeInformationProvider.value.uri.path;
                showSettingsModal(context, routeName);
              },
              child: const Text('Edit Settings'),
            ),
          ],
        );
      },
    );
  }
}
