// lib/utils/vessel_formatting.dart

String getVesselPrefix(String vesselType) {
  switch (vesselType.toLowerCase()) {
    case 'sailing':
      return 'S/V';
    case 'motor':
      return 'M/V';
    case 'catamaran':
      return 'C/V'; // Or keep 'S/V' if sail-based
    default:
      return 'Vessel';
  }
}

String formatPhonetic(String text) {
  const phoneticMap = {
    'A': 'Alpha',
    'B': 'Bravo',
    'C': 'Charlie',
    'D': 'Delta',
    'E': 'Echo',
    'F': 'Foxtrot',
    'G': 'Golf',
    'H': 'Hotel',
    'I': 'India',
    'J': 'Juliett',
    'K': 'Kilo',
    'L': 'Lima',
    'M': 'Mike',
    'N': 'November',
    'O': 'Oscar',
    'P': 'Papa',
    'Q': 'Quebec',
    'R': 'Romeo',
    'S': 'Sierra',
    'T': 'Tango',
    'U': 'Uniform',
    'V': 'Victor',
    'W': 'Whiskey',
    'X': 'X-ray',
    'Y': 'Yankee',
    'Z': 'Zulu',
  };
  return text
      .toUpperCase()
      .split('')
      .where((c) => phoneticMap.containsKey(c))
      .map((c) => phoneticMap[c]!)
      .join(' ');
}
