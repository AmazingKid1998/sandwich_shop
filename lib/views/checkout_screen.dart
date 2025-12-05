import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// CheckoutScreen
/// Worksheet 6 mapping:
/// - "Returning Data from a Screen"
///   This screen demonstrates how a route can return data back to
///   the previous screen using Navigator.pop(context, result).
///
/// - "Passing Data Between Screens"
///   The Cart object is passed forward into this screen via constructor.
///
/// - "Showing Messages Across Navigation"
///   While this screen itself doesn’t show SnackBars, the returned
///   confirmation is used by CartScreen to show a success SnackBar
///   that can persist across navigation changes.
///
/// This is intentionally a simple/fake checkout flow to focus on navigation.
class CheckoutScreen extends StatefulWidget {
  final Cart cart;

  const CheckoutScreen({super.key, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  /// Worksheet 6 mapping:
  /// - Used to show a temporary "processing payment" UI state.
  bool _isProcessing = false;

  /// Worksheet 6 mapping:
  /// - "Returning Data from a Screen"
  ///   This method simulates a payment, then returns an order confirmation
  ///   Map back to the previous screen (CartScreen).
  ///
  /// Flow:
  /// 1) Set _isProcessing to true (UI shows progress)
  /// 2) Wait 2 seconds (fake payment delay)
  /// 3) Build an order confirmation payload
  /// 4) Pop this screen with the payload
  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // A fake delay to simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Create a simple unique order ID using timestamp
    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';

    /// The confirmation payload returned to CartScreen.
    /// Worksheet 6 mapping:
    /// - "Returning Data from a Screen"
    ///   Demonstrates how you can pass structured data backwards.
    final Map orderConfirmation = {
      'orderId': orderId,
      'totalAmount': widget.cart.totalPrice,
      'itemCount': widget.cart.countOfItems,
      'estimatedTime': '15-20 minutes',
    };

    // Check if this State object is still mounted in the widget tree
    if (mounted) {
      // Pop the checkout screen and return to the cart screen
      // with the confirmation data.
      Navigator.pop(context, orderConfirmation);
    }
  }

  /// Worksheet 6 mapping:
  /// - Uses PricingRepository pricing rules:
  ///   price depends on size + quantity, not type/bread.
  ///
  /// This mirrors the approach used in CartScreen.
  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    PricingRepository repo = PricingRepository();
    return repo.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// We build the UI as a list of widgets to keep the layout readable,
    /// matching the simple style shown in the worksheet code.
    List<Widget> columnChildren = [];

    // Title
    columnChildren.add(const Text('Order Summary', style: heading2));
    columnChildren.add(const SizedBox(height: 20));

    /// Worksheet 6 mapping:
    /// - "Passing Data Forwards"
    ///   We read widget.cart.items that was passed in from CartScreen.
    /// - Shows each item with quantity and calculated price.
    for (MapEntry<Sandwich, int> entry in widget.cart.items.entries) {
      final Sandwich sandwich = entry.key;
      final int quantity = entry.value;
      final double itemPrice = _calculateItemPrice(sandwich, quantity);

      final Widget itemRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${quantity}x ${sandwich.name}',
            style: normalText,
          ),
          Text(
            '£${itemPrice.toStringAsFixed(2)}',
            style: normalText,
          ),
        ],
      );

      columnChildren.add(itemRow);
      columnChildren.add(const SizedBox(height: 8));
    }

    // Divider before total
    columnChildren.add(const Divider());
    columnChildren.add(const SizedBox(height: 10));

    /// Worksheet 6 mapping:
    /// - total price pulled from cart model
    final Widget totalRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Total:', style: heading2),
        Text(
          '£${widget.cart.totalPrice.toStringAsFixed(2)}',
          style: heading2,
        ),
      ],
    );
    columnChildren.add(totalRow);
    columnChildren.add(const SizedBox(height: 40));

    // Fake payment method label
    columnChildren.add(
      const Text(
        'Payment Method: Card ending in 1234',
        style: normalText,
        textAlign: TextAlign.center,
      ),
    );
    columnChildren.add(const SizedBox(height: 20));

    /// Worksheet 6 mapping:
    /// - Demonstrates state-driven UI:
    ///   When processing, show a loader and status text.
    ///   Otherwise, show the "Confirm Payment" button.
    if (_isProcessing) {
      columnChildren.add(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      columnChildren.add(const SizedBox(height: 20));
      columnChildren.add(
        const Text(
          'Processing payment...',
          style: normalText,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      columnChildren.add(
        ElevatedButton(
          key: const ValueKey('confirm_payment_button'),
          onPressed: _processPayment,
          child: const Text('Confirm Payment', style: normalText),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        /// Worksheet 6 mapping:
        /// - Basic route with AppBar title
        title: const Text('Checkout', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        /// Keep layout simple to match worksheet style.
        child: Column(
          children: columnChildren,
        ),
      ),
    );
  }
}
