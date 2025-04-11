import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/location_helper.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MOBEmergencyScreen extends StatefulWidget {
  const MOBEmergencyScreen({super.key});

  @override
  State<MOBEmergencyScreen> createState() => _MOBEmergencyScreenState();
}

class _MOBEmergencyScreenState extends State<MOBEmergencyScreen> {
  Position? _lockedPosition;
  late DateTime _timestamp;
  GPSDisplayFormat _format = GPSDisplayFormat.marineCompact;

  @override
  @override
  void initState() {
    super.initState();
    _timestamp = DateTime.now();
    _loadFormat();
    _lockInitialGPS();
  }

  void _lockInitialGPS() async {
    final pos = await getCurrentLocation();
    if (mounted) {
      setState(() => _lockedPosition = pos);
    }
  }

  void _loadFormat() async {
    final saved = await SettingsManager.getGPSDisplayFormat();
    if (mounted) setState(() => _format = saved);
  }

  void _setFormat(GPSDisplayFormat newFormat) {
    setState(() {
      _format = newFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.i('🚨 MOB Emergency Screen opened');

    final formattedTime = _timestamp.toLocal().toString().split('.').first;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red.shade700,
        title: Row(
          children: [
            Icon(MdiIcons.lifebuoy, color: Colors.white, size: 32),
            const SizedBox(width: 12),
            const Text(
              'Man Overboard!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final position = _lockedPosition;
          String gpsText = 'Unavailable';

          if (position != null) {
            final lat = position.latitude;
            final lon = position.longitude;

            switch (_format) {
              case GPSDisplayFormat.marineCompact:
                gpsText =
                    '${formatToMarineCoord(lat, isLat: true)}   ${formatToMarineCoord(lon, isLat: false)}';
                break;
              case GPSDisplayFormat.decimal:
                gpsText =
                    '${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)}';
                break;
              case GPSDisplayFormat.marineFull:
                gpsText =
                    '${formatToMarineCoord(lat, isLat: true, full: true)}   ${formatToMarineCoord(lon, isLat: false, full: true)}';
                break;
            }
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                SelectableText(formattedTime),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PopupMenuButton<GPSDisplayFormat>(
                      tooltip: 'Change GPS format',
                      onSelected: _setFormat,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppTheme.primaryBlue,
                      ),
                      itemBuilder:
                          (context) => const [
                            PopupMenuItem(
                              value: GPSDisplayFormat.marineCompact,
                              child: Text('DMM (Marine Style)'),
                            ),
                            PopupMenuItem(
                              value: GPSDisplayFormat.marineFull,
                              child: Text('DMS (Older Charts)'),
                            ),
                            PopupMenuItem(
                              value: GPSDisplayFormat.decimal,
                              child: Text('DD (Decimal)'),
                            ),
                          ],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SelectableText(
                        gpsText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Text(
                  'Immediate Steps:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('1. Shout "Man Overboard!" loudly and clearly.'),
                const Text('2. Assign a spotter to maintain visual contact.'),
                const Text('3. Throw a flotation device immediately.'),
                const Text('4. Press MOB on GPS/chartplotter if available.'),
                const Text('5. Radio Coast Guard with MAY DAY.'),
                const SizedBox(height: 12),
                const Text(
                  'Initiate Rescue:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('6. Note wind and current direction.'),
                const Text('7. Maneuver vessel back under control.'),
                const Text('8. Approach from downwind or leeward side.'),
                const Text('9. Retrieve crew using LifeSling or ladder.'),
                const Text(
                  '10. Check injuries; administer first aid if needed.',
                ),
                const Text('11. Notify authorities if unresolved.'),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  label: const Text('Other Emergencies'),
                  onPressed: () {
                    logger.i('🆘 Other Emergencies button tapped');

                    Navigator.of(context).pop();

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go(
                        '/tools/items',
                        extra: {
                          'toolbag': 'procedures',
                          'transitionKey': UniqueKey(),
                        },
                      );
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final newPos = await getCurrentLocation();
                        if (!mounted) return;
                        setState(() {
                          _timestamp = DateTime.now();
                          _lockedPosition = newPos;
                        });
                        logger.i(
                          '📍 GPS updated to: ${newPos?.latitude}, ${newPos?.longitude}',
                        );
                      },
                      icon: const Icon(Icons.gps_fixed),
                      label: const Text('Update GPS'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _lockedPosition = null;
                        });
                        logger.w('🗑️ GPS coordinate cleared by user.');
                      },
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Clear GPS'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
