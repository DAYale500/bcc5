import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/group_button.dart';

class PartZoneScreen extends StatelessWidget {
  const PartZoneScreen({super.key});

  final List<String> zones = const [
    'Deck',
    'Hull',
    'Rigging',
    'Sails',
    'Interior',
  ];

  @override
  Widget build(BuildContext context) {
    logger.i('🟩 Displaying PartZoneScreen');

    return MainScaffold(
      selectedIndex: 2, // ✅ FIXED: correct parameter
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Text(
            'Select a Zone',
            style: AppTheme.headingStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...zones.map(
            (zone) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GroupButton(
                label: zone,
                onTap: () {
                  logger.i('🟦 Tapped zone: $zone');
                  context.push('/parts/items', extra: {'zone': zone});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
