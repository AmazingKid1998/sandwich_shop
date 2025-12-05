import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget _tile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    Key? key,
  }) {
    return ListTile(
      key: key,
      leading: Icon(icon),
      title: Text(label, style: normalText),
      onTap: () {
        Navigator.pop(context); // close drawer
        // Avoid stacking duplicates of same page
        if (ModalRoute.of(context)?.settings.name != route) {
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

            _tile(
              context: context,
              icon: Icons.home,
              label: 'Order',
              route: '/',
              key: const ValueKey('drawer_order'),
            ),
            _tile(
              context: context,
              icon: Icons.shopping_cart,
              label: 'Cart',
              route: '/cart',
              key: const ValueKey('drawer_cart'),
            ),
            _tile(
              context: context,
              icon: Icons.person,
              label: 'Profile',
              route: '/profile',
              key: const ValueKey('drawer_profile'),
            ),
            _tile(
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
