import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/gen/fonts.gen.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/utils/color_utils.dart';
import 'package:membo/view_model/edit_page_view_model.dart';

class BoardWidget extends HookWidget {
  final BoardModel board;
  final ObjectModel? selectedObject;
  const BoardWidget({super.key, required this.board, this.selectedObject});

  @override
  Widget build(BuildContext context) {
    final boardBasePadding = board.width * board.height / 500000 + 80;
    final boardRadius = boardBasePadding / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // color: MyColor.lightBrown,
          width: board.width.toDouble(),
          margin: EdgeInsets.only(left: boardBasePadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 0),
                decoration: BoxDecoration(
                    color: MyColor.lightRed,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        spreadRadius: 5,
                        offset: const Offset(5, 10),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                    color: MyColor.lightBrown,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 5,
                        spreadRadius: 3,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      board.boardName,
                      style: lightTextTheme.bodyLarge!.copyWith(fontSize: 54),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final effectiveWidth = constraints.maxWidth;
                    return Text(
                      '${board.thatDay.year}.${board.thatDay.month}.${board.thatDay.day}',
                      style: TextStyle(
                        height: 0.75,
                        color: MyColor.lightBrown,
                        fontSize: (effectiveWidth / 6.5).clamp(30.0, 80.0),
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(5, 5),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(boardBasePadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyColor.brown,
                ColorUtils.moreDark(MyColor.brown),
              ],
            ),
            borderRadius: BorderRadius.circular(boardBasePadding),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: board.height / 30,
                spreadRadius: board.height / 200,
                offset: Offset(board.height / 200, board.height / 150),
              ),
            ],
          ),

          /// writable area
          child: Container(
              width: board.width.toDouble(),
              height: board.height.toDouble(),
              decoration: BoxDecoration(
                color: Color(int.parse(board.bgColor)),
                borderRadius: BorderRadius.circular(boardRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: board.height / 80,
                    spreadRadius: board.height / 300,
                    offset: Offset(board.height / 350, board.height / 300),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(boardRadius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// 既存のオブジェクト達
                    ...board.objects.map((object) => Stack(
                          fit: StackFit.expand,
                          children: [
                            ObjectWidget(
                                object: object,
                                opacity: 1.0,
                                boardWidth: board.width.toDouble(),
                                boardHeight: board.height.toDouble())
                          ],
                        )),

                    /// 選択中のオブジェクト
                    selectedObject != null
                        ? SelectedObject(object: selectedObject!, board: board)
                        : const SizedBox.shrink(),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}

class PreventOverflowClipper extends CustomClipper<RRect> {
  final double radius;
  PreventOverflowClipper({required this.radius});
  @override
  RRect getClip(Size size) {
    return RRect.fromLTRBR(
        0, 0, size.width, size.height, Radius.circular(radius));
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) => false;
}

class SelectedObject extends HookConsumerWidget {
  final ObjectModel object;
  final BoardModel board;
  const SelectedObject({super.key, required this.object, required this.board});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 700),
    )..forward();
    final initialAnimation = Tween<double>(begin: 5.0, end: 1.0).animate(
        CurvedAnimation(
            parent: initialAnimationController,
            curve: const Cubic(0.175, 0.885, 0.32, 1.03)));
    final opacityAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    final opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(
            parent: opacityAnimationController, curve: Curves.easeOut));

    useEffect(() {
      initialAnimationController.addListener(() {
        ref
            .read(editPageViewModelProvider.notifier)
            .scaleSelectedObject(initialAnimation.value);
      });
      return null;
    }, []);

    return AnimatedBuilder(
      animation: initialAnimation,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: opacityAnimation,
          builder: (context, child) {
            return ObjectWidget(
                object: object,
                opacity: opacityAnimation.value,
                boardWidth: board.width.toDouble(),
                boardHeight: board.height.toDouble());
          },
        );
      },
    );
  }
}

class ObjectWidget extends StatelessWidget {
  final ObjectModel object;
  final double opacity;
  final double boardWidth;
  final double boardHeight;
  const ObjectWidget(
      {super.key,
      required this.object,
      required this.opacity,
      required this.boardWidth,
      required this.boardHeight});

