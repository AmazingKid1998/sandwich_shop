import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/views/app_drawer.dart';

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('HOME')),
      drawer: AppDrawer(),
      body: Center(child: Text('HOME_BODY')),
    );
  }
}

class _CartScreenDummy extends StatelessWidget {
  const _CartScreenDummy();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('CART')),
      drawer: AppDrawer(),
      body: Center(child: Text('CART_BODY')),
    );
  }
}

class _ProfileScreenDummy extends StatelessWidget {
  const _ProfileScreenDummy();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('PROFILE')),
      drawer: AppDrawer(),
      body: Center(child: Text('PROFILE_BODY')),
    );
  }
}

class _AboutScreenDummy extends StatelessWidget {
  const _AboutScreenDummy();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('ABOUT')),
      drawer: AppDrawer(),
      body: Center(child: Text('ABOUT_BODY')),
    );
  }
}

void main() {
  group('AppDrawer - Worksheet 6 Exercise 2', () {
    Widget _app() {
      return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (_) => const _HomeScreen(),
          '/cart': (_) => const _CartScreenDummy(),
          '/profile': (_) => const _ProfileScreenDummy(),
          '/about': (_) => const _AboutScreenDummy(),
        },
      );
    }

    Future<void> _openDrawer(WidgetTester tester) async {
      // The default tooltip used by Flutter for opening drawers
      final openMenu = find.byTooltip('Open navigation menu');
      expect(openMenu, findsOneWidget);

      await tester.tap(openMenu);
      await tester.pumpAndSettle();
    }

    testWidgets('Drawer items render', (tester) async {
      await tester.pumpWidget(_app());

      await _openDrawer(tester);

      expect(find.byType(AppDrawer), findsOneWidget);

      expect(find.byKey(const ValueKey('drawer_order')), findsOneWidget);
      expect(find.byKey(const ValueKey('drawer_cart')), findsOneWidget);
      expect(find.byKey(const ValueKey('drawer_profile')), findsOneWidget);
      expect(find.byKey(const ValueKey('drawer_about')), findsOneWidget);
    });

    testWidgets('Tapping Profile navigates to /profile', (tester) async {
      await tester.pumpWidget(_app());

      await _openDrawer(tester);

      await tester.tap(find.byKey(const ValueKey('drawer_profile')));
      await tester.pumpAndSettle();

      expect(find.text('PROFILE'), findsOneWidget);
      expect(find.text('PROFILE_BODY'), findsOneWidget);
    });

    testWidgets('Tapping About navigates to /about', (tester) async {
      await tester.pumpWidget(_app());

      await _openDrawer(tester);

      await tester.tap(find.byKey(const ValueKey('drawer_about')));
      await tester.pumpAndSettle();

      expect(find.text('ABOUT'), findsOneWidget);
      expect(find.text('ABOUT_BODY'), findsOneWidget);
    });

    testWidgets('Tapping Cart navigates to /cart', (tester) async {
      await tester.pumpWidget(_app());

      await _openDrawer(tester);

      await tester.tap(find.byKey(const ValueKey('drawer_cart')));
      await tester.pumpAndSettle();

      expect(find.text('CART'), findsOneWidget);
      expect(find.text('CART_BODY'), findsOneWidget);
    });
  });
}
