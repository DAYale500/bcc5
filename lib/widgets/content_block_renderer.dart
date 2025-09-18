// lib/widgets/content_block_renderer.dart
import 'package:flutter/material.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/theme/app_theme.dart';

// ⬇️ new: renders the interactive GPS converter block
import 'package:bcc5/widgets/gps_converter.dart';

class ContentBlockRenderer extends StatelessWidget {
  final List<ContentBlock> blocks;
  const ContentBlockRenderer({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: blocks.map((b) => _renderBlock(context, b)).toList(),
      ),
    );
  }

  Widget _renderBlock(BuildContext context, ContentBlock block) {
    switch (block.type) {
      case ContentBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Text(block.text ?? '', style: AppTheme.detailTitleStyle),
        );

      case ContentBlockType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            block.text ?? '',
            style: AppTheme.scaledTextTheme.bodyLarge,
          ),
        );

      case ContentBlockType.code:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(8),
          color: Colors.grey.shade200,
          child: Text(
            block.text ?? '',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        );

      case ContentBlockType.bulletList:
        final bullets = block.bullets ?? const <String>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              bullets.map((line) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(child: Text(line)),
                    ],
                  ),
                );
              }).toList(),
        );

      case ContentBlockType.image:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Image.asset(
            block.imagePath ?? 'assets/images/fallback_image.jpeg',
            fit: BoxFit.cover,
          ),
        );

      case ContentBlockType.divider:
        return const Divider(thickness: 2);

      case ContentBlockType.gpsConverter:
        // ⬇️ this renders the interactive converter UI
        return const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: GpsConverterBlock(),
        );
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:bcc5/data/models/content_block.dart';
// import 'package:bcc5/theme/app_theme.dart';
// import 'package:bcc5/utils/gps_formats.dart';
// import 'package:flutter/services.dart';
// import 'package:bcc5/widgets/gps_keypad.dart';
// import 'package:geolocator/geolocator.dart';

// class ContentBlockRenderer extends StatelessWidget {
//   final List<ContentBlock> blocks;
//   const ContentBlockRenderer({super.key, required this.blocks});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: blocks.map((b) => _renderBlock(context, b)).toList(),
//       ),
//     );
//   }

