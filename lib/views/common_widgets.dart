import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

/// Standard app bar used across the app.
/// - Shows logo on the left
/// - Shows a title
/// - Shows cart indicator (count of items) on the right
PreferredSizeWidget buildStandardAppBar({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: Image.asset('assets/images/logo.png'),
      ),
    ),
    title: Text(title, style: heading1),
    actions: [
      Consumer<Cart>(
        builder: (context, cart, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_cart),
                const SizedBox(width: 4),
                Text('${cart.countOfItems}'),
              ],
            ),
          );
        },
      ),
    ],
  );
}
