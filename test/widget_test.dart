import 'package:flutter_test/flutter_test.dart';

import 'package:bcc5/app.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const Bcc5App());
    expect(find.byType(Bcc5App), findsOneWidget);
  });
}
