import 'package:bcc5/screens/emergency/mob_emergency_screen.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bcc5/utils/location_helper.dart';

void showMOBModal(BuildContext context) {
  final now = DateTime.now();
  final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  final navigator = Navigator.of(context); // ✅ capture immediately
  getCurrentLocation().then((position) {
    final gpsText =
        position != null
            ? '${position.latitude}, ${position.longitude}'
            : 'Unavailable';

    logger.i('🚨 MOB Modal triggered at $formattedTime with coords: $gpsText');

    navigator.push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const MOBEmergencyScreen(),
      ),
    );
  });
}
