import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/models/board/board_model.dart';

class CustomCardWidget extends HookConsumerWidget {
  final BoardModel board;
  final double width;
  final double height;
  final String imageUrl;
  const CustomCardWidget(
      {super.key,
      required this.board,
      required this.width,
      required this.height,
      required this.imageUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const cardRadius = 14.0;
    const avatarRadius = 18.0;
    const positionXFromRight = 45.0;
    const contentBaseHeight = 80.0;

    final AnimationController animationController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    final Animation<double> animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    return GestureDetector(
      onTap: () {
        if (animationController.isCompleted) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
      },
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final contentHeight = contentBaseHeight + animation.value * 60;
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: const Offset(2, 3), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(cardRadius),
                          topRight: Radius.circular(cardRadius),
                        ),
                        child: Image.network(
                            'https://mawzoznhibuhrvxxyvtt.supabase.co/storage/v1/object/public/public_image/4388f096-1a3b-47af-aefa-57607fe18d21/4e363a75-4cf1-4e8f-a04a-b2ee0efb1f8a.webp',
                            fit: BoxFit.cover,
                            width: width,
                            height: double.infinity),
                      ),
                    ),
                    const SizedBox(height: contentBaseHeight),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomPaint(
                    size: Size(width, contentHeight),
                    painter: CardBasePainter(
                        avatarRadius: avatarRadius,
                        height: contentHeight,
                        positionXFromRight: positionXFromRight,
                        bottomRRadius: 14),
                  ),
                ),

                /// Owner Avatar
                Positioned(
                  bottom: contentHeight - avatarRadius,
                  right: positionXFromRight - avatarRadius,
                  child: CircleAvatar(
                    radius: avatarRadius,
                    foregroundImage: NetworkImage(imageUrl),
                  ),
                ),

                /// Content
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: contentHeight,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width - positionXFromRight - avatarRadius,
                          child: Text(
                            board.boardName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: avatarRadius,
                              foregroundImage: NetworkImage(imageUrl),
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                              radius: avatarRadius,
                              foregroundImage: NetworkImage(imageUrl),
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                              radius: avatarRadius,
                              foregroundImage: NetworkImage(imageUrl),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CardBasePainter extends CustomPainter {
  final double avatarRadius;
  final double height;
  final double positionXFromRight;
  final double bottomRRadius;

  CardBasePainter(
      {required this.avatarRadius,
      required this.height,
      required this.positionXFromRight,
      required this.bottomRRadius});

  @override
  void paint(Canvas canvas, Size size) {
    const paddingValue = 12.0;
    final strength = avatarRadius + paddingValue * 0.5;
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..style = PaintingStyle.fill;

    final Offset p0 = Offset(
        size.width - positionXFromRight - avatarRadius - paddingValue * 2, 0);
    final Offset p1 = Offset(p0.dx + strength, 0);
    final Offset p3 = Offset(size.width - positionXFromRight,
        -avatarRadius / 2 - paddingValue * 1.2);
    final Offset p2 = Offset(p3.dx - strength, p3.dy);
    final Offset p4 = Offset(p3.dx + strength, p3.dy);
    final Offset p6 = Offset(
        size.width - positionXFromRight + avatarRadius + paddingValue * 2, 0);
    final Offset p5 = Offset(p6.dx - strength, 0);
    final Offset p7 = Offset(size.width, 0);

    final Offset p8 = Offset(size.width, height);
    final Offset p9 = Offset(0, height);

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
      ..cubicTo(
        p4.dx,
        p4.dy,
        p5.dx,
        p5.dy,
        p6.dx,
        p6.dy,
      )
      ..lineTo(p7.dx, p7.dy)
      ..lineTo(p7.dx, p8.dy - bottomRRadius)
      ..arcToPoint(Offset(p8.dx - bottomRRadius, p8.dy),
          radius: Radius.circular(bottomRRadius), clockwise: true)
      ..lineTo(p9.dx + bottomRRadius, p9.dy)
      ..arcToPoint(Offset(p9.dx, p9.dy - bottomRRadius),
          radius: Radius.circular(bottomRRadius), clockwise: true)
      ..close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
