import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/views/order_screen.dart';

void main() {
  group('OrderScreen - Worksheet 6 aligned', () {
    Finder _minusButtonFinder() =>
        find.widgetWithIcon(IconButton, Icons.remove);

    Finder _plusButtonFinder() =>
        find.widgetWithIcon(IconButton, Icons.add);

    testWidgets('Renders main controls and buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(maxQuantity: 5),
        ),
      );

      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Buttons with keys from the updated OrderScreen
      expect(find.byKey(const ValueKey('add_to_cart_button')), findsOneWidget);
      expect(find.byKey(const ValueKey('view_cart_button')), findsOneWidget);

      expect(find.textContaining('Quantity:'), findsOneWidget);
    });

    testWidgets('Quantity cannot go below 1',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(maxQuantity: 5),
        ),
      );

      // Ensure quantity controls are visible
      await tester.ensureVisible(_minusButtonFinder());
      await tester.pump();

      // At quantity 1, "-" should be disabled
      final IconButton minusButton =
          tester.widget<IconButton>(_minusButtonFinder());

      expect(minusButton.onPressed, isNull);

      // Also verify the displayed quantity shows 1 somewhere
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('Quantity cannot exceed maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(maxQuantity: 2),
        ),
      );

      final plusFinder = _plusButtonFinder();
      final minusFinder = _minusButtonFinder();

      await tester.ensureVisible(plusFinder);
      await tester.pump();

      // Start at 1, tap "+" once -> should become 2
      await tester.tap(plusFinder);
      await tester.pump();

      // Verify "-" is now enabled (because qty > 1)
      await tester.ensureVisible(minusFinder);
      await tester.pump();
      expect(
        tester.widget<IconButton>(minusFinder).onPressed,
        isNotNull,
      );

      // Now at max (2), "+" should be disabled
      await tester.ensureVisible(plusFinder);
      await tester.pump();

      final IconButton plusButtonAfter =
          tester.widget<IconButton>(plusFinder);

      expect(plusButtonAfter.onPressed, isNull);

      // Confirm quantity text shows 2
      expect(find.text('2'), findsWidgets);
    });

    testWidgets('Add to cart updates cart summary count',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(maxQuantity: 5),
        ),
      );

      expect(find.textContaining('Cart: 0 items'), findsOneWidget);

      final addBtn = find.byKey(const ValueKey('add_to_cart_button'));

      await tester.ensureVisible(addBtn);
      await tester.pump();

      await tester.tap(addBtn);
      await tester.pump(); // allow setState

      expect(find.textContaining('Cart: 1 items'), findsOneWidget);
    });

    testWidgets('View Cart navigates to Cart screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(maxQuantity: 5),
        ),
      );

      final viewBtn = find.byKey(const ValueKey('view_cart_button'));

      await tester.ensureVisible(viewBtn);
      await tester.pump();

      await tester.tap(viewBtn);
      await tester.pumpAndSettle();

      // Cart screen AppBar title
      expect(find.text('Cart'), findsOneWidget);
    });
  });
}
