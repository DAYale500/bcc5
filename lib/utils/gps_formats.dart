// lib/utils/gps_formats.dart

class GpsCoord {
  final double lat; // decimal degrees
  final double lon; // decimal degrees
  const GpsCoord(this.lat, this.lon);
}

enum CoordFormat { dd, dmm, dms }

class ParseResult {
  final GpsCoord coord;
  final CoordFormat format;
  const ParseResult(this.coord, this.format);
}

class GpsFormats {
  // ───────────────────────── Public API
  static ParseResult? tryParse(String raw) {
    final s = _normalize(raw);
    if (s.isEmpty) return null;

    // 1) DD first (pure decimals are unambiguous)
    final dd = _parseDD(s);
    if (dd != null) return ParseResult(dd, CoordFormat.dd);

    // 2) Then DMM, then DMS
    final dmm = _parseDMM(s);
    if (dmm != null) return ParseResult(dmm, CoordFormat.dmm);

    final dms = _parseDMS(s);
    if (dms != null) return ParseResult(dms, CoordFormat.dms);

    return null;
  }

  // ───────────────────────── Formatters
  static String toDD(GpsCoord c) {
    String f(double v) => v.toStringAsFixed(6);
    return '${f(c.lat)}, ${f(c.lon)}';
  }

  static String toDMM(GpsCoord c) {
    String fmt(double deg, bool isLat) {
      final hemi = _hemi(deg, isLat);
      final abs = deg.abs();
      final d = abs.floor();
      final m = (abs - d) * 60.0;
      return "$hemi $d° ${m.toStringAsFixed(3)}'";
    }

    return '${fmt(c.lat, true)}  ${fmt(c.lon, false)}';
  }

  static String toDMS(GpsCoord c) {
    String fmt(double deg, bool isLat) {
      final hemi = _hemi(deg, isLat);
      final abs = deg.abs();
      final d = abs.floor();
      final minF = (abs - d) * 60.0;
      final m = minF.floor();
      final s = (minF - m) * 60.0;
      return '$hemi $d° ${_pad2(m)}\' ${s.toStringAsFixed(2)}"';
    }

    return '${fmt(c.lat, true)}  ${fmt(c.lon, false)}';
  }

  // ───────────────────────── Parsers
  // Accepts: N 37° 47' 9.12"  W 122° 24' 23.1"
  static GpsCoord? _parseDMS(String s) {
    // Accepts: N 37° 4' 33" [ , ; | or space ] W 122° 45' 12"
    // Degree/minute/second symbols are optional if spacing is present.
    final re = RegExp(
      '([NS])?\\s*([+\\-]?\\d{1,2})(?:\\s*°|\\s+)?\\s*(\\d{1,2})(?:\\s*\\\'|\\s+)?\\s*(\\d{1,2}(?:\\.\\d+)?)(?:\\s*"|\\s+)?(?:\\s*(?:,|;|\\|)\\s*|\\s+)([EW])?\\s*([+\\-]?\\d{1,3})(?:\\s*°|\\s+)?\\s*(\\d{1,2})(?:\\s*\\\'|\\s+)?\\s*(\\d{1,2}(?:\\.\\d+)?)(?:\\s*"|\\s+)?',
      caseSensitive: false,
    );

    final m = re.firstMatch(s);
    if (m == null) return null;

    final latHem = m.group(1);
    final latD = double.tryParse(m.group(2) ?? '');
    final latM = double.tryParse(m.group(3) ?? '');
    final latS = double.tryParse(m.group(4) ?? '');
    final lonHem = m.group(5);
    final lonD = double.tryParse(m.group(6) ?? '');
    final lonM = double.tryParse(m.group(7) ?? '');
    final lonS = double.tryParse(m.group(8) ?? '');
    if ([latD, latM, latS, lonD, lonM, lonS].any((e) => e == null)) return null;

    final lat = _applyHem(
      _dmsToDec(latD!, latM!, latS!),
      latHem,
      isLat: true,
      signed: latD.isNegative,
    );
    final lon = _applyHem(
      _dmsToDec(lonD!, lonM!, lonS!),
      lonHem,
      isLat: false,
      signed: lonD.isNegative,
    );
    return _valid(lat, lon) ? GpsCoord(lat, lon) : null;
  }

