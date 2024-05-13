import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/settings/color.dart';

class CustomHomeCardWidget extends HookConsumerWidget {
  final BoardModel board;
  final double width;
  final double height;
  final String imageUrl;
  final Function() onTapQr;
  final Function() onTapView;
  const CustomHomeCardWidget(
      {super.key,
      required this.board,
      required this.width,
      required this.height,
      required this.imageUrl,
      required this.onTapQr,
      required this.onTapView});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const cardRadius = 14.0;
    const avatarRadius = 18.0;
    const positionXFromRight = 45.0;
    const contentBaseHeight = 80.0;

    final AnimationController animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final Animation<double> animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    print('board.boardName: $width');

    const tempImageUrl =
        'https://mawzoznhibuhrvxxyvtt.supabase.co/storage/v1/object/public/avatar_image/07b77fc9-b55e-4734-9a42-e5755d486f35/1715592393818.webp';

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
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(2, 3), // changes position of shadow
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(cardRadius),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Image.network(imageUrl,
                            fit: BoxFit.cover,
                            width: width,
                            height: double.infinity,
                            errorBuilder: (context, url, error) => Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                      child: Icon(Icons.error, size: 32)),
                                )),
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
                    child: const CircleAvatar(
                      radius: avatarRadius,
                      foregroundImage: NetworkImage(tempImageUrl),
                    ),
                  ),

                  /// Content
                  Positioned(
                    bottom: (-1 + animation.value) * 60,
                    child: Container(
                      height: 140,
                      width: width,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SizedBox(
                                  width:
                                      width - positionXFromRight - avatarRadius,
                                  child: Text(
                                    board.boardName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),

                              /// linked user list
                              const SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    CircleAvatar(
                                      radius: avatarRadius,
                                      foregroundImage:
                                          NetworkImage(tempImageUrl),
                                    ),
                                    SizedBox(width: 10),
                                    CircleAvatar(
                                      radius: avatarRadius,
                                      foregroundImage:
                                          NetworkImage(tempImageUrl),
                                    ),
                                    SizedBox(width: 10),
                                    CircleAvatar(
                                      radius: avatarRadius,
                                      foregroundImage:
                                          NetworkImage(tempImageUrl),
                                    ),
                                    SizedBox(width: 10),
                                    CircleAvatar(
                                      radius: avatarRadius,
                                      foregroundImage:
                                          NetworkImage(tempImageUrl),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      onTapQr();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MyColor.green,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(3),
                                          topLeft: Radius.circular(3),
                                          topRight: Radius.circular(3),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 3,
                                            spreadRadius: 0.2,
                                            offset: const Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: SvgPicture.asset(
                                        'assets/images/svg/qr.svg',
                                        width: 30,
                                        height: 30,
                                        color: MyColor.greenSuperLight,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      onTapView();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MyColor.greenDark,
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(3),
                                          topLeft: Radius.circular(3),
                                          topRight: Radius.circular(3),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 3,
                                            spreadRadius: 0.2,
                                            offset: const Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: SvgPicture.asset(
                                        'assets/images/svg/view.svg',
                                        color: MyColor.greenSuperLight,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
