// 📄 lib/widgets/group_picker_dropdown.dart

import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';

class GroupPickerDropdown extends StatelessWidget {
  final String label; // e.g., 'Module' or 'Chapter'
  final String selectedId;
  final List<String> ids;
  final Map<String, String> idToTitle;
  final ValueChanged<String> onChanged;

  const GroupPickerDropdown({
    super.key,
    required this.label,
    required this.selectedId,
    required this.ids,
    required this.idToTitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedId,
        icon: const Icon(Icons.arrow_drop_down),
        borderRadius: BorderRadius.circular(12),
        style: AppTheme.scaledTextTheme.bodyLarge,
        dropdownColor: Colors.white,
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
        items:
            ids.map((id) {
              return DropdownMenuItem<String>(
                value: id,
                child: Text(idToTitle[id] ?? id),
              );
            }).toList(),
      ),
    );
  }
}
