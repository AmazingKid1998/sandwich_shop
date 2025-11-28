import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name returns correct human-readable text for each type', () {
      final veggie = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final chicken = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final tuna = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wholemeal,
      );
      final meatball = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      expect(veggie.name, 'Veggie Delight');
      expect(chicken.name, 'Chicken Teriyaki');
      expect(tuna.name, 'Tuna Melt');
      expect(meatball.name, 'Meatball Marinara');
    });

    test('image returns correct path for footlong sandwiches', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      expect(
        sandwich.image,
        'assets/images/veggieDelight_footlong.png',
      );
    });

    test('image returns correct path for six-inch sandwiches', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );

      expect(
        sandwich.image,
        'assets/images/veggieDelight_six_inch.png',
      );
    });

    test('bread type does not affect image path', () {
      final white = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final wheat = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
      final wholemeal = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      expect(white.image, wheat.image);
      expect(wheat.image, wholemeal.image);
    });
  });
}
