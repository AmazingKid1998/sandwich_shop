import 'package:flutter/material.dart';

import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

/// CartScreen
/// Worksheet 6 mapping:
/// - "Prompt-Driven Development in Practice" outcome:
///   Implement cart modifications (increase/decrease/remove).
/// - "Navigation in Flutter":
///   Uses Navigator.pop to return to Order screen.
/// - "Returning Data from a Screen":
///   Integrates CheckoutScreen and awaits returned order confirmation.
class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// Worksheet 6 mapping:
  /// - Pricing logic lives in PricingRepository.
  /// - Price depends on quantity + size (footlong),
  ///   not type/bread.
  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository repo = PricingRepository();
    return repo.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  /// Worksheet 6 mapping:
  /// - Cart modification: "Increase Quantity"
  /// IMPORTANT:
  /// - Do NOT mutate widget.cart.items directly.
  /// - items is read-only by design.
  void _increase(Sandwich sandwich) {
    setState(() {
      widget.cart.increase(sandwich);
    });
  }

  /// Worksheet 6 mapping:
  /// - Cart modification: "Decrease Quantity"
  /// - Edge case:
  ///   If quantity would drop below 1, remove item.
  /// IMPORTANT:
  /// - Do NOT mutate widget.cart.items directly.
  void _decrease(Sandwich sandwich) {
    setState(() {
      widget.cart.decrease(sandwich);
    });
  }

  /// Worksheet 6 mapping:
  /// - "Returning Data from a Screen"
  /// - Demonstrates awaiting Navigator.push(...) and receiving data.
  /// - Matches worksheet logic:
  ///   empty cart -> SnackBar
  ///   success -> clear + SnackBar + pop to Order
  Future<void> _navigateToCheckout() async {
    if (widget.cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cart: widget.cart),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        widget.cart.clear();
      });

      final String orderId = result['orderId'] as String;
      final String estimatedTime = result['estimatedTime'] as String;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Order $orderId confirmed! Estimated time: $estimatedTime'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );

      // Return to Order screen after successful checkout
      Navigator.pop(context);
    }
  }

  /// Helper button to avoid depending on StyledButton.
  /// Adds stable keys for widget tests.
  Widget _primaryButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    Color? backgroundColor,
    Key? key,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        key: key,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: normalText),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
      ),
    );
  }

  /// Builds one cart item row with:
  /// - name
  /// - calculated per-item price
  /// - quantity controls with test keys
  ///
  /// Worksheet 6 mapping:
  /// - Cart modification acceptance criteria:
  ///   Each item shows quantity + "+" and "−".
  Widget _buildCartItemRow(Sandwich sandwich, int quantity) {
    final double itemPrice = _calculateItemPrice(sandwich, quantity);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Name
        Expanded(
          child: Text(
            sandwich.name,
            style: normalText,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),

        // Per-item price based on repo rules
        Text(
          '£${itemPrice.toStringAsFixed(2)}',
          style: normalText,
        ),
        const SizedBox(width: 12),

        // Quantity controls
        Row(
          children: [
            IconButton(
              key: ValueKey('decrease_${sandwich.name}'),
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => _decrease(sandwich),
              tooltip: 'Decrease',
            ),
            Text(
              quantity.toString(),
              key: ValueKey('qty_${sandwich.name}'),
              style: normalText,
            ),
            IconButton(
              key: ValueKey('increase_${sandwich.name}'),
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _increase(sandwich),
              tooltip: 'Increase',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnChildren = [];

    columnChildren.add(const Text('Your Cart', style: heading1));
    columnChildren.add(const SizedBox(height: 16));

    /// Worksheet 6 mapping:
    /// - Edge cases / empty state
    if (widget.cart.items.isEmpty) {
      columnChildren.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text('Your cart is empty', style: normalText),
        ),
      );
    } else {
      /// Worksheet 6 mapping:
      /// - Cart modifications UI over existing CartScreen
      for (final entry in widget.cart.items.entries) {
        final Sandwich sandwich = entry.key;
        final int quantity = entry.value;

        columnChildren.add(_buildCartItemRow(sandwich, quantity));
        columnChildren.add(const SizedBox(height: 12));
      }

      columnChildren.add(const Divider());
      columnChildren.add(const SizedBox(height: 8));

      /// Worksheet 6 mapping:
      /// - Acceptance criteria:
      ///   total price updates immediately
      columnChildren.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total', style: heading2),
            Text(
              '£${widget.cart.totalPrice.toStringAsFixed(2)}',
              style: heading2,
            ),
          ],
        ),
      );
    }

    columnChildren.add(const SizedBox(height: 24));

    /// Worksheet 6 mapping:
    /// - Returning data with checkout
    if (widget.cart.items.isNotEmpty) {
      columnChildren.add(
        _primaryButton(
          key: const ValueKey('checkout_button'),
          onPressed: _navigateToCheckout,
          icon: Icons.payment,
          label: 'Checkout',
          backgroundColor: Colors.orange,
        ),
      );
      columnChildren.add(const SizedBox(height: 12));
    }

    /// Worksheet 6 mapping:
    /// - Basic navigation back to order screen
    columnChildren.add(
      _primaryButton(
        key: const ValueKey('back_to_order_button'),
        onPressed: () => Navigator.pop(context),
        icon: Icons.arrow_back,
        label: 'Back to Order',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: columnChildren,
          ),
        ),
      ),
    );
  }
}
