// import 'package:bcc5/theme/app_theme.dart';
// import 'package:flutter/material.dart';

// class TourOverlayControls extends StatelessWidget {
//   final VoidCallback onNext;
//   final VoidCallback onEnd;

//   const TourOverlayControls({
//     super.key,
//     required this.onNext,
//     required this.onEnd,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // LEFT: Buttons stacked vertically
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton(
//                 style: AppTheme.tourNextButton,
//                 onPressed: onNext,
//                 child: const Text('Next'),
//               ),
//               ElevatedButton(
//                 style: AppTheme.tourExitButton,
//                 onPressed: onEnd,
//                 child: const Text('Exit'),
//               ),
//             ],
//           ),
//           const SizedBox(width: 12),

//           // RIGHT: Description box
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 'No description provided.',
//                 style: const TextStyle(fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
