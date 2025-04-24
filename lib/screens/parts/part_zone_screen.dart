import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/theme/app_theme.dart';

class PartZoneScreen extends StatelessWidget {
  PartZoneScreen({super.key});

  // ✅ Internal GlobalKeys (no longer passed via constructor)
  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

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
    'Sails': 'Sails -- Harness the Wind',
    'Rigging': 'Rigging -- Manage the sails',
    'Deck': 'Deck -- Exterior working surface',
    'Interior': 'Interior -- Below-deck area',
    'Hull': 'Hull -- Body of the boat',
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
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBarWidget(
            title: 'Parts',
            showBackButton: false,
            showSearchIcon: true,
            showSettingsIcon: true,
            mobKey: mobKey,
            settingsKey: settingsKey,
            searchKey: searchKey,
            titleKey: titleKey,
          ),
        ),
        Positioned(
          top: appBarOffset + 32,
          left: 16,
          right: 16,
          child: Text('Parts', style: AppTheme.branchBreadcrumbStyle),
        ),

        // 🧭 Screen Instruction
        Positioned(
          top: appBarOffset + 52,
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
                'Where would you like to explore? Choose a zone that you are interested in to learn more about the parts of a boat.',
                style: AppTheme.subheadingStyle.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),
        ),

        // 🧾 Zone Legend Box
        Positioned(
          top: appBarOffset + 170,
          left: 32,
          right: 32,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  zones.map((zone) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        zoneDescriptions[zone]!,
                        textAlign: TextAlign.center,
                        style: AppTheme.textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),

        // 📍 Positioned Zone Buttons
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
                final timestamp = DateTime.now().millisecondsSinceEpoch;

                context.push(
                  '/parts/items',
                  extra: {
                    'zone': zone,
                    'transitionKey':
                        'part_items_${zone.toLowerCase()}_$timestamp',
                    'slideFrom': SlideDirection.right,
                    'transitionType': TransitionType.slide,
                    'detailRoute': DetailRoute.branch,
                    // 🚫 No GlobalKeys passed anymore
                  },
                );
              },
              child: Text(zone, style: const TextStyle(fontSize: 15)),
            ),
          );
        }),
      ],
    );
  }
}
