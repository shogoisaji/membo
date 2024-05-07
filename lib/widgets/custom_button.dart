import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:membo/utils/color_utils.dart';

class CustomButton extends HookWidget {
  final double width;
  final double height;
  final Color color;
  final Widget child;
  final Function() onTap;
  const CustomButton(
      {super.key,
      required this.width,
      required this.height,
      required this.color,
      required this.child,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    const double elevation = 8.0;

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );

    useEffect(() {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse(from: 0.5);
        }
      });
      return;
    }, []);

    return GestureDetector(
      onTap: () {
        controller.reset();
        Future.delayed(const Duration(milliseconds: 200), () {
          onTap();
        });
        controller.forward();
      },
      child: SizedBox(
          width: width,
          height: height,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) => Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: ButtonShapePainter(
                      color: ColorUtils.moreDark(color), elevation: elevation),
                  size: Size(width, height),
                ),
                CustomPaint(
                  painter: ButtonShapePainter(
                      color: color,
                      elevation: elevation * controller.value * 0.5),
                  size: Size(width, height),
                ),
                Transform.translate(
                  offset: Offset(
                      0, elevation / 2 * controller.value), // ここでchildを動かす
                  child: child,
                ),
              ],
            ),
          )),
    );
  }
}

class ButtonShapePainter extends CustomPainter {
  final Color color;
  final double elevation;
  final double radius = 24;
  ButtonShapePainter({required this.color, required this.elevation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, elevation, size.width, size.height),
            Radius.circular(radius)),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
