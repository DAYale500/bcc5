import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/group_button.dart';
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

  @override
  Widget build(BuildContext context) {
    logger.i('🟩 Displaying PartZoneScreen');

    return Column(
      children: [
        const CustomAppBarWidget(
          title: 'Parts',
          showBackButton: false,
          showSearchIcon: true,
          showSettingsIcon: true,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children:
                  zones
                      .map(
                        (zone) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: GroupButton(
                            label: zone,
                            onTap: () {
                              logger.i('🟦 Tapped zone: $zone');
                              context.push(
                                '/parts/items',
                                extra: {'zone': zone},
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
