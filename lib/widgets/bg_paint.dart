import 'package:flutter/material.dart';
import 'package:membo/settings/color.dart';

class BgPaint extends StatelessWidget {
  final double width;
  final double height;
  const BgPaint({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: BgPainter(),
    );
  }
}

class BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MyColor.pink
      ..style = PaintingStyle.fill;

    final Offset p0 = Offset(0, size.height * 0.45);
    final Offset p1 = Offset(size.width * 0.5, size.height * 0.45);
    final Offset p2 = Offset(size.width * 0.5, size.height * 0.25);
    final Offset p3 = Offset(size.width * 1.0, size.height * 0.25);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(p0.dx, p0.dy)
      ..cubicTo(
        p1.dx,
        p1.dy,
        p2.dx,
        p2.dy,
        p3.dx,
        p3.dy,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
