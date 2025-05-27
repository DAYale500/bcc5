import 'package:flutter/material.dart';

Widget settingTextFieldWithUnitPicker({
  required String label,
  required Future<String> initialValueFuture,
  required List<String> unitOptions,
  required String defaultUnit,
  required Future<String> Function() getUnitFuture,
  required void Function(String) setUnit,
  required void Function(String) onChanged,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      final textController = TextEditingController();

      return FutureBuilder<String>(
        future: Future.wait([
          initialValueFuture,
          getUnitFuture(),
        ]).then((results) => '${results[0]}|${results[1]}'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              !snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final parts = snapshot.data!.split('|');
          final initialValue = parts[0];
          final unit = parts[1];

          textController.text = initialValue;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              Row(
                children: [
                  SizedBox(
                    width: 100, // ✅ Shrunk width
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: onChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: unit,
                    items:
                        unitOptions
                            .map(
                              (u) => DropdownMenuItem(value: u, child: Text(u)),
                            )
                            .toList(),
                    onChanged: (newUnit) {
                      if (newUnit != null) {
                        setState(() {
                          setUnit(newUnit);
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

// import 'package:flutter/material.dart';

// Widget settingTextFieldWithUnitPicker({
//   required String label,
//   required Future<String> initialValueFuture,
//   required List<String> unitOptions,
//   required String defaultUnit,
//   required Future<String> Function() getUnitFuture,
//   required void Function(String) setUnit,
//   required void Function(String) onChanged,
// }) {
//   return StatefulBuilder(
//     builder: (context, setState) {
//       final textController = TextEditingController();

//       return FutureBuilder<String>(
//         future: Future.wait([
//           initialValueFuture,
//           getUnitFuture(),
//         ]).then((results) => '${results[0]}|${results[1]}'),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState != ConnectionState.done ||
//               !snapshot.hasData) {
//             return const CircularProgressIndicator();
//           }

//           final parts = snapshot.data!.split('|');
//           final initialValue = parts[0];
//           final unit = parts[1];

//           textController.text = initialValue;

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: textController,
//                       keyboardType: TextInputType.numberWithOptions(
//                         decimal: true,
//                       ),
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(), // No suffixText
//                       ),
//                       onChanged: onChanged,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   DropdownButton<String>(
//                     value: unit,
//                     items:
//                         unitOptions
//                             .map(
//                               (u) => DropdownMenuItem(value: u, child: Text(u)),
//                             )
//                             .toList(),
//                     onChanged: (newUnit) {
//                       if (newUnit != null) {
//                         setState(() {
//                           setUnit(newUnit);
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

// // import 'package:flutter/material.dart';

// // Widget settingTextFieldWithUnitPicker({
// //   required String label,
// //   required Future<String> initialValueFuture,
// //   required List<String> unitOptions,
// //   required String defaultUnit,
// //   required Future<String> Function() getUnitFuture,
// //   required void Function(String) setUnit,
// //   required void Function(String) onChanged,
// // }) {
// //   return StatefulBuilder(
// //     builder: (context, setState) {
// //       final textController = TextEditingController();

// //       return FutureBuilder<String>(
// //         future: Future.wait([
// //           initialValueFuture,
// //           getUnitFuture(),
// //         ]).then((results) => '${results[0]}|${results[1]}'),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState != ConnectionState.done ||
// //               !snapshot.hasData) {
// //             return const CircularProgressIndicator();
// //           }

// //           final parts = snapshot.data!.split('|');
// //           final initialValue = parts[0];
// //           final unit = parts[1];

// //           textController.text = initialValue;

// //           return Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(label),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextField(
// //                       controller: textController,
// //                       keyboardType: TextInputType.numberWithOptions(
// //                         decimal: true,
// //                       ),
// //                       decoration: InputDecoration(
// //                         border: const OutlineInputBorder(),
// //                         suffixText: unit,
// //                       ),
// //                       onChanged: onChanged,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   DropdownButton<String>(
// //                     value: unit,
// //                     items:
// //                         unitOptions
// //                             .map(
// //                               (u) => DropdownMenuItem(value: u, child: Text(u)),
// //                             )
// //                             .toList(),
// //                     onChanged: (newUnit) {
// //                       if (newUnit != null) {
// //                         setState(() {
// //                           setUnit(newUnit);
// //                         });
// //                       }
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     },
// //   );
// // }

// // // import 'package:flutter/material.dart';

// // // Widget settingTextFieldWithUnitPicker({
// // //   required String label,
// // //   required Future<String> initialValueFuture,
// // //   required List<String> unitOptions,
// // //   required String defaultUnit,
// // //   required Future<String> Function() getUnitFuture,
// // //   required void Function(String) setUnit,
// // //   required void Function(String) onChanged,
// // // }) {
// // //   final textController = TextEditingController();
// // //   String currentUnit = defaultUnit;

// // //   return FutureBuilder<String>(
// // //     future: Future.wait([
// // //       initialValueFuture,
// // //       getUnitFuture(),
// // //     ]).then((results) => '${results[0]}|${results[1]}'),
// // //     builder: (context, snapshot) {
// // //       if (snapshot.connectionState != ConnectionState.done ||
// // //           !snapshot.hasData) {
// // //         return const CircularProgressIndicator();
// // //       }

// // //       final parts = snapshot.data!.split('|');
// // //       final initialValue = parts[0];
// // //       currentUnit = parts[1];

// // //       textController.text = initialValue;

// // //       return Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(label),
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: TextField(
// // //                   controller: textController,
// // //                   keyboardType: TextInputType.numberWithOptions(decimal: true),
// // //                   decoration: const InputDecoration(
// // //                     border: OutlineInputBorder(),
// // //                   ),
// // //                   onChanged: onChanged,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //               DropdownButton<String>(
// // //                 value: currentUnit,
// // //                 items:
// // //                     unitOptions
// // //                         .map(
// // //                           (unit) =>
// // //                               DropdownMenuItem(value: unit, child: Text(unit)),
// // //                         )
// // //                         .toList(),
// // //                 onChanged: (unit) {
// // //                   if (unit != null) {
// // //                     currentUnit = unit;
// // //                     setUnit(unit);
// // //                   }
// // //                 },
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       );
// // //     },
// // //   );
// // // }
