import 'package:flutter/material.dart';

Widget settingDepthPickerField({
  required String label,
  required Future<String> initialValueFuture,
  required Future<String> Function() getUnitFuture,
  required void Function(String) onChanged,
}) {
  return FutureBuilder<List<String>>(
    future: Future.wait([initialValueFuture, getUnitFuture()]),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return const CircularProgressIndicator();

      final saved = snapshot.data![0];
      final unit = snapshot.data![1];
      int feet = 0;
      int inches = 0;
      String meters = '';

      if (unit == 'feet' && saved.contains('ft')) {
        final match = RegExp(r'(\\d+)\\s*ft\\s*(\\d*)').firstMatch(saved);
        feet = int.tryParse(match?.group(1) ?? '') ?? 0;
        inches = int.tryParse(match?.group(2) ?? '') ?? 0;
      } else {
        meters = saved;
      }

      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              const SizedBox(height: 4),
              if (unit == 'feet') ...[
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: feet,
                        items: List.generate(
                          20,
                          (i) =>
                              DropdownMenuItem(value: i, child: Text('$i ft')),
                        ),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => feet = v);
                            onChanged('$feet ft $inches in');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: inches,
                        items: List.generate(
                          12,
                          (i) =>
                              DropdownMenuItem(value: i, child: Text('$i in')),
                        ),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => inches = v);
                            onChanged('$feet ft $inches in');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: int.tryParse(meters.split('.').first) ?? 0,
                        items: List.generate(
                          6,
                          (i) =>
                              DropdownMenuItem(value: i, child: Text('$i m')),
                        ),
                        onChanged: (v) {
                          if (v != null) {
                            final cmVal =
                                int.tryParse(
                                  meters.split('.').last.padRight(2, '0'),
                                ) ??
                                0;
                            final formatted =
                                '${v.toString()}.${(cmVal).toString().padLeft(2, '0')}';
                            setState(() => meters = formatted);
                            onChanged(formatted);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          height:
                              36, // Applies to the DropdownButton button itself
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value:
                                int.tryParse(
                                  meters.split('.').last.padRight(2, '0'),
                                ) ??
                                0,
                            menuMaxHeight:
                                250, // Limit scroll area height (optional)
                            items: List.generate(20, (i) {
                              final cm = i * 5;
                              return DropdownMenuItem(
                                value: cm,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ), // Shrinks spacing
                                  child: Text(
                                    '$cm cm',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            }),
                            onChanged: (v) {
                              if (v != null) {
                                final mVal =
                                    int.tryParse(meters.split('.').first) ?? 0;
                                final formatted =
                                    '${mVal.toString()}.${v.toString().padLeft(2, '0')}';
                                setState(() => meters = formatted);
                                onChanged(formatted);
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    // Expanded(
                    //   child: DropdownButton<int>(
                    //     isExpanded: true,
                    //     value:
                    //         int.tryParse(
                    //           meters.split('.').last.padRight(2, '0'),
                    //         ) ??
                    //         0,
                    //     items: List.generate(20, (i) {
                    //       final cm = i * 5;
                    //       return DropdownMenuItem(
                    //         value: cm,
                    //         child: Text('$cm cm'),
                    //       );
                    //     }),
                    //     onChanged: (v) {
                    //       if (v != null) {
                    //         final mVal =
                    //             int.tryParse(meters.split('.').first) ?? 0;
                    //         final formatted =
                    //             '${mVal.toString()}.${v.toString().padLeft(2, '0')}';
                    //         setState(() => meters = formatted);
                    //         onChanged(formatted);
                    //       }
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                // DropdownButton<String>(
                //   isExpanded: true,
                //   value:
                //       RegExp(r'^\\d+(\\.\\d{1,2})?\$').hasMatch(meters)
                //           ? meters
                //           : '1.00',
                //   items: List.generate(50, (i) {
                //     final value = (0.5 + i * 0.1).toStringAsFixed(2);
                //     return DropdownMenuItem(
                //       value: value,
                //       child: Text('$value m'),
                //     );
                //   }),
                //   onChanged: (value) {
                //     if (value != null) {
                //       setState(() => meters = value);
                //       onChanged(value); // Store just "1.30"
                //     }
                //   },
                // ),

                // TextField(
                //   controller: TextEditingController(text: meters),
                //   keyboardType: const TextInputType.numberWithOptions(
                //     decimal: true,
                //   ),
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     suffixText: 'm',
                //     hintText: 'e.g. 1.20',
                //   ),
                //   onChanged: (value) {
                //     final parsed = double.tryParse(value);
                //     if (parsed != null) {
                //       final formatted = parsed.toStringAsFixed(2);
                //       setState(() => meters = formatted);
                //       onChanged(formatted);
                //     }
                //   },
                // ),
              ],
            ],
          );
        },
      );
    },
  );
}

// import 'package:flutter/material.dart';

// Widget settingDepthPickerField({
//   required String label,
//   required Future<String> initialValueFuture,
//   required Future<String> Function() getUnitFuture,
//   required void Function(String) onChanged,
// }) {
//   return FutureBuilder<List<String>>(
//     future: Future.wait([initialValueFuture, getUnitFuture()]),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) return const CircularProgressIndicator();

//       final saved = snapshot.data![0];
//       final unit = snapshot.data![1];
//       int feet = 0;
//       int inches = 0;
//       String meters = '';

//       if (unit == 'feet' && saved.contains('ft')) {
//         final match = RegExp(r'(\\d+)\\s*ft\\s*(\\d*)').firstMatch(saved);
//         feet = int.tryParse(match?.group(1) ?? '') ?? 0;
//         inches = int.tryParse(match?.group(2) ?? '') ?? 0;
//       } else {
//         meters = saved;
//       }

//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label),
//               const SizedBox(height: 4),
//               if (unit == 'feet')
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButton<int>(
//                         isExpanded: true,
//                         value: feet,
//                         items: List.generate(
//                           20,
//                           (i) =>
//                               DropdownMenuItem(value: i, child: Text('$i ft')),
//                         ),
//                         onChanged: (v) {
//                           if (v != null) {
//                             setState(() => feet = v);
//                             onChanged('$feet ft $inches in');
//                           }
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: DropdownButton<int>(
//                         isExpanded: true,
//                         value: inches,
//                         items: List.generate(
//                           12,
//                           (i) =>
//                               DropdownMenuItem(value: i, child: Text('$i in')),
//                         ),
//                         onChanged: (v) {
//                           if (v != null) {
//                             setState(() => inches = v);
//                             onChanged('$feet ft $inches in');
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 )
//               else
//                 TextField(
//                   controller: TextEditingController(text: meters),
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                   ),
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'e.g. 1.4',
//                   ),
//                   onChanged: (value) {
//                     final parsed = double.tryParse(value);
//                     if (parsed != null) {
//                       final formatted = parsed.toStringAsFixed(
//                         2,
//                       ); // ✅ round to 2 decimal places
//                       onChanged(formatted);
//                     }
//                   },
//                 ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