  // Accepts: N 37° 47.150'  W 122° 24.385'
  static GpsCoord? _parseDMM(String s) {
    // Accepts: N 37° 4.56' [ , ; | or space ] W 122° 5.67'
    // Degree/minute symbols are optional if spacing is present.
    final re = RegExp(
      '([NS])?\\s*([+\\-]?\\d{1,2})(?:\\s*°|\\s+)?\\s*(\\d{1,2}(?:\\.\\d+)?)(?:\\s*\\\'|\\s+)?(?:\\s*(?:,|;|\\|)\\s*|\\s+)([EW])?\\s*([+\\-]?\\d{1,3})(?:\\s*°|\\s+)?\\s*(\\d{1,2}(?:\\.\\d+)?)(?:\\s*\\\'|\\s+)?',
      caseSensitive: false,
    );

    final m = re.firstMatch(s);
    if (m == null) return null;

    final latHem = m.group(1);
    final latD = double.tryParse(m.group(2) ?? '');
    final latM = double.tryParse(m.group(3) ?? '');
    final lonHem = m.group(4);
    final lonD = double.tryParse(m.group(5) ?? '');
    final lonM = double.tryParse(m.group(6) ?? '');
    if ([latD, latM, lonD, lonM].any((e) => e == null)) return null;

    final lat = _applyHem(
      _dmmToDec(latD!, latM!),
      latHem,
      isLat: true,
      signed: latD.isNegative,
    );
    final lon = _applyHem(
      _dmmToDec(lonD!, lonM!),
      lonHem,
      isLat: false,
      signed: lonD.isNegative,
    );
    return _valid(lat, lon) ? GpsCoord(lat, lon) : null;
  }

  // Accepts: 37.78583, -122.40642
  // Also: N 37.78583 W 122.40642   or   37.78583 122.40642 (one space)
  // NOTE: both numbers must have a decimal part to avoid clashing with DMM/DMS.
  static GpsCoord? _parseDD(String s) {
    final re = RegExp(
      r'^\s*([NS])?\s*([+\-]?\d+(?:\.\d+))\s*(?:,|;|\||\s)\s*([EW])?\s*([+\-]?\d+(?:\.\d+))\s*$',
      caseSensitive: false,
    );

    final m = re.firstMatch(s);
    if (m == null) return null;

    final latHem = m.group(1);
    final latV = double.tryParse(m.group(2)!);
    final lonHem = m.group(3);
    final lonV = double.tryParse(m.group(4)!);
    if (latV == null || lonV == null) return null;

    final lat = _applyHem(
      latV.abs(),
      latHem,
      isLat: true,
      signed: latV.isNegative,
    );
    final lon = _applyHem(
      lonV.abs(),
      lonHem,
      isLat: false,
      signed: lonV.isNegative,
    );
    return _valid(lat, lon) ? GpsCoord(lat, lon) : null;
  }

  // ───────────────────────── Helpers
  // normalize METHOD
  static String _normalize(String s) {
    return s
        // degree + minutes + seconds variants → standard symbols
        .replaceAll('º', '°')
        .replaceAll('°', '°')
        .replaceAll('’', "'")
        .replaceAll('`', "'")
        .replaceAll('′', "'") // prime → '
        .replaceAll('ʼ', "'") // modifier letter apostrophe → '
        .replaceAll('˝', '"') // double acute → "
        .replaceAll('″', '"') // double prime → "
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        // minus variants
        .replaceAll('−', '-') // unicode minus → hyphen-minus
        .replaceAll('−', '-') // math minus
        .replaceAll('–', '-') // en dash  🟦 ADD
        .replaceAll('—', '-') // em dash  🟦 ADD
        // space variants
        .replaceAll('\u00A0', ' ') // nbsp
        .replaceAll('\u2009', ' ') // thin space
        .replaceAll('\u2002', ' ') // en space
        .replaceAll('\u2003', ' ') // em space
        // collapse repeats, trim
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String _hemi(double v, bool isLat) {
    if (isLat) return v >= 0 ? 'N' : 'S';
    return v >= 0 ? 'E' : 'W';
  }

  static String _pad2(int n) => n.toString().padLeft(2, '0');

  static double _dmmToDec(double d, double m) => d.abs() + (m / 60.0);
  static double _dmsToDec(double d, double m, double s) =>
      d.abs() + (m / 60.0) + (s / 3600.0);

  static double _signed(double v, bool negative) => negative ? -v : v;

  static double _applyHem(
    double absVal,
    String? hemi, {
    required bool isLat,
    required bool signed,
  }) {
    if (hemi == null || hemi.isEmpty) {
      // rely on the sign that came with the number
      return _signed(absVal, signed);
    }
    final h = hemi.toUpperCase();
    if (isLat) return (h == 'S') ? -absVal : absVal;
    return (h == 'W') ? -absVal : absVal;
  }

  static bool _valid(double lat, double lon) =>
      lat.abs() <= 90.0 && lon.abs() <= 180.0;
}
