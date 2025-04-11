import 'package:bcc5/utils/location_helper.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MOBEmergencyScreen extends StatelessWidget {
  const MOBEmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('🚨 MOB Emergency Screen opened');

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
      body: FutureBuilder(
        future: getCurrentLocation(),
        builder: (context, snapshot) {
          final now = DateTime.now();
          final timestamp = now.toLocal().toString().split('.').first;

          String decimalCoords = 'Unavailable';
          String marineCoords = 'Unavailable';

          if (snapshot.hasData) {
            final lat = snapshot.data!.latitude;
            final lon = snapshot.data!.longitude;

            decimalCoords =
                '${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)}';
            marineCoords =
                '${formatToMarineCoord(lat, isLat: true)}   ${formatToMarineCoord(lon, isLat: false)}';
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const Text(
                  'Timestamp:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SelectableText(timestamp),
                const SizedBox(height: 16),
                const Text(
                  'GPS Coordinates (Marine Format):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SelectableText(marineCoords),
                const SizedBox(height: 12),
                const Text(
                  'GPS Coordinates (Decimal Degrees):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SelectableText(decimalCoords),
                const Text(
                  'Immediate Steps:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('1. Shout "Man Overboard!" loudly and clearly.'),
                    Text('2. Assign a spotter to maintain visual contact.'),
                    Text('3. Throw a flotation device immediately.'),
                    Text('4. Press MOB on GPS/chartplotter if available.'),
                    Text('5. Radio Coast Guard with MAY DAY.'),
                  ],
                ),
                const Text(
                  'Initiate Rescue:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('5. Note wind and current direction.'),
                    Text('6. Maneuver vessel back under control.'),
                    Text('7. Approach from downwind or leeward side.'),
                    Text('8. Retrieve crew using LifeSling or ladder.'),
                    Text('9. Check injuries; administer first aid if needed.'),
                    Text(
                      '10. Notify coast guard or authorities if unresolved.',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: Icon(Icons.warning_amber_rounded, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  label: const Text('Other Emergencies'),
                  onPressed: () {
                    logger.i('🆘 Other Emergencies button tapped');

                    Navigator.of(context).pop(); // Close this screen

                    // Schedule routing after pop completes
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
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
