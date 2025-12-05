import 'dart:collection';

import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// Cart model
/// Worksheet 6 mapping:
/// - Supports cart modification features (increase/decrease/remove).
/// - Exposes a read-only view of items to prevent UI from mutating state directly.
/// - Computes total price using PricingRepository rules:
///   price depends on quantity + size, not type/bread.
class Cart {
  /// Internal mutable storage
  final Map<Sandwich, int> _items = {};

  /// Public read-only view
  Map<Sandwich, int> get items => UnmodifiableMapView(_items);

  /// Adds one unit of a sandwich to the cart.
  void add(Sandwich sandwich) {
    _items.update(sandwich, (value) => value + 1, ifAbsent: () => 1);
  }

  /// Decreases quantity of a sandwich by one.
  /// If quantity becomes 0, removes the sandwich from the cart.
  ///
  /// This function may already exist in your old file.
  /// If so, you can keep the name and logic consistent with tests/usage.
  void remove(Sandwich sandwich) {
    if (!_items.containsKey(sandwich)) return;

    final int current = _items[sandwich] ?? 0;
    if (current <= 1) {
      _items.remove(sandwich);
    } else {
      _items[sandwich] = current - 1;
    }
  }

  /// Clears all items from the cart.
  void clear() {
    _items.clear();
  }

  /// Worksheet 6 convenience method:
  /// - Used by CartScreen "+" button.
  void increase(Sandwich sandwich) {
    add(sandwich);
  }

  /// Worksheet 6 convenience method:
  /// - Used by CartScreen "−" button.
  /// - Matches edge-case requirement:
  ///   if quantity would drop below 1, remove item.
  void decrease(Sandwich sandwich) {
    remove(sandwich);
  }

  /// Total number of items (sum of quantities, not unique sandwich types).
  int get countOfItems {
    int total = 0;
    for (final qty in _items.values) {
      total += qty;
    }
    return total;
  }

  /// Calculates total price of the cart using PricingRepository.
  /// Worksheet rule:
  /// - Price is based on quantity + size (footlong vs six inch),
  ///   not type/bread.
  double get totalPrice {
    double total = 0.0;
    final PricingRepository repo = PricingRepository();

    for (final entry in _items.entries) {
      final Sandwich sandwich = entry.key;
      final int quantity = entry.value;

      total += repo.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }

    return total;
  }
}
