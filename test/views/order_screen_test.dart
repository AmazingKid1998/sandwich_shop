import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/views/order_screen.dart';

class _DummyProfile extends StatelessWidget {
  const _DummyProfile();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('PROFILE_SCREEN')),
    );
  }
}

class _DummyAbout extends StatelessWidget {
  const _DummyAbout();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('ABOUT_SCREEN')),
    );
  }
}

void main() {
  group('OrderScreen - Worksheet 6 aligned', () {
    Finder minusBtn() => find.widgetWithIcon(IconButton, Icons.remove);
    Finder plusBtn() => find.widgetWithIcon(IconButton, Icons.add);

    Widget _app() {
      return MaterialApp(
        home: const OrderScreen(maxQuantity: 5),
        routes: {
          '/profile': (_) => const _DummyProfile(),
          '/about': (_) => const _DummyAbout(),
        },
      );
    }

    testWidgets('Renders main controls and buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(_app());

      expect(find.text('Sandwich Counter'), findsOneWidget);

      expect(find.byKey(const ValueKey('add_to_cart_button')), findsOneWidget);
      expect(find.byKey(const ValueKey('view_cart_button')), findsOneWidget);

      expect(find.byKey(const ValueKey('open_profile_link')), findsOneWidget);
      expect(find.byKey(const ValueKey('open_about_link')), findsOneWidget);

      expect(find.textContaining('Quantity:'), findsOneWidget);
    });

    testWidgets('Quantity cannot go below 1',
        (WidgetTester tester) async {
      await tester.pumpWidget(_app());

      await tester.ensureVisible(minusBtn());
      await tester.pump();

      final IconButton minus =
          tester.widget<IconButton>(minusBtn());

      expect(minus.onPressed, isNull);
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('Quantity cannot exceed maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const OrderScreen(maxQuantity: 2),
          routes: {
            '/profile': (_) => const _DummyProfile(),
            '/about': (_) => const _DummyAbout(),
          },
        ),
      );

      await tester.ensureVisible(plusBtn());
      await tester.pump();

      // Start at 1 -> tap + once -> 2
      await tester.tap(plusBtn());
      await tester.pump();

      // At max (2), + should be disabled
      final IconButton plus =
          tester.widget<IconButton>(plusBtn());
      expect(plus.onPressed, isNull);

      expect(find.text('2'), findsWidgets);
    });

    testWidgets('Add to cart updates cart summary count',
        (WidgetTester tester) async {
      await tester.pumpWidget(_app());

      expect(find.textContaining('Cart: 0 items'), findsOneWidget);

      final addBtn = find.byKey(const ValueKey('add_to_cart_button'));
      await tester.ensureVisible(addBtn);
      await tester.pump();

      await tester.tap(addBtn);
      await tester.pump();

      expect(find.textContaining('Cart: 1 items'), findsOneWidget);
    });

    testWidgets('View Profile link navigates to Profile screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(_app());

      final profileLink = find.byKey(const ValueKey('open_profile_link'));
      await tester.ensureVisible(profileLink);
      await tester.pump();

      await tester.tap(profileLink);
      await tester.pumpAndSettle();

      expect(find.text('PROFILE_SCREEN'), findsOneWidget);
    });

    testWidgets('About link navigates to About screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(_app());

      final aboutLink = find.byKey(const ValueKey('open_about_link'));
      await tester.ensureVisible(aboutLink);
      await tester.pump();

      await tester.tap(aboutLink);
      await tester.pumpAndSettle();

      expect(find.text('ABOUT_SCREEN'), findsOneWidget);
    });
  });
}
