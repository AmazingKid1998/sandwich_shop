import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart model', () {
    late Cart cart;
    late PricingRepository pricingRepository;

    setUp(() {
      cart = Cart();
      pricingRepository = PricingRepository();
    });

    test('starts empty', () {
      expect(cart.items, isEmpty);
      expect(cart.totalQuantity, 0);
      expect(cart.totalPrice, 0);
    });

    test('add adds a new sandwich with given quantity', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      cart.add(sandwich, quantity: 2);

      expect(cart.items.length, 1);
      expect(cart.totalQuantity, 2);

      final expectedPrice = pricingRepository.calculatePrice(
        quantity: 2,
        isFootlong: true,
      );
      expect(cart.totalPrice, expectedPrice);
    });

    test('adding the same sandwich increases quantity, not item count', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.add(sandwich, quantity: 1);
      cart.add(sandwich, quantity: 3);

      expect(cart.items.length, 1);
      expect(cart.totalQuantity, 4);

      final expectedPrice = pricingRepository.calculatePrice(
        quantity: 4,
        isFootlong: false,
      );
      expect(cart.totalPrice, expectedPrice);
    });

    test('removeOne decreases quantity and removes item when zero', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      cart.add(sandwich, quantity: 2);
      cart.removeOne(sandwich);

      expect(cart.totalQuantity, 1);
      expect(cart.items.length, 1);

      cart.removeOne(sandwich);

      expect(cart.totalQuantity, 0);
      expect(cart.items.length, 0);
    });

    test('clear removes all items', () {
      final s1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final s2 = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.add(s1, quantity: 1);
      cart.add(s2, quantity: 2);

      cart.clear();

      expect(cart.items, isEmpty);
      expect(cart.totalQuantity, 0);
      expect(cart.totalPrice, 0);
    });
  });
}
