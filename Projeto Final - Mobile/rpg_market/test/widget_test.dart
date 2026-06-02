import 'package:flutter_test/flutter_test.dart';
import 'package:loja_online_simples_flutter/main.dart';

void main() {
  testWidgets('RPG Market app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RpgMarketApp());

    expect(find.text('RPG Market'), findsWidgets);
  });
}