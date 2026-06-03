import 'package:flutter_test/flutter_test.dart';
import 'package:vivalar_store/main.dart';

void main() {
  testWidgets('VivaLar app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VivaLarApp());

    expect(find.text('Viva'), findsOneWidget);
  });
}