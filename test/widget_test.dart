

import 'package:flutter_test/flutter_test.dart';

import 'package:paveproducts/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PaveProductsApp());
    expect(find.text('Products'), findsOneWidget);
  });
}
