import 'package:flutter/material.dart';

const myColorTheme = ColorScheme(
  brightness: Brightness.light,
  primary: MyColor.greenText,
  onPrimary: Color.fromARGB(255, 196, 202, 203),
  secondary: Color(0xFFFF9800),
  onSecondary: Colors.brown,
  error: Colors.red,
  onError: Colors.white,
  background: Color(0xFF678A74),
  onBackground: Color.fromARGB(255, 240, 105, 188),
  surface: MyColor.greenLight,
  onSurface: MyColor.greenText,
);

class MyColor {
  static const Color green = Color(0xFF678A74);
  static const Color greenLight = Color(0xFF81A58E);
  static const Color greenSuperLight = Color(0xFFDBEEE2);
  static const Color greenDark = Color(0xFF577E66);
  static const Color greenText = Color(0xFF20412C);
  static const Color pink = Color(0xFFFFA0A0);
}