  Widget objectCheck() {
    if (object.type == ObjectType.networkImage) {
      return _networkImageWidget();
    } else if (object.type == ObjectType.localImage) {
      return _localImageWidget();
    } else if (object.type == ObjectType.text) {
      return _textWidget();
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkedObjectWidget = objectCheck();
    final objectCenterX = boardWidth / 2 +
        object.positionX -
        (object.imageWidth ?? 0.0) * object.scale / 2;
    final objectCenterY = boardHeight / 2 +
        object.positionY -
        (object.imageHeight ?? 0.0) * object.scale / 2;

    return Positioned(
      top: objectCenterY,
      left: objectCenterX,
      child: Transform.rotate(
        alignment: object.type == ObjectType.text
            ? Alignment.topLeft
            : Alignment.center,
        angle: object.angle, // angle: object.angle,
        child: Opacity(
          opacity: opacity,
          child: checkedObjectWidget,
        ),
      ),
    );
  }

  Widget _networkImageWidget() {
    if (object.imageUrl == null) {
      print('object.imageUrl is null');
      return _errorImageWidget();
    }
    if (object.imageWidth == null || object.imageHeight == null) {
      print('object.imageWidth or object.imageHeight is null');
      return _errorImageWidget();
    }
    return CachedNetworkImage(
        imageUrl: object.imageUrl!,
        width: object.imageWidth! * object.scale,
        height: object.imageHeight! * object.scale,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        placeholder: (context, url) => ColoredBox(color: Colors.grey.shade200),
        errorWidget: (context, url, error) => _errorImageWidget());
  }

  Widget _localImageWidget() {
    if (object.imageUrl == null) {
      print('object.imageUrl is null');
      return _errorImageWidget();
    }
    if (object.imageWidth == null || object.imageHeight == null) {
      print('object.imageWidth or object.imageHeight is null');
      return _errorImageWidget();
    }
    return Image.file(
      width: object.imageWidth! * object.scale,
      height: object.imageHeight! * object.scale,
      File(object.imageUrl!),
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _errorImageWidget();
      },
    );
  }

  Widget _errorImageWidget() {
    final double hue =
        object.imageWidth != null ? (object.imageWidth! % 360) : 0;
    final color = HSVColor.fromAHSV(1.0, hue, 0.3, 0.7).toColor();
    final bgColor = ColorUtils.moreDark(color);
    return Container(
      width:
          object.imageWidth != null ? object.imageWidth! * object.scale : null,
      height: object.imageHeight != null
          ? object.imageHeight! * object.scale
          : null,
      color: bgColor,
      child: Center(
          child: Icon(
        Icons.error,
        size: object.imageWidth != null
            ? object.imageWidth! * object.scale * 0.7
            : 100,
        color: color,
      )),
    );
  }

  Widget _textWidget() {
    final text = object.text ?? '???';
    final textStyle = TextStyle(
      color: Color(int.parse(object.bgColor)),
      fontSize: 100,
      fontFamily: FontFamily.mPlusRounded1c,
      fontWeight: FontWeight.w700,
    );
    final textBgStyle = TextStyle(
      fontSize: 100,
      fontFamily: FontFamily.mPlusRounded1c,
      fontWeight: FontWeight.w700,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 11.0
        ..color = Colors.grey.shade200,
      shadows: const [
        Shadow(
          blurRadius: 8.0,
          color: Colors.black,
          offset: Offset(4.0, 5.0),
        ),
      ],
    );

    Size textSize({
      required String text,
      required TextStyle textStyle,
      required double maxWidth,
    }) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: textStyle,
        ),
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr,
      )..layout(
          minWidth: 0,
          maxWidth: maxWidth,
        );
      return textPainter.size;
    }

    final size = textSize(text: text, textStyle: textStyle, maxWidth: 10000);

    return Transform.scale(
      alignment: Alignment.topLeft,
      scale: object.scale,
      child: CustomPaint(
        painter: TextObjectPainter(
            text: text, textStyle: textStyle, textBgStyle: textBgStyle),
        size: Size(size.width, size.height),
      ),
    );
  }
}

class TextObjectPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final TextStyle textBgStyle;

  TextObjectPainter(
      {required this.text, required this.textStyle, required this.textBgStyle});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    final textBgPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textBgStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    /// textPainterはlayoutを呼ぶ必要がある
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textBgPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final xCenter = -textPainter.width / 2;
    final yCenter = -textPainter.height / 2;
    final offset = Offset(xCenter, yCenter);
    textBgPainter.paint(canvas, offset);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