//   Widget _renderBlock(BuildContext context, ContentBlock block) {
//     switch (block.type) {
//       case ContentBlockType.heading:
//         return Padding(
//           padding: const EdgeInsets.only(top: 12, bottom: 4),
//           child: Text(block.text ?? '', style: AppTheme.detailTitleStyle),
//         );
//       case ContentBlockType.text:
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4),
//           child: Text(
//             block.text ?? '',
//             style: AppTheme.scaledTextTheme.bodyLarge,
//           ),
//         );
//       case ContentBlockType.code:
//         return Container(
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           padding: const EdgeInsets.all(8),
//           color: Colors.grey.shade200,
//           child: Text(
//             block.text ?? '',
//             style: const TextStyle(fontFamily: 'monospace'),
//           ),
//         );
//       case ContentBlockType.bulletList:
//         final bullets = block.bullets ?? [];
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children:
//               bullets.map((b) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 2),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('• ', style: TextStyle(fontSize: 16)),
//                       Expanded(child: Text(b)),
//                     ],
//                   ),
//                 );
//               }).toList(),
//         );
//       case ContentBlockType.image:
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: Image.asset(
//             block.imagePath ?? 'assets/images/fallback_image.jpeg',
//             fit: BoxFit.cover,
//           ),
//         );
//       case ContentBlockType.divider:
//         return const Divider(thickness: 2);
//       case ContentBlockType.gpsConverter:
//         return const Padding(
//           padding: EdgeInsets.only(top: 8.0, bottom: 12.0),
//           child: GpsConverterBlock(),
//         );
//     }
//   }
// }

// // ────────────────────────────────────────────────────────────
// // GPS Converter (prefills with current location in DMM)
// // ────────────────────────────────────────────────────────────
// class GpsConverterBlock extends StatefulWidget {
//   const GpsConverterBlock({super.key});

//   @override
//   State<GpsConverterBlock> createState() => _GpsConverterBlockState();
// }

// class _GpsConverterBlockState extends State<GpsConverterBlock> {
//   final TextEditingController _controller = TextEditingController();
//   final FocusNode _focusNode = FocusNode();

//   // UI options
//   static const bool _useInlineQuickKeys = false;
//   bool _useCustomKeyboard = true;

//   Widget _emptyContextMenu(BuildContext _, EditableTextState _) =>
//       const SizedBox.shrink();
//   // location state (these belong on the State, not the Widget)
//   bool _locLoading = false;
//   String? _locError;

//   // last successful parse
//   ParseResult? _result;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() => setState(() {}));
//     _prefillWithCurrentLocation(); // one-shot prefill
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   // ───────────────── location prefill ─────────────────
//   Future<void> _prefillWithCurrentLocation() async {
//     setState(() {
//       _locLoading = true;
//       _locError = null;
//     });

//     try {
//       // Services enabled?
//       final enabled = await Geolocator.isLocationServiceEnabled();
//       if (!enabled) {
//         setState(() {
//           _locError = 'Location services are disabled';
//           _locLoading = false;
//         });
//         return;
//       }

//       // Permissions
//       var perm = await Geolocator.checkPermission();
//       if (perm == LocationPermission.denied) {
//         perm = await Geolocator.requestPermission();
//       }
//       if (perm == LocationPermission.denied) {
//         setState(() {
//           _locError = 'Location permission denied';
//           _locLoading = false;
//         });
//         return;
//       }
//       if (perm == LocationPermission.deniedForever) {
//         setState(() {
//           _locError = 'Location permission permanently denied';
//           _locLoading = false;
//         });
//         return;
//       }

//       // Position (Geolocator 14: use locationSettings)
//       final pos = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.best,
//         ),
//       );

//       // Prefill as DMM (Marine)
//       final dmm = GpsFormats.toDMM(GpsCoord(pos.latitude, pos.longitude));

//       _controller.text = dmm;
//       _controller.selection = TextSelection.collapsed(
//         offset: _controller.text.length,
//       );
//       setState(() {
//         _result = GpsFormats.tryParse(dmm);
//       });
//     } catch (e) {
//       setState(() => _locError = 'Location error: $e');
//     } finally {
//       setState(() => _locLoading = false);
//     }
//   }

//   // ───────────────── text helpers ─────────────────
//   void _insertText(String text) {
//     final v = _controller.value;
//     final sel = v.selection;
//     final start = sel.start < 0 ? v.text.length : sel.start;
//     final end = sel.end < 0 ? start : sel.end;
//     final newText = v.text.replaceRange(start, end, text);
//     _controller.value = v.copyWith(
//       text: newText,
//       selection: TextSelection.collapsed(offset: start + text.length),
//       composing: TextRange.empty,
//     );
//     setState(() => _result = GpsFormats.tryParse(newText));
//     if (!_focusNode.hasFocus) _focusNode.requestFocus();
//   }

//   void _backspace() {
//     final v = _controller.value;
//     final s = v.selection;

//     if (s.isValid && s.start != s.end) {
//       final newText = v.text.replaceRange(s.start, s.end, '');
//       _controller.value = v.copyWith(
//         text: newText,
//         selection: TextSelection.collapsed(offset: s.start),
//         composing: TextRange.empty,
//       );
//     } else {
//       final caret = s.start < 0 ? v.text.length : s.start;
//       if (caret > 0) {
//         final newText = v.text.replaceRange(caret - 1, caret, '');
//         _controller.value = v.copyWith(
//           text: newText,
//           selection: TextSelection.collapsed(offset: caret - 1),
//           composing: TextRange.empty,
//         );
//       }
//     }
//     setState(() => _result = GpsFormats.tryParse(_controller.text));
//     if (!_focusNode.hasFocus) _focusNode.requestFocus();
//   }

//   Widget _buildInlineQuickKeys() {
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: [
//         for (final t in const ['N', 'S', 'E', 'W'])
//           _QuickKey(label: t, onTap: () => _insertText('$t ')),
//         _QuickKey(label: '°', onTap: () => _insertText('°')),
//         _QuickKey(label: "'", onTap: () => _insertText("'")),
//         _QuickKey(label: '"', onTap: () => _insertText('"')),
//         _QuickKey(label: ',', onTap: () => _insertText(', ')),
//         _QuickKey(label: '−', onTap: () => _insertText('-')),
//       ],
//     );
//   }

//   Widget _formatTile(String label, String value, {bool isPlaceholder = false}) {
//     final theme = AppTheme.scaledTextTheme;
//     final labelStyle = (theme.bodySmall ?? const TextStyle(fontSize: 10))
//         .copyWith(
//           fontWeight: FontWeight.w600,
//           fontSize: ((theme.bodySmall?.fontSize ?? 12) * 0.75),
//           color: Colors.grey[700],
//         );
//     final baseCoordSize = theme.bodyMedium?.fontSize ?? 15;
//     final valueStyle = (theme.bodyMedium ?? const TextStyle(fontSize: 15))
//         .copyWith(
//           fontSize: baseCoordSize * 1.12,
//           color: isPlaceholder ? Colors.grey[600] : Colors.black87,
//           fontStyle: isPlaceholder ? FontStyle.italic : FontStyle.normal,
//         );

//     return Container(
//       margin: const EdgeInsets.only(bottom: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Row(
//         children: [
//           ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 108),
//             child: Text(
//               label,
//               style: labelStyle,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           const VerticalDivider(width: 12, thickness: 1),
//           Expanded(
//             child: Text(
//               value,
//               style: valueStyle,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               softWrap: false,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.copy, size: 16),
//             onPressed: () => Clipboard.setData(ClipboardData(text: value)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fallback = GpsCoord(0, 0);
//     final dd = GpsFormats.toDD(_result?.coord ?? fallback);
//     final dmm = GpsFormats.toDMM(_result?.coord ?? fallback);
//     final dms = GpsFormats.toDMS(_result?.coord ?? fallback);

//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 8),
//             TextField(
//               controller: _controller,
//               focusNode: _focusNode,

//               // toggle between custom keypad and system keyboard
//               readOnly: _useCustomKeyboard,

//               // 👇 ensures the caret is visible
//               showCursor: true,
//               cursorOpacityAnimates:
//                   true, // 👈 forces blinking even in readOnly
//               // 👇 prevents system menu/selection when using custom keypad
//               enableInteractiveSelection: !_useCustomKeyboard,
//               contextMenuBuilder: _useCustomKeyboard ? _emptyContextMenu : null,

//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//                 signed: true,
//               ),

//               decoration: InputDecoration(
//                 hintText:
//                     "e.g. N 37° 4.560'  W 122° 6.700'  or  37.076, -122.112",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 suffixIcon: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       tooltip: 'Use my location',
//                       onPressed:
//                           _locLoading ? null : _prefillWithCurrentLocation,
//                       icon:
//                           _locLoading
//                               ? const SizedBox(
//                                 width: 18,
//                                 height: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                               : const Icon(Icons.my_location, size: 18),
//                     ),
//                     IconButton(
//                       tooltip:
//                           _useCustomKeyboard
//                               ? 'Use native keyboard'
//                               : 'Use GPS keypad',
//                       icon: Icon(
//                         _useCustomKeyboard
//                             ? Icons.keyboard
//                             : Icons.keyboard_alt,
//                         size: 18,
//                       ),
//                       onPressed:
//                           () => setState(() {
//                             _useCustomKeyboard = !_useCustomKeyboard;
//                           }),
//                     ),
//                     if (_controller.text.isNotEmpty)
//                       IconButton(
//                         tooltip: 'Clear',
//                         icon: const Icon(Icons.clear, size: 18),
//                         onPressed: () {
//                           setState(() {
//                             _controller.clear();
//                             _result = null;
//                           });
//                           _focusNode.requestFocus();
//                         },
//                       ),
//                   ],
//                 ),
//               ),

//               onTap: () {
//                 // keep focus when using custom keypad
//                 if (_useCustomKeyboard && !_focusNode.hasFocus) {
//                   _focusNode.requestFocus();
//                 }
//               },

//               onChanged:
//                   (v) => setState(() {
//                     _result = GpsFormats.tryParse(v);
//                   }),

//               onSubmitted: (_) => FocusScope.of(context).unfocus(), // optional
//             ),

//             if (_locError != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 4),
//                 child: Text(
//                   _locError!,
//                   style: AppTheme.scaledTextTheme.bodySmall?.copyWith(
//                     color: Colors.red[700],
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 8),

//             if (_focusNode.hasFocus && _useCustomKeyboard)
//               (_useInlineQuickKeys
//                   ? _buildInlineQuickKeys()
//                   : GpsKeypad(
//                     onKey: (t) => t == '{BKSP}' ? _backspace() : _insertText(t),
//                   )),

//             const SizedBox(height: 8),
//             _formatTile(
//               'DMM (Marine Style)',
//               dmm,
//               isPlaceholder: _result == null,
//             ),
//             _formatTile('DD (Decimal)', dd, isPlaceholder: _result == null),
//             _formatTile(
//               'DMS (Older Charts)',
//               dms,
//               isPlaceholder: _result == null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Small reusable chip (kept for inline quick keys)
// class _QuickKey extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//   const _QuickKey({required this.label, required this.onTap});
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 32,
//       child: OutlinedButton(
//         style: OutlinedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//           side: BorderSide(color: Colors.grey.shade300),
//         ),
//         onPressed: onTap,
//         child: Text(
//           label,
//           style: AppTheme.scaledTextTheme.bodyMedium?.copyWith(fontSize: 14),
//         ),
//       ),
//     );
//   }
// }
