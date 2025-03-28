import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/utils/logger.dart';

class PartItemScreen extends StatelessWidget {
  final int selectedIndex;

  const PartItemScreen({super.key, required this.selectedIndex});

  String _extractZoneFromId(String id) {
    final match = RegExp(r'part_([a-z]+)_').firstMatch(id);
    if (match != null) {
      final zoneKey = match.group(1)!;
      return zoneKey[0].toUpperCase() +
          zoneKey.substring(1); // e.g., 'hull' -> 'Hull'
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final zone = GoRouterState.of(context).extra as Map<String, dynamic>? ?? {};
    final selectedZone = zone['zone'] as String?;

    final List<PartItem> filteredParts =
        selectedZone != null
            ? allParts
                .where((p) => _extractZoneFromId(p.id) == selectedZone)
                .toList()
            : allParts;

    logger.i('🟦 Displaying PartItemScreen (Zone: $selectedZone)');

    return MainScaffold(
      selectedIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
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
                    'backExtra': {'zone': selectedZone},
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
