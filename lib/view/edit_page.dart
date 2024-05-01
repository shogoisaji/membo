import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: const Center(
        child: Text('Welcome to the Board Page',
            style: TextStyle(color: Colors.green, fontSize: 40)),
      ),
    );
  }
}
