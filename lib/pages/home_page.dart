import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Welcome to the Home Page', style: TextStyle(color: Colors.green, fontSize: 40)),
            ElevatedButton(onPressed: () => context.push('/board'), child: const Text('Go to Board Page')),
            ElevatedButton(onPressed: () => context.go('/settings'), child: const Text('Go to Settings Page')),
          ],
        ),
      ),
    );
  }
}
