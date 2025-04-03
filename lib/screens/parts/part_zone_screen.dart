import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/theme/app_theme.dart';

class PartZoneScreen extends StatelessWidget {
  const PartZoneScreen({super.key});

  final List<String> zones = const [
    'Sails',
    'Rigging',
    'Deck',
    'Interior',
    'Hull',
  ];

  final Map<String, Offset> zonePositions = const {
    'Deck': Offset(0.17, 0.57),
    'Hull': Offset(0.39, 0.69),
    'Rigging': Offset(0.6, 0.49),
    'Sails': Offset(0.32, 0.49),
    'Interior': Offset(0.7, 0.63),
  };

  final Map<String, String> zoneDescriptions = const {
    'Sails': 'Sails -- Wind-catching cloth',
    'Rigging': 'Rigging -- Cables & spars for the sails',
    'Deck': 'Deck -- Top surface of the boat',
    'Interior': 'Interior -- Cabin and below-deck area',
    'Hull': 'Hull -- Main body of the boat',
  };

  final double appBarOffset = 80.0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    logger.i('🟩 Displaying PartZoneScreen with layout polish');

    return Stack(
      fit: StackFit.expand,
      children: [
        // ⛵ Background
        Opacity(
          opacity: 0.8,
          child: Image.asset(
            'assets/images/boat_overview_tall.png',
            fit: BoxFit.cover,
          ),
        ),

        // 🔵 AppBar
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

        // 🧭 Screen Instruction: "Choose a Zone" with background box
        Positioned(
          top: appBarOffset + 32,
          left: 32,
          right: 32,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Choose a Zone',
                style: AppTheme.subheadingStyle.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),
        ),

        // 🧾 Zone Legend Box
        Positioned(
          top: appBarOffset + 120, // spacing under title
          left: 32,
          right: 32,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // 👈 changed from start to center
              children:
                  zones.map((zone) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        zoneDescriptions[zone]!,
                        textAlign:
                            TextAlign
                                .center, // 👈 ensures multiline wraps stay centered
                        style: AppTheme.textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),

        // 📍 Positioned Buttons
        ...zones.map((zone) {
          final offset = zonePositions[zone]!;
          final left = offset.dx * screenSize.width;
          final top = offset.dy * screenSize.height + appBarOffset;

          return Positioned(
            left: left,
            top: top,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                backgroundColor: AppTheme.groupButtonUnselected,
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
          );
        }),
      ],
    );
  }
}
