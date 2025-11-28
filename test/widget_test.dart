import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  testWidgets('shows app bar title', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Sandwich Counter'), findsOneWidget);
  });

  testWidgets('tapping + icon increases quantity', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Initial quantity should be 1
    expect(find.text('1'), findsOneWidget);

    // Find the + icon and make sure it is visible on screen
    final plusFinder = find.byIcon(Icons.add);
    await tester.ensureVisible(plusFinder);

    // Tap the + icon
    await tester.tap(plusFinder);
    await tester.pump();

    // Quantity should now be 2
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('shows SnackBar confirmation when adding to cart',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Make sure quantity is non-zero (default is 1)
    expect(find.text('1'), findsOneWidget);

    // Find the "Add to Cart" button text and ensure it is visible
    final addToCartTextFinder = find.text('Add to Cart');
    await tester.ensureVisible(addToCartTextFinder);

    // Tap the "Add to Cart" button
    await tester.tap(addToCartTextFinder);
    await tester.pump(); // start SnackBar animation
    await tester.pump(const Duration(milliseconds: 500)); // let it appear

    // Look for part of the confirmation message
    expect(
      find.textContaining('Added 1'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Veggie Delight'),
      findsOneWidget,
    );
  });

  testWidgets('Add to Cart becomes disabled when quantity is 0',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Find the - icon and ensure it is visible
    final minusFinder = find.byIcon(Icons.remove);
    await tester.ensureVisible(minusFinder);

    // Decrease quantity to 0
    await tester.tap(minusFinder);
    await tester.pump();

    // Quantity text should show 0
    expect(find.text('0'), findsOneWidget);

    // Get the ElevatedButton that has "Add to Cart" text
    final addToCartButtonFinder =
        find.widgetWithText(ElevatedButton, 'Add to Cart');
    await tester.ensureVisible(addToCartButtonFinder);

    final elevatedButton =
        tester.widget<ElevatedButton>(addToCartButtonFinder);

    // onPressed should be null when disabled
    expect(elevatedButton.onPressed, isNull);
  });

  testWidgets('cart summary updates when item is added',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Initial summary: empty cart
    expect(find.text('Items in cart: 0'), findsOneWidget);
    expect(find.text('Cart total: £0.00'), findsOneWidget);

    // Tap "Add to Cart" (default quantity is 1, footlong Veggie Delight)
    final addToCartTextFinder = find.text('Add to Cart');
    await tester.ensureVisible(addToCartTextFinder);
    await tester.tap(addToCartTextFinder);
    await tester.pump();

    // Compute expected price using the same PricingRepository logic
    final pricingRepository = PricingRepository();
    final expectedPrice = pricingRepository.calculatePrice(
      quantity: 1,
      isFootlong: true,
    );

    // Summary should now show updated values
    expect(find.text('Items in cart: 1'), findsOneWidget);
    expect(
      find.text('Cart total: £${expectedPrice.toStringAsFixed(2)}'),
      findsOneWidget,
    );
  });
}
