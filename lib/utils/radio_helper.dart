// 📄 lib/utils/radio_helper.dart

import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/settings_manager.dart';

String formatPhonetic(String name) {
  final nato = {
    'a': 'Alpha',
    'b': 'Bravo',
    'c': 'Charlie',
    'd': 'Delta',
    'e': 'Echo',
    'f': 'Foxtrot',
    'g': 'Golf',
    'h': 'Hotel',
    'i': 'India',
    'j': 'Juliet',
    'k': 'Kilo',
    'l': 'Lima',
    'm': 'Mike',
    'n': 'November',
    'o': 'Oscar',
    'p': 'Papa',
    'q': 'Quebec',
    'r': 'Romeo',
    's': 'Sierra',
    't': 'Tango',
    'u': 'Uniform',
    'v': 'Victor',
    'w': 'Whiskey',
    'x': 'X-ray',
    'y': 'Yankee',
    'z': 'Zulu',
  };

  return name
      .toLowerCase()
      .split('')
      .map((char) {
        if (nato.containsKey(char)) return nato[char]!;
        if (RegExp(r'[0-9]').hasMatch(char)) return char; // numbers stay as-is
        return char.toUpperCase(); // fallback for symbols
      })
      .join(' ');
}

String formatSoulsOnboard(int adults, int children) {
  if (adults == 0 && children == 0) {
    return 'Total number of people onboard is unknown.';
  }
  if (adults > 0 && children == 0) {
    return 'We have $adults adult${adults > 1 ? 's' : ''} onboard.';
  }
  if (adults == 0 && children > 0) {
    return 'We have $children child${children > 1 ? 'ren' : ''} onboard.';
  }
  return 'We have $adults adult${adults > 1 ? 's' : ''} and $children child${children > 1 ? 'ren' : ''} onboard.';
}

String formatGPSForRadio(double lat, double lon, GPSDisplayFormat format) {
  switch (format) {
    case GPSDisplayFormat.marineCompact:
      return '${_speakMarineCoord(lat, isLat: true)}\n'
          '${_speakMarineCoord(lon, isLat: false)}';

    case GPSDisplayFormat.marineFull:
      return '${_speakMarineCoord(lat, isLat: true, full: true)}\n'
          '${_speakMarineCoord(lon, isLat: false, full: true)}';

    case GPSDisplayFormat.decimal:
      return 'Latitude: ${lat.toStringAsFixed(5)} degrees\n'
          'Longitude: ${lon.toStringAsFixed(5)} degrees';
  }
}

String _speakMarineCoord(
  double decimal, {
  required bool isLat,
  bool full = false,
}) {
  final direction =
      isLat
          ? (decimal >= 0 ? 'North' : 'South')
          : (decimal >= 0 ? 'East' : 'West');

  final abs = decimal.abs();
  final degrees = abs.floor();
  final minutesDecimal = (abs - degrees) * 60;

  final spokenDegrees = _speakDigits(degrees.toString());

  if (full) {
    final minutes = minutesDecimal.floor();
    final seconds = ((minutesDecimal - minutes) * 60).round();
    final spokenMinutes = _speakDigits(minutes.toString());
    final spokenSeconds = _speakDigits(seconds.toString());
    return '$spokenDegrees degrees, $spokenMinutes minutes, $spokenSeconds seconds $direction';
  } else {
    final parts = minutesDecimal.toStringAsFixed(3).split('.');
    final spokenMinutesWhole = _speakDigits(parts[0]);
    final spokenMinutesDecimal = _speakDigits(parts[1]);
    return '$spokenDegrees degrees decimal $spokenMinutesWhole decimal $spokenMinutesDecimal minutes $direction';
  }
}

String _speakDigits(String numberStr) {
  const digitWords = [
    'zero',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
  ];

  return numberStr
      .split('')
      .map((char) => digitWords[int.parse(char)])
      .join('-');
}

// Future<String> buildPhoneticVesselIntro() async {
//   final boatName = await SettingsManager.getBoatName();
//   final type = await SettingsManager.getVesselType();
//   final fullName = "$type $boatName".trim();
//   final phonetic = formatPhonetic(fullName);
//   return 'This is $type $phonetic.';
// }

Future<String> buildPhoneticVesselIntro() async {
  final boatName = await SettingsManager.getBoatName();
  final type = await SettingsManager.getVesselType();

  if (boatName.isEmpty || type.isEmpty) {
    logger.w('⚠️ Missing boat name or vessel type in buildPhoneticVesselIntro');
  }

  final fullName = boatName.trim();
  final phonetic = formatPhonetic(fullName);

  return 'This is the $type $fullName, $fullName, $fullName: $phonetic';
}

String getPluralizedUnit(String unit, String length) {
  final isSingular = length == '1';

  if (unit == 'meters') {
    return isSingular ? 'meter' : 'meters';
  } else {
    return isSingular ? 'foot' : 'feet';
  }
}

Future<String> buildSpokenVesselDescription() async {
  final length = (await SettingsManager.getVesselLength()).trim();
  final type = (await SettingsManager.getVesselType()).trim();
  final description = (await SettingsManager.getVesselDescription()).trim();
  final unit =
      (await SettingsManager.getUnitPreference())
          .trim()
          .toLowerCase(); // 'feet' or 'meters'

  if (length.isEmpty || type.isEmpty) {
    logger.w(
      '⚠️ Missing vessel length or type in buildSpokenVesselDescription',
    );
  }

  final unitLabel = unit == 'meters' ? 'meter' : 'foot';
  final hyphenated = '$length-$unitLabel $type';

  if (description.isNotEmpty) {
    return 'We are a $hyphenated, with ${description.trim()}.';
  } else {
    return 'We are a $hyphenated.';
  }
}

String formatSpokenDigits(String input) {
  final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  return digits.split('').map(_digitToWord).join('-');
}

String _digitToWord(String d) {
  const map = {
    '0': 'zero',
    '1': 'one',
    '2': 'two',
    '3': 'three',
    '4': 'four',
    '5': 'five',
    '6': 'six',
    '7': 'seven',
    '8': 'eight',
    '9': 'nine',
  };
  return map[d] ?? d;
}
