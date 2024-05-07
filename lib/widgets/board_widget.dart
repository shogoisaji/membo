import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/utils/color_utils.dart';
import 'package:membo/view_model/edit_page_view_model.dart';

class BoardWidget extends HookWidget {
  final BoardModel board;
  final ObjectModel? selectedObject;
  const BoardWidget({super.key, required this.board, this.selectedObject});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: board.settings.width,
        height: board.settings.height,
        color: Color(int.parse(board.settings.bgColor)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: BoardCanvasPainter(
                  canvasColor: Color(int.parse(board.settings.bgColor)),
                  objects: board.objects),
              size: Size(board.settings.width, board.settings.height),
            ),
            ...board.objects
                .map((object) => ObjectWidget(object: object, opacity: 1.0)),
            if (selectedObject != null)
              SelectedObject(object: selectedObject!)
            else
              const SizedBox.shrink(),
          ],
        ));
  }
}

class BoardCanvasPainter extends CustomPainter {
  final Color canvasColor;
  final List<ObjectModel> objects;

  BoardCanvasPainter({
    required this.canvasColor,
    required this.objects,
  });

  @override
  void paint(Canvas canvas, Size size) async {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SelectedObject extends HookConsumerWidget {
  final ObjectModel object;
  const SelectedObject({super.key, required this.object});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    )..forward();
    final initialAnimation = Tween<double>(begin: 5.0, end: 1.0).animate(
        CurvedAnimation(
            parent: initialAnimationController,
            curve: const Cubic(0.175, 0.885, 0.32, 1.03)));
    final opacityAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    final opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
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
                object: object, opacity: opacityAnimation.value);
          },
        );
      },
    );
  }
}

class ObjectWidget extends StatelessWidget {
  final ObjectModel object;
  final double opacity;
  const ObjectWidget({super.key, required this.object, required this.opacity});

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
    final child = objectCheck();
    final centerX =
        object.positionX - (object.imageWidth ?? 0.0) * object.scale / 2;
    final centerY =
        object.positionY - (object.imageHeight ?? 0.0) * object.scale / 2;

    return Positioned(
      top: centerY,
      left: centerX,
      child: Transform.scale(
        alignment: object.type == ObjectType.text
            ? Alignment.topLeft
            : Alignment.center,
        scale: object.scale,
        child: Transform.rotate(
          alignment: object.type == ObjectType.text
              ? Alignment.topLeft
              : Alignment.center,
          angle: object.angle, // angle: object.angle,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _networkImageWidget() {
    if (object.imageUrl == null) {
      return _errorImageWidget();
    }
    return CachedNetworkImage(
        imageUrl: object.imageUrl!,
        // width: object.imageWidth != null
        //     ? object.imageWidth! * object.scale
        //     : null,
        // height: object.imageHeight != null
        //     ? object.imageHeight! * object.scale
        //     : null,
        width: object.imageWidth,
        height: object.imageHeight,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        placeholder: (context, url) => const ColoredBox(color: Colors.white),
        errorWidget: (context, url, error) => _errorImageWidget());
  }

  Widget _localImageWidget() {
    if (object.imageUrl == null) {
      return _errorImageWidget();
    }
    return Image.file(
      width:
          object.imageWidth != null ? object.imageWidth! * object.scale : null,
      height: object.imageHeight != null
          ? object.imageHeight! * object.scale
          : null,
      File(object.imageUrl!),
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

    final size = textSize(text: text, textStyle: textStyle, maxWidth: 1000);

    return CustomPaint(
      painter: TextObjectPainter(
          text: text,
          textStyle: TextStyle(
            fontSize: 100,
            color: Color(int.parse(object.bgColor)),
          )),
      size: Size(size.width, size.height),
    );
  }
}

class TextObjectPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;

  TextObjectPainter({required this.text, required this.textStyle});

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final xCenter = -textPainter.width / 2;
    final yCenter = -textPainter.height / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
