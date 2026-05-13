import 'package:eventosloop/app/loop_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App arranca', (WidgetTester tester) async {
    await tester.pumpWidget(const LoopApp());
    expect(find.text('LOOP'), findsOneWidget);
  });
}
