import 'package:geolocator/geolocator.dart';
import 'package:bcc5/utils/logger.dart';

Future<Position?> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    logger.w('📡 Location services are disabled.');
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      logger.w('❌ Location permission denied.');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    logger.e('🚫 Location permissions are permanently denied.');
    return null;
  }

  final position = await Geolocator.getCurrentPosition();
  // logger.i('📍 Got location: ${position.latitude}, ${position.longitude}');
  return position;
}

String formatToMarineCoord(
  double decimal, {
  required bool isLat,
  bool full = false,
}) {
  final direction =
      isLat ? (decimal >= 0 ? 'N' : 'S') : (decimal >= 0 ? 'E' : 'W');

  final abs = decimal.abs();
  final degrees = abs.floor();
  final minutesDecimal = (abs - degrees) * 60;

  if (full) {
    final fullMinutes = minutesDecimal.floor();
    final seconds = ((minutesDecimal - fullMinutes) * 60).toStringAsFixed(1);
    return '$degrees°$fullMinutes\'$seconds"$direction';
  } else {
    final minutes = minutesDecimal.toStringAsFixed(3).padLeft(6, '0');
    return '$direction $degrees° $minutes\'';
  }
}
