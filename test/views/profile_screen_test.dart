import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

Future<void> pumpProfileScreen(
  WidgetTester tester, {
  Cart? cart,
  Widget? home,
}) async {
  final Cart providedCart = cart ?? Cart();

  await tester.pumpWidget(
    ChangeNotifierProvider<Cart>.value(
      value: providedCart,
      child: MaterialApp(
        home: home ?? const ProfileScreen(),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  group('ProfileScreen', () {
    testWidgets('displays initial UI elements correctly',
        (WidgetTester tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Enter your details:'), findsOneWidget);
      expect(find.text('Your Name'), findsOneWidget);
      expect(find.text('Preferred Location'), findsOneWidget);
      expect(find.text('Save Profile'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Cart indicator (initially 0)
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      await pumpProfileScreen(tester);

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('text fields accept input correctly',
        (WidgetTester tester) async {
      await pumpProfileScreen(tester);

      final Finder nameFieldFinder =
          find.widgetWithText(TextField, 'Your Name');
      final Finder locationFieldFinder =
          find.widgetWithText(TextField, 'Preferred Location');

      await tester.enterText(nameFieldFinder, 'John Doe');
      await tester.enterText(locationFieldFinder, 'London');
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('London'), findsOneWidget);
    });

    testWidgets('shows validation error when required fields are missing',
        (WidgetTester tester) async {
      await pumpProfileScreen(tester);

      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('returns profile data when both fields are filled',
        (WidgetTester tester) async {
      Map<String, String>? result;

      await pumpProfileScreen(
        tester,
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute<Map<String, String>>(
                      builder: (BuildContext context) => const ProfileScreen(),
                    ),
                  );
                },
                child: const Text('Go to Profile'),
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();

      final Finder nameFieldFinder =
          find.widgetWithText(TextField, 'Your Name');
      final Finder locationFieldFinder =
          find.widgetWithText(TextField, 'Preferred Location');

      await tester.enterText(nameFieldFinder, 'Jane Smith');
      await tester.enterText(locationFieldFinder, 'Manchester');

      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!['name'], equals('Jane Smith'));
      expect(result!['location'], equals('Manchester'));
    });

    testWidgets('trims whitespace from input fields',
        (WidgetTester tester) async {
      Map<String, String>? result;

      await pumpProfileScreen(
        tester,
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute<Map<String, String>>(
                      builder: (BuildContext context) => const ProfileScreen(),
                    ),
                  );
                },
                child: const Text('Go to Profile'),
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextField, 'Your Name'), '  John Doe  ');
      await tester.enterText(
          find.widgetWithText(TextField, 'Preferred Location'), '  London  ');

      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!['name'], equals('John Doe'));
      expect(result!['location'], equals('London'));
    });

    testWidgets('snackbar has correct duration', (WidgetTester tester) async {
      await pumpProfileScreen(tester);

      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      final Finder snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);

      final SnackBar snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.duration, equals(const Duration(seconds: 2)));
    });
  });
}
