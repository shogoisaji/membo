import 'package:flutter/material.dart';
import 'package:membo/settings/text_theme.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text('Connect Page', style: lightTextTheme.titleLarge),
      ),
    );
  }
}
