import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/cart_screen.dart';

Sandwich _testSandwich({bool isFootlong = false}) {
  return Sandwich(
    type: SandwichType.veggieDelight,
    isFootlong: isFootlong,
    breadType: BreadType.white,
  );
}

String _qtyText(WidgetTester tester, Key key) {
  final textWidget = tester.widget<Text>(find.byKey(key));
  return textWidget.data ?? '';
}

void main() {
  group('CartScreen - Worksheet 6', () {
    testWidgets('Shows empty state when cart is empty',
        (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(home: CartScreen(cart: cart)),
      );

      expect(find.text('Your Cart'), findsOneWidget);
      expect(find.text('Your cart is empty'), findsOneWidget);

      // Checkout button hidden when empty
      expect(find.byKey(const ValueKey('checkout_button')), findsNothing);
    });

    testWidgets('Increase quantity updates UI',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(home: CartScreen(cart: cart)),
      );

      final incKey = ValueKey('increase_${sandwich.name}');
      final qtyKey = ValueKey('qty_${sandwich.name}');

      expect(_qtyText(tester, qtyKey), '1');

      await tester.tap(find.byKey(incKey));
      await tester.pump();

      expect(_qtyText(tester, qtyKey), '2');
    });

    testWidgets('Decrease quantity reduces UI count',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);
      cart.add(sandwich); // qty 2

      await tester.pumpWidget(
        MaterialApp(home: CartScreen(cart: cart)),
      );

      final decKey = ValueKey('decrease_${sandwich.name}');
      final qtyKey = ValueKey('qty_${sandwich.name}');

      expect(_qtyText(tester, qtyKey), '2');

      await tester.tap(find.byKey(decKey));
      await tester.pump();

      expect(_qtyText(tester, qtyKey), '1');
    });

    testWidgets('Decreasing from 1 removes item',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(home: CartScreen(cart: cart)),
      );

      final decKey = ValueKey('decrease_${sandwich.name}');

      await tester.tap(find.byKey(decKey));
      await tester.pump();

      expect(find.text(sandwich.name), findsNothing);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('Checkout button appears only when cart has items',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(home: CartScreen(cart: cart)),
      );

      expect(find.byKey(const ValueKey('checkout_button')), findsOneWidget);
      expect(find.byKey(const ValueKey('back_to_order_button')), findsOneWidget);
    });
  });
}
