import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to the Settings Page', style: TextStyle(color: Colors.green, fontSize: 40)),
            ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go Back')),
          ],
        ),
      ),
    );
  }
}
