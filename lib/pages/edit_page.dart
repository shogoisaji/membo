import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Board Page',
            style: TextStyle(color: Colors.green, fontSize: 40)),
      ),
    );
  }
}
