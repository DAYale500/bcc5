import 'package:flutter/material.dart';

Widget settingIntPickerField({
  required String label,
  required int minValue,
  required int maxValue,
  required Future<int> initialValueFuture,
  required void Function(int) onChanged,
}) {
  return FutureBuilder<int>(
    future: initialValueFuture,
    builder: (context, snapshot) {
      int currentValue = snapshot.data ?? minValue;
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              DropdownButton<int>(
                isExpanded: true,
                value: currentValue,
                items: List.generate(
                  maxValue - minValue + 1,
                  (index) => DropdownMenuItem(
                    value: minValue + index,
                    child: Text((minValue + index).toString()),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => currentValue = value);
                    onChanged(value);
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
