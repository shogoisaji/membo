import 'package:flutter/material.dart';

class AppBarPainter extends CustomPainter {
  final Color color;
  final double progress;
  final bool isShadow;
  AppBarPainter(
      {required this.color, this.progress = 0.0, this.isShadow = false});
  @override
  void paint(Canvas canvas, Size size) {
    final shapeWidth = size.width * 0.1;
    final shapeHeight = size.width * 0.06;
    final shapePosition = size.width * progress;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Offset p1 = Offset(shapePosition - shapeWidth, size.height);
    final Offset p2 =
        Offset(shapePosition - shapeWidth, size.height + shapeHeight);
    final Offset p3 = Offset(shapePosition, size.height + shapeHeight);
    final Offset p4 =
        Offset(shapePosition + shapeWidth, size.height + shapeHeight);
    final Offset p5 = Offset(shapePosition + shapeWidth, size.height);
    final Offset p6 = Offset(shapePosition + shapeWidth * 2, size.height);

    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(shapePosition - shapeWidth * 2, size.height);
    // path.lineTo(p1.dx, p1.dy);
    path.cubicTo(
      p1.dx,
      p1.dy,
      p2.dx,
      p2.dy,
      p3.dx,
      p3.dy,
    );
    path.cubicTo(
      p4.dx,
      p4.dy,
      p5.dx,
      p5.dy,
      p6.dx,
      p6.dy,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    // path.lineTo(0, 0);
    path.close();

    isShadow ? canvas.drawShadow(path, Colors.black, 5, false) : null;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
