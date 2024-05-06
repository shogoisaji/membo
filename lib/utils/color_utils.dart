import 'dart:math';

import 'package:flutter/material.dart';

class ColorUtils {
  static Color moreDark(Color color) {
    const double darkValue = 0.1;
    double alpha = HSVColor.fromColor(color).alpha;
    double hue = HSVColor.fromColor(color).hue; // 色相を正しく取得
    double saturation = HSVColor.fromColor(color).saturation;
    double value = (HSVColor.fromColor(color).value - darkValue)
        .clamp(0.0, 1.0); // 明度を正しく減少させる
    Color newColor = HSVColor.fromAHSV(alpha, hue, saturation, value).toColor();
    return newColor;
  }

  static Color randomColor() {
    final color =
        HSVColor.fromAHSV(1.0, Random().nextDouble() * 360.0, 0.3, 0.7)
            .toColor();
    return color;
  }

  static String colorToString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  static String colorToHexString(Color color) {
    return '0xff${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  static Color stringColorToHex(String colorString) {
    return Color(int.parse(colorString.replaceFirst('#', '0xff')));
  }
}
