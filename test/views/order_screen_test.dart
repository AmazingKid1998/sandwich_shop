import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/common_widgets.dart';


void dummyFunction() {}

Finder appBarCartCount(String countText) {
  return find.descendant(
    of: find.byType(AppBar),
    matching: find.text(countText),
  );
}

Finder quantityRow() {
  return find.ancestor(
    of: find.text('Quantity: '),
    matching: find.byType(Row),
  );
}

Finder quantityValueText(String value) {
  return find.descendant(
    of: quantityRow(),
    matching: find.text(value),
  );
}

Finder quantityAddButton() {
  return find.descendant(
    of: quantityRow(),
    matching: find.widgetWithIcon(IconButton, Icons.add),
  );
}

Finder quantityRemoveButton() {
  return find.descendant(
    of: quantityRow(),
    matching: find.widgetWithIcon(IconButton, Icons.remove),
  );
}

Future<void> pumpOrderScreen(
  WidgetTester tester, {
  Cart? cart,
}) async {
  // Make the test surface tall enough so nothing is off-screen.
  await tester.binding.setSurfaceSize(const Size(1000, 1400));
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  final Cart providedCart = cart ?? Cart();

  await tester.pumpWidget(
    ChangeNotifierProvider<Cart>.value(
      value: providedCart,
      child: const MaterialApp(
        home: OrderScreen(),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  group('OrderScreen - Initial State', () {
    testWidgets('displays the initial UI elements correctly',
        (WidgetTester tester) async {
      await pumpOrderScreen(tester);

      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Logo + sandwich image
      expect(find.byType(Image), findsNWidgets(2));

      // Defaults
      expect(find.text('Veggie Delight'), findsWidgets);

      final Switch sizeSwitch = tester.widget<Switch>(find.byType(Switch));
      expect(sizeSwitch.value, isTrue);

      expect(find.text('white'), findsWidgets);

      // Quantity default is 1 (scoped to quantity row)
      expect(quantityValueText('1'), findsOneWidget);

      // Buttons
      expect(find.widgetWithText(StyledButton, 'Add to Cart'), findsOneWidget);
      expect(find.widgetWithText(StyledButton, 'View Cart'), findsOneWidget);

      // AppBar cart indicator starts at 0 (scoped to AppBar)
      expect(appBarCartCount('0'), findsOneWidget);

      // Cart summary
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });
  });

  group('OrderScreen - Cart Summary', () {
    testWidgets('updates cart summary + app bar indicator when items are added',
        (WidgetTester tester) async {
      await pumpOrderScreen(tester);

      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');

      await tester.ensureVisible(addToCartButtonFinder);
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);
      expect(appBarCartCount('1'), findsOneWidget);
    });

    testWidgets('updates cart summary when quantity is increased before adding',
        (WidgetTester tester) async {
      await pumpOrderScreen(tester);

      final Finder addQtyFinder = quantityAddButton();
      await tester.ensureVisible(addQtyFinder);

      // Increase from 1 -> 3
      await tester.tap(addQtyFinder);
      await tester.pumpAndSettle();
      await tester.tap(addQtyFinder);
      await tester.pumpAndSettle();

      expect(quantityValueText('3'), findsOneWidget);

      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');

      await tester.ensureVisible(addToCartButtonFinder);
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
      expect(appBarCartCount('3'), findsOneWidget);
    });

    testWidgets('cart summary accumulates when multiple additions occur',
        (WidgetTester tester) async {
      await pumpOrderScreen(tester);

      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);

      // Add default quantity (1)
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);
      expect(appBarCartCount('1'), findsOneWidget);

      // Increase quantity to 2 and add again -> total items = 3
      final Finder addQtyFinder = quantityAddButton();
      await tester.tap(addQtyFinder);
      await tester.pumpAndSettle();

      expect(quantityValueText('2'), findsOneWidget);

      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
      expect(appBarCartCount('3'), findsOneWidget);
    });
  });

  group('OrderScreen - Interactions', () {
    testWidgets('shows SnackBar confirmation when item is added to cart',
        (WidgetTester tester) async {
      await pumpOrderScreen(tester);

      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);

      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      const String expectedMessage =
          'Added 1 footlong Veggie Delight sandwich(es) on white bread to cart';

      expect(find.text(expectedMessage), findsOneWidget);
    });

    testWidgets('increases quantity when add button is tapped',
        (WidgetTester tester) async {
      await pumpOrderScreen(tester);

      final Finder addQtyFinder = quantityAddButton();
      await tester.ensureVisible(addQtyFinder);

      await tester.tap(addQtyFinder);
      await tester.pumpAndSettle();

      expect(quantityValueText('2'), findsOneWidget);
    });

    testWidgets('decreases quantity when remove button is tapped',
        (WidgetTester tester) async {
      await pumpOrderScreen(tester);

      final Finder addQtyFinder = quantityAddButton();
      final Finder removeQtyFinder = quantityRemoveButton();

      await tester.ensureVisible(addQtyFinder);

      // 1 -> 2
      await tester.tap(addQtyFinder);
      await tester.pumpAndSettle();
      expect(quantityValueText('2'), findsOneWidget);

      // 2 -> 1
      await tester.tap(removeQtyFinder);
      await tester.pumpAndSettle();
      expect(quantityValueText('1'), findsOneWidget);
    });

    testWidgets('quantity does not go below zero and buttons are disabled',
        (WidgetTester tester) async {
      await pumpOrderScreen(tester);

      final Finder removeQtyFinder = quantityRemoveButton();
      await tester.ensureVisible(removeQtyFinder);

      // 1 -> 0
      await tester.tap(removeQtyFinder);
      await tester.pumpAndSettle();

      expect(quantityValueText('0'), findsOneWidget);

      // Remove button should now be disabled
      final IconButton removeButton =
          tester.widget<IconButton>(removeQtyFinder);
      expect(removeButton.onPressed, isNull);

      // Add to Cart button should be disabled
      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');
      final StyledButton addToCartButton =
          tester.widget<StyledButton>(addToCartButtonFinder);
      expect(addToCartButton.onPressed, isNull);
    });

    testWidgets('navigates to cart view when View Cart button is tapped',
        (WidgetTester tester) async {
      await pumpOrderScreen(tester);

      final Finder viewCartButtonFinder =
          find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButtonFinder);

      await tester.tap(viewCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart View'), findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders correctly with icon and label when enabled',
        (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: dummyFunction,
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final ElevatedButton button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isTrue);
    });

    testWidgets('renders correctly and is disabled when onPressed is null',
        (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: null,
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final ElevatedButton button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isFalse);
    });
  });
}
