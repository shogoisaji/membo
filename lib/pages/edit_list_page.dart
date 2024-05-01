import 'package:flutter/material.dart';

class EditListPage extends StatelessWidget {
  const EditListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit List'),
      ),
      body: const Center(
        child: Text('Edit List'),
      ),
    );
  }
}
