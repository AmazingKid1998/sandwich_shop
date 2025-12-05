import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/views/order_screen.dart';

void main() {
  group('OrderScreen - Worksheet 6 aligned', () {
    testWidgets('Renders main controls and buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(maxQuantity: 5),
        ),
      );

      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Buttons with keys from your updated OrderScreen
      expect(find.byKey(const ValueKey('add_to_cart_button')), findsOneWidget);
      expect(find.byKey(const ValueKey('view_cart_button')), findsOneWidget);

      // Quantity label
      expect(find.textContaining('Quantity:'), findsOneWidget);
    });

    testWidgets('Quantity cannot go below 1',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(maxQuantity: 5),
        ),
      );

      // At start, quantity is 1.
      // The "-" IconButton should be disabled.
      final minusFinder = find.byIcon(Icons.remove);
      expect(minusFinder, findsOneWidget);

      final IconButton minusButton =
          tester.widget<IconButton>(minusFinder);

      expect(minusButton.onPressed, isNull);
    });

    testWidgets('Quantity cannot exceed maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(maxQuantity: 2),
        ),
      );

      final plusFinder = find.byIcon(Icons.add);
      expect(plusFinder, findsOneWidget);

      // Tap "+" twice: should reach 2 and then stop incrementing further
      await tester.tap(plusFinder);
      await tester.pump();

      await tester.tap(plusFinder);
      await tester.pump();

      // Quantity text should include "2"
      expect(find.text('2'), findsWidgets);

      // Now "+" should be disabled
      final IconButton plusButton =
          tester.widget<IconButton>(plusFinder);

      expect(plusButton.onPressed, isNull);
    });

    testWidgets('Add to cart updates cart summary count',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(maxQuantity: 5),
        ),
      );

      // Initial summary should show 0 items
      expect(find.textContaining('Cart: 0 items'), findsOneWidget);

      // Tap add-to-cart
      await tester.tap(find.byKey(const ValueKey('add_to_cart_button')));
      await tester.pump(); // rebuild after setState
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.textContaining('Cart: 1 items'), findsOneWidget);
    });

    testWidgets('View Cart navigates to Cart screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(maxQuantity: 5),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('view_cart_button')));
      await tester.pumpAndSettle();

      // CartScreen app bar title
      expect(find.text('Cart'), findsOneWidget);
    });
  });
}
