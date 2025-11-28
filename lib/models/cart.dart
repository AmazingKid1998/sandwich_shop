import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({
    required this.sandwich,
    this.quantity = 1,
  });
}

class Cart {
  final PricingRepository _pricingRepository = PricingRepository();

  // Keyed by a string built from sandwich properties so same sandwich merges
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => List.unmodifiable(_items.values);

  String _buildKey(Sandwich sandwich) {
    return '${sandwich.type.name}_${sandwich.isFootlong}_${sandwich.breadType.name}';
  }

  void add(Sandwich sandwich, {int quantity = 1}) {
    final key = _buildKey(sandwich);

    if (_items.containsKey(key)) {
      _items[key]!.quantity += quantity;
    } else {
      _items[key] = CartItem(sandwich: sandwich, quantity: quantity);
    }
  }

  void removeOne(Sandwich sandwich) {
    final key = _buildKey(sandwich);
    final item = _items[key];
    if (item == null) return;

    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _items.remove(key);
    }
  }

  void removeItemCompletely(Sandwich sandwich) {
    final key = _buildKey(sandwich);
    _items.remove(key);
  }

  void clear() {
    _items.clear();
  }

  int get totalQuantity {
    return _items.values.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  double get totalPrice {
    double total = 0;
    for (final item in _items.values) {
      total += _pricingRepository.calculatePrice(
        quantity: item.quantity,
        isFootlong: item.sandwich.isFootlong,
      );
    }
    return total;
  }
}
