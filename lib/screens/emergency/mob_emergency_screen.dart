import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/screens/emergency/mob_radio_script_modal.dart';
import 'package:bcc5/screens/tools/tool_item_screen.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/location_helper.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bcc5/utils/radio_helper.dart';

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

  void _showRadioScriptModal() async {
    final position = _lockedPosition;
    final lat = position?.latitude ?? 0;
    final lon = position?.longitude ?? 0;

    final gpsSpoken = formatGPSForRadio(lat, lon, _format);
    final intro = await buildPhoneticVesselIntro();
    final description = await buildSpokenVesselDescription();
    final mmsi = await SettingsManager.getMMSI();

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder:
            (_) => MOBRadioScriptModal(
              intro: intro,
              gpsSpoken: gpsSpoken,
              description: description,
              mmsi: mmsi,
            ),
      );
    });
  }

  void _showDSCInfoModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('🚨 How to Use DSC'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'If your radio has a red “Distress” button:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. Lift the red safety cover.\n'
                  '2. Press and hold the button underneath for 5 seconds.\n'
                  '3. The radio will send your location, vessel info, and distress call digitally.\n\n'
                  'This can greatly speed up response time and notify nearby vessels as well.',
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/images/DSC_radio.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                height: 44,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.primaryRed,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        );
      },
    );
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
                    // GPS Text — expand first so it takes as much width as possible
                    Expanded(
                      child: SelectableText(
                        gpsText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                    // Small spacing
                    const SizedBox(width: 4),

                    // Compact dropdown icon (right-aligned, minimal width)
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 0,
                        maxWidth: 32,
                      ),
                      child: PopupMenuButton<GPSDisplayFormat>(
                        tooltip: 'Change GPS format',
                        padding: EdgeInsets.zero,
                        onSelected: _setFormat,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: AppTheme.primaryRed,
                          size: 30,
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
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Text(
                  'Immediate Onboard Actions:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('1. Shout "Man Overboard!" loudly and clearly.'),
                const Text('2. Assign a spotter to maintain visual contact.'),
                const Text('3. Throw flotation devices immediately.'),
                const Text('4. Press MOB on GPS/chartplotter if available.'),
                const Text(
                  '5. Ensure all onboard are wearing PFDs/life jackets.',
                ),
                const Text('6. Radio MAYDAY to Coast Guard.'),

                const SizedBox(height: 6),

                TextButton(
                  style: AppTheme.groupRedButtonStyle,
                  onPressed: _showRadioScriptModal,
                  child: const Text('Ch 16: Radio Script'),
                ),

                const SizedBox(height: 6),

                TextButton(
                  style: AppTheme.groupRedButtonStyle,
                  onPressed: _showDSCInfoModal,
                  child: const Text('DSC Use'),
                ),

                const SizedBox(height: 6),
                const Text(
                  'Continue Rescue:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                const Text('7. Note wind and current direction.'),
                const Text(
                  '8. Maneuver vessel back to MOB under control (esp. sails).',
                ),
                const Text('9. Approach from downwind or leeward side.'),
                const Text(
                  '10. Retrieve crew using LifeSling, ladder, swim platform, etc.',
                ),
                const Text(
                  '11. Check injuries; administer first aid if needed.',
                ),
                const Text('12. Notify Coast Guard of status.'),
                const SizedBox(height: 16),
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

      bottomNavigationBar: Container(
        color: Colors.orange.shade700,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                logger.i('🆘 Other Emergencies button tapped');
                Navigator.of(context).pop(); // ✅ close MOB modal first

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => MainScaffold(
                            branchIndex: 3,
                            child: ToolItemScreen(
                              toolbag: 'procedures',
                              mobKey: GlobalKey(debugLabel: 'MOBKey'),
                              settingsKey: GlobalKey(debugLabel: 'SettingsKey'),
                              searchKey: GlobalKey(debugLabel: 'SearchKey'),
                              titleKey: GlobalKey(debugLabel: 'TitleKey'),
                              cameFromMob:
                                  true, // 🌟 ADDED — signals ToolItemScreen to return to MOB
                            ),
                          ),
                    ),
                  );
                });
              },

              // context.go(
              //   '/tools/items',
              //   extra: {
              //     'toolbag': 'emergencies',
              //     'renderItems': renderItems,
              //     'mobKey': GlobalKey(debugLabel: 'MOBKey'),
              //     'settingsKey': GlobalKey(debugLabel: 'SettingsKey'),
              //     'searchKey': GlobalKey(debugLabel: 'SearchKey'),
              //     'titleKey': GlobalKey(debugLabel: 'TitleKey'),
              //     'transitionKey':
              //         'emergencies_${DateTime.now().millisecondsSinceEpoch}',
              //     'transitionType': TransitionType.slide,
              //     'slideFrom': SlideDirection.left,
              //   },
              // );
              //   });
              // },
              child: const Text(
                'Other Emergencies',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
