import 'package:flutter/material.dart';

class ColorConvertor {
  static Color moreDark(Color color) {
    const double darkValue = 0.15;
    double alpha = HSVColor.fromColor(color).alpha;
    double hue = HSVColor.fromColor(color).hue; // 色相を正しく取得
    double saturation = HSVColor.fromColor(color).saturation;
    double value = (HSVColor.fromColor(color).value - darkValue)
        .clamp(0.0, 1.0); // 明度を正しく減少させる
    Color newColor = HSVColor.fromAHSV(alpha, hue, saturation, value).toColor();
    return newColor;
  }
}
