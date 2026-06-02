import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/main.dart';

void main() {
  testWidgets('RPG Market app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RpgMarketApp());

    expect(find.text('Loja de Móveis'), findsOneWidget);
  });
}