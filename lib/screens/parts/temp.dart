import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/navigation/detail_route.dart'; // <-- required for DetailRoute

class PartItemScreen extends StatelessWidget {
  final String zone;

  const PartItemScreen({
    super.key,
    required this.zone,
    required this.mobKey,
    required this.settingsKey,
    required this.searchKey,
    required this.titleKey,
  });

  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;

  @override
  Widget build(BuildContext context) {
    final List<PartItem> filteredParts = PartRepositoryIndex.getPartsForZone(
      zone.toLowerCase(),
    );

    final List<String> sequenceIds = filteredParts.map((p) => p.id).toList();

    logger.i('🟦 Displaying PartItemScreen (Zone: $zone)');

    return Column(
      children: [
        CustomAppBarWidget(
          title: 'Parts',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          mobKey: mobKey,
          settingsKey: settingsKey,
          searchKey: searchKey,
          titleKey: titleKey,
          onBack: () {
            logger.i('🔙 AppBar back from PartItemScreen');
            context.go(
              '/parts',
              extra: {
                'slideFrom': SlideDirection.left,
                'transitionType': TransitionType.slide,
                'detailRoute': DetailRoute.branch,
              },
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          zone.toTitleCase(),
          style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryBlue),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Choose a Part',
          style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryBlue),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: filteredParts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, index) {
                final part = filteredParts[index];
                final timestamp = DateTime.now().millisecondsSinceEpoch;

                return ItemButton(
                  label: part.title,
                  onTap: () {
                    logger.i('🟥 Tapped part: ${part.id}');
                    context.push(
                      '/parts/detail',
                      extra: {
                        'renderItems': buildRenderItems(ids: sequenceIds),
                        'currentIndex': index,
                        'branchIndex': 2,
                        'backDestination': '/parts/items',
                        'backExtra': {
                          'zone': zone,
                          'mobKey': mobKey,
                          'settingsKey': settingsKey,
                          'searchKey': searchKey,
                          'titleKey': titleKey,
                        },
                        'transitionKey': 'part_${part.id}_$timestamp',
                        'detailRoute': DetailRoute.branch,
                        'transitionType': TransitionType.slide,
                        'slideFrom': SlideDirection.right,

                        // ✅ Add missing required keys for PartDetailScreen
                        'mobKey': mobKey,
                        'settingsKey': settingsKey,
                        'searchKey': searchKey,
                        'titleKey': titleKey,
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
