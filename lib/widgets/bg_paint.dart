import 'package:flutter/material.dart';
import 'package:membo/settings/color.dart';

class BgPaint extends StatelessWidget {
  final double width;
  final double height;

  const BgPaint({
    super.key,
    required this.width,
    required this.height,
  });

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
    const double upperHeight = 300;
    const double lowerHeight = 450;

    final bgPaint = Paint()
      ..color = MyColor.green
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    final paint = Paint()
      ..color = MyColor.pink
      ..style = PaintingStyle.fill;

    const Offset p0 = Offset(0, lowerHeight);
    final Offset p1 = Offset(size.width * 0.5, lowerHeight);
    final Offset p2 = Offset(size.width * 0.5, upperHeight);
    final Offset p3 = Offset(size.width * 1.0, upperHeight);

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
