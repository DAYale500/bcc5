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
