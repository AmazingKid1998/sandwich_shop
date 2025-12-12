import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

void main() {
  group('common_widgets.dart - StyledButton', () {
    testWidgets('renders icon and label, enabled when onPressed is not null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledButton(
              onPressed: () {},
              icon: Icons.add_shopping_cart,
              label: 'Test Button',
              backgroundColor: Colors.green,
            ),
          ),
        ),
      );

      expect(find.byType(StyledButton), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final ElevatedButton button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isTrue);
    });

    testWidgets('renders disabled when onPressed is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledButton(
              onPressed: null,
              icon: Icons.add_shopping_cart,
              label: 'Disabled Button',
              backgroundColor: Colors.green,
            ),
          ),
        ),
      );

      expect(find.byType(StyledButton), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Disabled Button'), findsOneWidget);

      final ElevatedButton button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isFalse);
    });
  });

  group('common_widgets.dart - buildStandardAppBar', () {
    testWidgets('renders title, logo and cart indicator',
        (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  appBar: buildStandardAppBar(
                    context: context,
                    title: 'Test Title',
                  ),
                  body: const SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);

      // Logo image is in the AppBar leading
      expect(find.byType(Image), findsOneWidget);

      // Cart icon + count in AppBar
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('0'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('cart indicator updates when cart changes',
        (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  appBar: buildStandardAppBar(
                    context: context,
                    title: 'Cart Title',
                  ),
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        cart.add(
                          Sandwich(
                            type: SandwichType.veggieDelight,
                            isFootlong: true,
                            breadType: BreadType.white,
                          ),
                          quantity: 2,
                        );
                      },
                      child: const Text('Add'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially 0
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('0'),
        ),
        findsOneWidget,
      );

      // Trigger cart update
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Now should show 2
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('2'),
        ),
        findsOneWidget,
      );
    });
  });
}
