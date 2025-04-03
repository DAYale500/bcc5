// import 'package:flutter/material.dart';
// import 'package:bcc5/utils/logger.dart';

// class ContentScreenNavigator extends StatelessWidget {
//   final List<String> sequenceIds;
//   final int startIndex;
//   final int branchIndex;
//   final String backDestination;

//   const ContentScreenNavigator({
//     super.key,
//     required this.sequenceIds,
//     required this.startIndex,
//     required this.branchIndex,
//     required this.backDestination,
//   });

//   @override
//   Widget build(BuildContext context) {
//     logger.w(
//       '⚠️ ContentScreenNavigator is deprecated.\n'
//       '  • sequenceIds: $sequenceIds\n'
//       '  • startIndex: $startIndex\n'
//       '  • branchIndex: $branchIndex\n'
//       '  • backDestination: $backDestination\n'
//       'Please route to the correct detail screen directly.',
//     );

//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.warning_rounded, size: 80, color: Colors.orange),
//               const SizedBox(height: 20),
//               const Text(
//                 'Deprecated Screen',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'ContentScreenNavigator is no longer used.\n\n'
//                 'Please navigate to the proper detail screen for lessons, parts, tools, or flashcards.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Back'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
