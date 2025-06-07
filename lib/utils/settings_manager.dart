// 📄 lib/utils/settings_manager.dart

import 'package:shared_preferences/shared_preferences.dart';

enum GPSDisplayFormat {
  marineCompact, // e.g., 37°46.493'N
  decimal, // e.g., 37.7749°, -122.4194°
  marineFull, // e.g., 37°46'29.6"N
}

class SettingsManager {
  // Preference keys
  static const _gpsFormatKey = 'gpsDisplayFormat';
  static const _boatNameKey = 'boatName';
  static const _vesselTypeKey = 'vesselType';
  static const _vesselLengthKey = 'vesselLength';
  static const _vesselDescriptionKey = 'vesselDescription';
  static const _soulsAdultsKey = 'soulsAdults';
  static const _soulsChildrenKey = 'soulsChildren';
  static const _mmsiKey = 'mmsi';
  static const _emergencyContactKey = 'emergencyContact';
  static const _captainPhoneKey = 'captainPhone';
  static const _emergencyReminderEnabledKey = 'emergencyReminderEnabled';

  static Future<void> setGPSDisplayFormat(GPSDisplayFormat format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_gpsFormatKey, format.index);
  }

  static Future<GPSDisplayFormat> getGPSDisplayFormat() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_gpsFormatKey);
    return GPSDisplayFormat.values[index ?? 0]; // Default: marineCompact
  }

  // defaults for emergency info
  static Future<void> seedEmergencyDefaultsIfNeeded() async {
    if ((await getBoatName()).trim().isEmpty) {
      await setBoatName('Unnamed Vessel');
    }

    if ((await getVesselType()).trim().isEmpty) {
      await setVesselType('Sailing');
    }

    if ((await getVesselLength()).trim().isEmpty) {
      await setVesselLength('0');
    }

    if ((await getLengthUnit()).trim().isEmpty) {
      await setLengthUnit('feet');
    }

    if ((await getMinimumDepth()).trim().isEmpty) {
      await setMinimumDepth('0');
    }

    if ((await getVesselDescription()).trim().isEmpty) {
      await setVesselDescription('No description provided.');
    }

    if (await getSoulsAdults() == 0) {
      await setSoulsAdults(1); // safer than 0 in case of singlehanders
    }

    if (await getSoulsChildren() == 0) {
      await setSoulsChildren(0);
    }

    if ((await getMMSI()).trim().isEmpty) {
      await setMMSI('000000000');
    }

    if ((await getCoastGuardPhone()).trim().isEmpty) {
      await setCoastGuardPhone('000-000-0000');
    }

    if ((await getCaptainPhone()).trim().isEmpty) {
      await setCaptainPhone('000-000-0000');
    }

    if ((await getEmergencyContactName()).trim().isEmpty) {
      await setEmergencyContactName('Emergency Contact');
    }

    if ((await getEmergencyContact()).trim().isEmpty) {
      await setEmergencyContact('000-000-0000');
    }
  }

  // Emergency Info Reminder
  static Future<bool> shouldShowEmergencyReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final firstLaunchComplete = prefs.getBool('firstLaunchComplete') ?? false;
    final reminderEnabled = await getEmergencyReminderEnabled();
    return !firstLaunchComplete && reminderEnabled;
  }

  static Future<bool> getEmergencyReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_emergencyReminderEnabledKey) ?? true;
  }

  static Future<void> setEmergencyReminderEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emergencyReminderEnabledKey, value);
  }

  // Boat Info
  static Future<String> getBoatName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_boatNameKey) ?? '';
  }

  static Future<void> setBoatName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_boatNameKey, name);
  }

  static Future<String> getVesselType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_vesselTypeKey) ?? '';
  }

  static Future<void> setVesselType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vesselTypeKey, type);
  }

  static Future<String> getVesselLength() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_vesselLengthKey) ?? '';
  }

  static Future<void> setVesselLength(String length) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vesselLengthKey, length);
  }

  static Future<String> getVesselDescription() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_vesselDescriptionKey) ?? '';
  }

  static Future<void> setVesselDescription(String description) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vesselDescriptionKey, description);
  }

  static Future<int> getSoulsAdults() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_soulsAdultsKey) ?? 0;
  }

  static Future<void> setSoulsAdults(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_soulsAdultsKey, count);
  }

  static Future<int> getSoulsChildren() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_soulsChildrenKey) ?? 0;
  }

  static Future<void> setSoulsChildren(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_soulsChildrenKey, count);
  }

  static Future<String> getMMSI() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_mmsiKey) ?? '';
  }

  static Future<void> setMMSI(String mmsi) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mmsiKey, mmsi);
  }

  static Future<String> getEmergencyContact() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emergencyContactKey) ?? '';
  }

  static Future<void> setEmergencyContact(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emergencyContactKey, phone);
  }

  static Future<String> getCaptainPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_captainPhoneKey) ?? '';
  }

  static Future<void> setCaptainPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_captainPhoneKey, phone);
  }

  static const _emergencyInfoReviewedKey = 'emergencyInfoReviewedAt';

  static Future<String?> getEmergencyInfoReviewedAt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emergencyInfoReviewedKey);
  }

  static Future<void> setEmergencyInfoReviewedNow() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    await prefs.setString(_emergencyInfoReviewedKey, now);
  }

  static Future<void> clearEmergencyInfoReviewed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emergencyInfoReviewedKey);
  }

  static Future<String> getUnitPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('unitPreference') ?? 'feet'; // default to feet
  }

  static const _lengthUnitKey = 'lengthUnit';
  static const _minimumDepthKey = 'minimumDepth';
  static const _coastGuardPhoneKey = 'coastGuardPhone';
  static const _emergencyContactNameKey = 'emergencyContactName';

  static Future<String> getLengthUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lengthUnitKey) ?? 'feet';
  }

  static Future<void> setLengthUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lengthUnitKey, unit);
  }

  static Future<String> getMinimumDepth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_minimumDepthKey) ?? '';
  }

  static Future<void> setMinimumDepth(String depth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_minimumDepthKey, depth);
  }

  static Future<String> getCoastGuardPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_coastGuardPhoneKey) ?? '';
  }

  static Future<void> setCoastGuardPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_coastGuardPhoneKey, phone);
  }

  static Future<String> getEmergencyContactName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emergencyContactNameKey) ?? '';
  }

  static Future<void> setEmergencyContactName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emergencyContactNameKey, name);
  }
}
