import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canPreview = _name.text.trim().isNotEmpty ||
        _email.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: heading1),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Your Details', style: heading2),
            const SizedBox(height: 16),

            TextField(
              key: const ValueKey('profile_name_field'),
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Full name',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            TextField(
              key: const ValueKey('profile_email_field'),
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // This is just UI feedback (no persistence yet)
            if (canPreview) ...[
              const Divider(),
              const SizedBox(height: 12),
              const Text('Preview', style: heading2),
              const SizedBox(height: 8),
              Text('Name: ${_name.text}', style: normalText),
              Text('Email: ${_email.text}', style: normalText),
            ],
          ],
        ),
      ),
    );
  }
}
