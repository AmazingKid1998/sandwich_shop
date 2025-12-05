import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

Sandwich _veggieSixInch() {
  return Sandwich(
    type: SandwichType.veggieDelight,
    isFootlong: false,
    breadType: BreadType.white,
  );
}

Sandwich _veggieFootlong() {
  return Sandwich(
    type: SandwichType.veggieDelight,
    isFootlong: true,
    breadType: BreadType.white,
  );
}

void main() {
  group('Cart model - Worksheet 6', () {
    test('Starts empty', () {
      final cart = Cart();

      expect(cart.items.isEmpty, true);
      expect(cart.countOfItems, 0);
      expect(cart.totalPrice, 0.0);
    });

    test('items is read-only (unmodifiable view)', () {
      final cart = Cart();
      final sandwich = _veggieSixInch();

      cart.add(sandwich);

      expect(() {
        cart.items[sandwich] = 99; // should throw
      }, throwsUnsupportedError);

      expect(() {
        cart.items.remove(sandwich); // should throw
      }, throwsUnsupportedError);
    });

    test('add increases quantity for same Sandwich instance', () {
      final cart = Cart();
      final sandwich = _veggieSixInch();

      cart.add(sandwich);
      cart.add(sandwich);

      expect(cart.items.length, 1);
      expect(cart.items[sandwich], 2);
      expect(cart.countOfItems, 2);
    });

    test('add treats different instances as different keys (identity-based)',
        () {
      final cart = Cart();

      final s1 = _veggieSixInch();
      final s2 = _veggieSixInch(); // same fields, different instance

      cart.add(s1);
      cart.add(s2);

      // Because Sandwich does not override ==/hashCode,
      // these are different keys.
      expect(cart.items.length, 2);
      expect(cart.countOfItems, 2);
    });

    test('remove decreases quantity and removes at 0', () {
      final cart = Cart();
      final sandwich = _veggieSixInch();

      cart.add(sandwich);
      cart.add(sandwich); // qty 2

      cart.remove(sandwich); // qty 1
      expect(cart.items[sandwich], 1);
      expect(cart.countOfItems, 1);

      cart.remove(sandwich); // should remove key
      expect(cart.items.containsKey(sandwich), false);
      expect(cart.countOfItems, 0);
    });

    test('remove on missing item does nothing safely', () {
      final cart = Cart();
      final sandwich = _veggieSixInch();

      cart.remove(sandwich); // no crash
      expect(cart.countOfItems, 0);
      expect(cart.items.isEmpty, true);
    });

    test('increase is equivalent to add', () {
      final cart = Cart();
      final sandwich = _veggieSixInch();

      cart.increase(sandwich);
      cart.increase(sandwich);

      expect(cart.items[sandwich], 2);
      expect(cart.countOfItems, 2);
    });

    test('decrease is equivalent to remove', () {
      final cart = Cart();
      final sandwich = _veggieSixInch();

      cart.add(sandwich);
      cart.add(sandwich); // qty 2

      cart.decrease(sandwich); // qty 1
      expect(cart.items[sandwich], 1);

      cart.decrease(sandwich); // remove
      expect(cart.items.containsKey(sandwich), false);
    });

    test('clear removes all items', () {
      final cart = Cart();
      final s1 = _veggieSixInch();
      final s2 = _veggieFootlong();

      cart.add(s1);
      cart.add(s1);
      cart.add(s2);

      expect(cart.countOfItems, 3);

      cart.clear();

      expect(cart.items.isEmpty, true);
      expect(cart.countOfItems, 0);
      expect(cart.totalPrice, 0.0);
    });

    test('totalPrice matches PricingRepository calculation', () {
      final cart = Cart();
      final repo = PricingRepository();

      final six = _veggieSixInch();
      final foot = _veggieFootlong();

      // Important: use SAME instance repeatedly to accumulate quantity
      cart.add(six);
      cart.add(six); // qty 2 of six-inch
      cart.add(foot); // qty 1 footlong

      final expectedSix =
          repo.calculatePrice(quantity: 2, isFootlong: false);
      final expectedFoot =
          repo.calculatePrice(quantity: 1, isFootlong: true);

      final expectedTotal = expectedSix + expectedFoot;

      expect(cart.totalPrice, closeTo(expectedTotal, 0.0001));
    });

    test('countOfItems sums quantities across keys', () {
      final cart = Cart();

      final s1 = _veggieSixInch();
      final s2 = _veggieFootlong();

      cart.add(s1);
      cart.add(s1); // 2
      cart.add(s2); // 1

      expect(cart.countOfItems, 3);
    });
  });
}
