import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/id_parser.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';

class PartItemScreen extends StatelessWidget {
  final String zone;

  const PartItemScreen({super.key, required this.zone});

  String _extractZoneFromId(String id) {
    final group = getGroupFromId(id);
    return group[0].toUpperCase() + group.substring(1); // e.g., "hull" → "Hull"
  }

  @override
  Widget build(BuildContext context) {
    final List<PartItem> filteredParts =
        allParts.where((p) => _extractZoneFromId(p.id) == zone).toList();

    logger.i('🟦 Displaying PartItemScreen (Zone: $zone)');

    return Column(
      children: [
        const CustomAppBarWidget(
          title: 'Parts',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
        ),
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
                return ItemButton(
                  label: part.title,
                  onTap: () {
                    logger.i('🟥 Tapped part: ${part.title}');
                    context.push(
                      '/content',
                      extra: {
                        'title': part.title,
                        'content': part.content,
                        'backDestination': '/parts/items',
                        'backExtra': {'zone': zone},
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
