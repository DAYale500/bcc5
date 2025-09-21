import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/repositories/tools/json_tool_repository.dart';
import 'package:bcc5/widgets/search_modal.dart'; // SearchModal + SearchMemory

class ToolBagScreen extends StatefulWidget {
  const ToolBagScreen({super.key});

  @override
  State<ToolBagScreen> createState() => _ToolBagScreenState();
}

class _ToolBagScreenState extends State<ToolBagScreen> {
  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

  static const double appBarOffset = 80.0;

  bool _handledReopen = false; // 👈 add this

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledReopen) return;

    final state = GoRouterState.of(context);
    final extra = state.extra;
    if (extra is Map && extra['reopenSearch'] == true) {
      _handledReopen = true;
      final q = (extra['query'] as String?) ?? '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SearchMemory.lastQuery = q;
        showDialog(context: context, builder: (_) => const SearchModal());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final toolbags = ToolRepositoryIndex.getToolbagNames();
    logger.i('🟦 Displaying ToolsScreen');

    return Stack(
      fit: StackFit.expand,
      children: [
        // AppBar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBarWidget(
            title: 'Tools',
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
          top: appBarOffset + 26,
          left: 16,
          right: 16,
          child: Text(
            'Tool Bags',
            style: AppTheme.branchBreadcrumbStyle,
            textAlign: TextAlign.left,
          ),
        ),

        // "Choose a Toolbag" title
        Positioned(
          top: appBarOffset + 48,
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
                'Which toolbag do you need?',
                style: AppTheme.subheadingStyle.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),
        ),

        // Button list
        Positioned.fill(
          top: appBarOffset + 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder<List<String>>(
              future: JsonToolRepository.getModuleNames(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final modules = snapshot.data!;
                if (modules.isEmpty) {
                  return const Center(child: Text('No tool modules found.'));
                }
                return ListView.builder(
                  itemCount: modules.length,
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GroupButton(
                        label: module.toTitleCase(),
                        onTap: () {
                          context.push(
                            '/tools/items',
                            extra: {
                              'toolbag': module, // 👈 use 'toolbag'
                              'transitionKey':
                                  'tool_items_${module}_${DateTime.now().millisecondsSinceEpoch}',
                              'slideFrom': SlideDirection.right,
                              'transitionType': TransitionType.slide,
                              'detailRoute': DetailRoute.branch,
                            },
                          );
                        },
                      ),
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
