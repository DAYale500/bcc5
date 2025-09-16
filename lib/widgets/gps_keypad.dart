import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';

class GpsKeypad extends StatelessWidget {
  final void Function(String text) onKey;
  const GpsKeypad({super.key, required this.onKey});

  static const Color _deleteGrey = Color(0xFFE6E7EB);

  Widget _key(
    BuildContext context,
    String label, {
    required double keyW,
    required double keyH,
    int span = 1,
    String? insert,
    Color? bg,
    bool outlined = false,
  }) {
    const gap = 8.0;
    const eps = 0.25; // trims fractional spill
    final w = (keyW * span) + gap * (span - 1) - eps;

    return SizedBox(
      width: w,
      height: keyH,
      child: ElevatedButton(
        style: AppTheme.gpsKeyButtonStyle(background: bg, outlined: outlined),
        onPressed: () => onKey(insert ?? label),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // layout constants
    const cols = 6;
    const gap = 8.0;
    const hPadL = 6.0; // ⬅ left Container padding
    const hPadR = 6.0; // ⬅ right Container padding

    return LayoutBuilder(
      builder: (context, c) {
        // 🔧 compute sizes from the *inner* width (after padding)
        final innerWidth = c.maxWidth - hPadL - hPadR;
        final keyW = (innerWidth - gap * (cols - 1)) / cols;
        final keyH = keyW * 0.84;

        Row row(List<Widget> kids) => Row(
          children: [
            for (var i = 0; i < kids.length; i++)
              Padding(
                padding: EdgeInsets.only(right: i == kids.length - 1 ? 0 : gap),
                child: kids[i],
              ),
          ],
        );

        final red = AppTheme.keypadAccentRed;
        final green = AppTheme.keypadAccentGreen;

        return Container(
          padding: const EdgeInsets.fromLTRB(hPadL, 10, hPadR, 10),
          decoration: BoxDecoration(
            color: AppTheme.keypadSurface(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              row([
                _key(context, 'N', keyW: keyW, keyH: keyH, bg: red),
                _key(context, '7', keyW: keyW, keyH: keyH, outlined: true),
                _key(context, '8', keyW: keyW, keyH: keyH, outlined: true),
                _key(context, '9', keyW: keyW, keyH: keyH, outlined: true),
                _key(context, '°', keyW: keyW, keyH: keyH, bg: green),
                _key(
                  context,
                  '−',
                  keyW: keyW,
                  keyH: keyH,
                  bg: green,
                  insert: '-',
                ),
              ]),
              const SizedBox(height: gap),
              row([
                _key(context, 'S', keyW: keyW, keyH: keyH, bg: red),
                _key(context, '4', keyW: keyW, keyH: keyH, outlined: true),
                _key(context, '5', keyW: keyW, keyH: keyH, outlined: true),
                _key(context, '6', keyW: keyW, keyH: keyH, outlined: true),
                _key(context, "'", keyW: keyW, keyH: keyH, bg: green),
                _key(context, '"', keyW: keyW, keyH: keyH, bg: green),
              ]),
              const SizedBox(height: gap),
              row([
                _key(context, 'E', keyW: keyW, keyH: keyH, bg: red),
                _key(context, '1', keyW: keyW, keyH: keyH, outlined: true),
                _key(context, '2', keyW: keyW, keyH: keyH, outlined: true),
                _key(context, '3', keyW: keyW, keyH: keyH, outlined: true),
                _key(
                  context,
                  '.',
                  keyW: keyW,
                  keyH: keyH,
                  bg: green,
                  insert: '.',
                ),
                _key(
                  context,
                  ',',
                  keyW: keyW,
                  keyH: keyH,
                  bg: green,
                  insert: ', ',
                ),
              ]),
              const SizedBox(height: gap),
              row([
                _key(context, 'W', keyW: keyW, keyH: keyH, bg: red),
                _key(
                  context,
                  '␣',
                  keyW: keyW,
                  keyH: keyH,
                  span: 2,
                  insert: ' ',
                ),
                _key(context, '0', keyW: keyW, keyH: keyH, outlined: true),
                _key(
                  context,
                  '⌫',
                  keyW: keyW,
                  keyH: keyH,
                  span: 2,
                  insert: '{BKSP}',
                  bg: _deleteGrey,
                ),
              ]),
            ],
          ),
        );
      },
    );
  }
}
