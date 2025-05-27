import 'package:flutter/material.dart';

Widget settingTextField({
  required String label,
  required Future<String> initialValueFuture,
  required void Function(String) onChanged,
}) {
  return FutureBuilder<String>(
    future: initialValueFuture,
    builder: (context, snapshot) {
      final controller = TextEditingController(text: snapshot.data ?? '');
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          onChanged: onChanged,
        ),
      );
    },
  );
}

Widget settingIntField({
  required String label,
  required Future<int> initialValueFuture,
  required void Function(int) onChanged,
}) {
  return FutureBuilder<int>(
    future: initialValueFuture,
    builder: (context, snapshot) {
      final controller = TextEditingController(
        text: (snapshot.data ?? 0).toString(),
      );
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final parsed = int.tryParse(value);
            if (parsed != null) onChanged(parsed);
          },
        ),
      );
    },
  );
}

// Widget settingIntPickerField({
//   required String label,
//   required int minValue,
//   required int maxValue,
//   required Future<int> initialValueFuture,
//   required ValueChanged<int> onChanged,
// }) {
//   return FutureBuilder<int>(
//     future: initialValueFuture,
//     builder: (context, snapshot) {
//       int value = snapshot.data ?? minValue;
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label),
//           DropdownButton<int>(
//             value: value,
//             items: List.generate(
//               maxValue - minValue + 1,
//               (i) => DropdownMenuItem(
//                 value: minValue + i,
//                 child: Text('${minValue + i}'),
//               ),
//             ),
//             onChanged: (newValue) {
//               if (newValue != null) onChanged(newValue);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
