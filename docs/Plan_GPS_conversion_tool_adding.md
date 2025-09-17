Plan (outline)

Parsing & detection (new util/repo)

Create lib/data/repositories/gps/gps_conversion_repository.dart

Provide:

parseCoordinates(String input) -> ParsedCoord { lat, lon, detectedFormat }

Formatters: toDD(), toDMM(), toDMS() (all return strings)

Robust detection: handles N/S/E/W, ± signs, spaces/commas, unicode degree/minute/second symbols, mixed delimiters.

UI screen

lib/screens/tools/gps_conversion_screen.dart

Layout: header + single text input (paste/type).

On change -> parse -> show all three representations in stacked cards with copy buttons.

Optional: a small dropdown to force a format if auto-detect fails.

Routing

Add route: '/tools/gps-conversion' -> GpsConversionScreen (slide in from right; same transition type as other tools).

Integration

Add a GPS Conversion button to the Tools (ToolBag) screen (this message includes the code).

(Optionally) index it in your ToolRepositoryIndex later if you want this to behave exactly like other “bags”.

Tests (optional but recommended)

Unit tests for parser edge cases and formatters.