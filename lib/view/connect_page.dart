import 'package:flutter/material.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/widgets/bg_paint.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          Center(
            child: Text('Connect Page', style: lightTextTheme.titleLarge),
          ),
        ],
      ),
    );
  }
}
