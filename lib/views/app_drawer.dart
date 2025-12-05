import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';

/// AppDrawer
/// Worksheet 6 mapping:
/// - Exercise 2: Add a Drawer menu for navigation.
/// - Reduce redundancy by reusing this widget across all screens.
///
/// Notes:
/// - Uses named routes:
///   '/', '/cart', '/profile', '/about'
/// - Your real Cart flow still should be opened from OrderScreen
///   to pass the live Cart instance.
///   This drawer route to '/cart' is mainly for navigation structure/demo/tests.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget _navTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required Key key,
  }) {
    return ListTile(
      key: key,
      leading: Icon(icon),
      title: Text(label, style: normalText),
      onTap: () {
        // Close the drawer first
        Navigator.pop(context);

        final String? current = ModalRoute.of(context)?.settings.name;

        // Avoid pushing the same named route repeatedly
        if (current != route) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Sandwich Shop', style: heading1),
            ),
            const Divider(),

            _navTile(
              context: context,
              icon: Icons.home,
              label: 'Order',
              route: '/',
              key: const ValueKey('drawer_order'),
            ),
            _navTile(
              context: context,
              icon: Icons.shopping_cart,
              label: 'Cart',
              route: '/cart',
              key: const ValueKey('drawer_cart'),
            ),
            _navTile(
              context: context,
              icon: Icons.person,
              label: 'Profile',
              route: '/profile',
              key: const ValueKey('drawer_profile'),
            ),
            _navTile(
              context: context,
              icon: Icons.info,
              label: 'About',
              route: '/about',
              key: const ValueKey('drawer_about'),
            ),
          ],
        ),
      ),
    );
  }
}
