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
  logger.i('📍 Got location: ${position.latitude}, ${position.longitude}');
  return position;
}
