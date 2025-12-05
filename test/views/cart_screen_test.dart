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

void main() {
  group('CartScreen - Worksheet 6', () {
    testWidgets('Shows empty state when cart is empty',
        (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );

      expect(find.text('Your Cart'), findsOneWidget);
      expect(find.text('Your cart is empty'), findsOneWidget);

      // Checkout button should not appear when empty
      expect(find.byKey(const ValueKey('checkout_button')), findsNothing);
    });

    testWidgets('Increase quantity updates UI',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );

      expect(find.text(sandwich.name), findsOneWidget);

      final incKey = ValueKey('increase_${sandwich.name}');
      final qtyKey = ValueKey('qty_${sandwich.name}');

      // Quantity should start at 1
      expect(find.byKey(qtyKey), findsOneWidget);
      expect(find.text('1'), findsWidgets);

      await tester.tap(find.byKey(incKey));
      await tester.pump();

      // Should show 2
      expect(find.text('2'), findsWidgets);
    });

    testWidgets('Decrease quantity reduces UI count',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);
      cart.add(sandwich); // quantity 2

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );

      final decKey = ValueKey('decrease_${sandwich.name}');
      final qtyKey = ValueKey('qty_${sandwich.name}');

      expect(find.byKey(qtyKey), findsOneWidget);
      expect(find.text('2'), findsWidgets);

      await tester.tap(find.byKey(decKey));
      await tester.pump();

      // Back to 1
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('Decreasing from 1 removes item',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );

      final decKey = ValueKey('decrease_${sandwich.name}');

      await tester.tap(find.byKey(decKey));
      await tester.pump();

      // Item should be gone
      expect(find.text(sandwich.name), findsNothing);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('Checkout button appears only when cart has items',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );

      expect(find.byKey(const ValueKey('checkout_button')), findsOneWidget);
      expect(find.byKey(const ValueKey('back_to_order_button')), findsOneWidget);
    });
  });
}
