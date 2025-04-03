import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';

class PartZoneScreen extends StatelessWidget {
  const PartZoneScreen({super.key});

  final List<String> zones = const [
    'Deck',
    'Hull',
    'Rigging',
    'Sails',
    'Interior',
  ];

  final Map<String, Offset> zonePositions = const {
    'Deck': Offset(0.21, 0.57), // Center-ish
    'Hull': Offset(0.39, 0.69),
    'Rigging': Offset(0.56, 0.49),
    'Sails': Offset(0.37, 0.42),
    'Interior': Offset(0.7, 0.63),
  };

  final Map<String, String> tooltips = const {
    'Deck': 'Top surface of the boat',
    'Hull': 'The main body of the boat',
    'Rigging': 'Cables and lines supporting the mast',
    'Sails': 'Wind-catching cloth',
    'Interior': 'Cabin and below-deck area',
  };

  final double appBarOffset = 80.0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    logger.i('🟩 Displaying PartZoneScreen with positioned layout');

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        Opacity(
          opacity: 0.8,
          child: Image.asset(
            'assets/images/boat_overview_tall.png',
            fit: BoxFit.cover,
          ),
        ),

        // AppBar
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBarWidget(
            title: 'Parts',
            showBackButton: false,
            showSearchIcon: true,
            showSettingsIcon: true,
          ),
        ),

        // Buttons (positioned using consistent offsets)
        ...zones.map((zone) {
          final offset = zonePositions[zone]!;
          final left = offset.dx * screenSize.width;
          final top = offset.dy * screenSize.height + appBarOffset;

          return Positioned(
            left: left,
            top: top,
            child: Tooltip(
              message: tooltips[zone] ?? '',
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  logger.i('🟦 Tapped zone: $zone');
                  context.push('/parts/items', extra: {'zone': zone});
                },
                child: Text(zone, style: const TextStyle(fontSize: 15)),
              ),
            ),
          );
        }),
      ],
    );
  }
}
