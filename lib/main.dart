import 'package:flutter/material.dart';

import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: const OrderScreen(maxQuantity: 5),
      routes: {
        '/about': (context) => const AboutScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/cart': (context) => const _CartRouteFallback(),
      },
    );
  }
}

class _CartRouteFallback extends StatelessWidget {
  const _CartRouteFallback();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Please open the cart from the Order screen\n'
            'to use the live cart instance.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
