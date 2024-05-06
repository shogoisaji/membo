import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HueRingCustomPicker extends StatefulWidget {
  const HueRingCustomPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.portraitOnly = false,
    this.colorPickerHeight = 250.0,
    this.hueRingStrokeWidth = 20.0,
  });

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final bool portraitOnly;
  final double colorPickerHeight;
  final double hueRingStrokeWidth;

  @override
  HueRingCustomPickerState createState() => HueRingCustomPickerState();
}

class HueRingCustomPickerState extends State<HueRingCustomPicker> {
  HSVColor currentHsvColor = const HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0);

  @override
  void initState() {
    currentHsvColor = HSVColor.fromColor(widget.pickerColor);
    super.initState();
  }

  @override
  void didUpdateWidget(HueRingCustomPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentHsvColor = HSVColor.fromColor(widget.pickerColor);
  }

  void onColorChanging(HSVColor color) {
    setState(() => currentHsvColor = color);
    widget.onColorChanged(currentHsvColor.toColor());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15),
          child:
              Stack(alignment: AlignmentDirectional.center, children: <Widget>[
            SizedBox(
              width: widget.colorPickerHeight,
              height: widget.colorPickerHeight,
              child: ColorPickerHueRing(
                currentHsvColor,
                onColorChanging,
                strokeWidth: widget.hueRingStrokeWidth,
              ),
            ),
            SizedBox(
              width: widget.colorPickerHeight / 1.6,
              height: widget.colorPickerHeight / 1.6,
              child: ColorPickerArea(
                  currentHsvColor, onColorChanging, PaletteType.hsv),
            )
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          width: widget.colorPickerHeight / 1.6,
          height: 50,
          decoration: BoxDecoration(
            color: currentHsvColor.toColor(),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}
