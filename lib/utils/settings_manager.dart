import 'package:shared_preferences/shared_preferences.dart';

enum GPSDisplayFormat {
  marineCompact, // e.g., 37°46.493'N
  decimal, // e.g., 37.7749°, -122.4194°
  marineFull, // e.g., 37°46'29.6"N
}

class SettingsManager {
  static const _gpsFormatKey = 'gps_display_format';

  static Future<void> setGPSDisplayFormat(GPSDisplayFormat format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_gpsFormatKey, format.index);
  }

  static Future<GPSDisplayFormat> getGPSDisplayFormat() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_gpsFormatKey);
    return GPSDisplayFormat.values[index ?? 0]; // default: marineCompact
  }
}
