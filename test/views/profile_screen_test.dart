import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  group('ProfileScreen - Worksheet 6 Exercise 1', () {
    testWidgets('Renders fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ProfileScreen()),
      );

      expect(find.text('Profile'), findsOneWidget);
      expect(find.byKey(const ValueKey('profile_name_field')), findsOneWidget);
      expect(find.byKey(const ValueKey('profile_email_field')), findsOneWidget);
    });

    testWidgets('Shows preview after typing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ProfileScreen()),
      );

      await tester.enterText(
        find.byKey(const ValueKey('profile_name_field')),
        'Jamilus',
      );
      await tester.pump();

      expect(find.text('Preview'), findsOneWidget);
      expect(find.textContaining('Name: Jamilus'), findsOneWidget);
    });
  });
}
