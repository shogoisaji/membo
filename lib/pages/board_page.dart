import 'package:flutter/material.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Board Page', style: TextStyle(color: Colors.green, fontSize: 40)),
      ),
    );
  }
}
