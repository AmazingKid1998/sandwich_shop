import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

Sandwich _testSandwich({bool isFootlong = false}) {
  return Sandwich(
    type: SandwichType.veggieDelight,
    isFootlong: isFootlong,
    breadType: BreadType.white,
  );
}

/// Simple host to verify Checkout returns data via Navigator.pop
class _CheckoutHost extends StatefulWidget {
  final Cart cart;

  const _CheckoutHost({required this.cart});

  @override
  State<_CheckoutHost> createState() => _CheckoutHostState();
}

class _CheckoutHostState extends State<_CheckoutHost> {
  bool resultReceived = false;

  Future<void> _openCheckout() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(cart: widget.cart),
      ),
    );

    if (result != null) {
      setState(() => resultReceived = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            key: const ValueKey('open_checkout'),
            onPressed: _openCheckout,
            child: const Text('Open Checkout'),
          ),
          if (resultReceived)
            const Text(
              'RESULT_RECEIVED',
              key: ValueKey('result_received_text'),
            ),
        ],
      ),
    );
  }
}

void main() {
  group('CheckoutScreen - Worksheet 6', () {
    testWidgets('Shows order summary and confirm button',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(home: CheckoutScreen(cart: cart)),
      );

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.textContaining(sandwich.name), findsOneWidget);
      expect(find.byKey(const ValueKey('confirm_payment_button')), findsOneWidget);
    });

    testWidgets('Tapping confirm shows processing state (no pending timers)',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(home: CheckoutScreen(cart: cart)),
      );

      await tester.tap(find.byKey(const ValueKey('confirm_payment_button')));
      await tester.pump(); // show loading UI

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing payment...'), findsOneWidget);

      // Advance fake time to complete the 2-second delay
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('Checkout returns a result to previous screen',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = _testSandwich();

      cart.add(sandwich);

      await tester.pumpWidget(
        MaterialApp(home: _CheckoutHost(cart: cart)),
      );

      await tester.tap(find.byKey(const ValueKey('open_checkout')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('confirm_payment_button')));
      await tester.pump(); // loading state

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('result_received_text')), findsOneWidget);
      expect(find.text('RESULT_RECEIVED'), findsOneWidget);
    });
  });
}
