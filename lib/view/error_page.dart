import 'package:flutter/material.dart';
import 'package:membo/gen/assets.gen.dart';

class ErrorPage extends StatelessWidget {
  final Widget? child;
  const ErrorPage({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.asset(
              Assets.images.splash.path,
              width: 220,
              height: 220,
            ),
          ),
          child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
