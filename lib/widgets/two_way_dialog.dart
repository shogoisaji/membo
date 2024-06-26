import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:membo/gen/fonts.gen.dart';
import 'package:membo/settings/color.dart';

/// Theme外から呼ぶことがあるのでText Styleは直接定義
class TwoWayDialog extends HookWidget {
  final String title;
  final Widget? icon;
  final String? content;
  final String leftButtonText;
  final String rightButtonText;
  final Function onLeftButtonPressed;
  final Function onRightButtonPressed;

  const TwoWayDialog({
    super.key,
    required this.title,
    this.icon,
    this.content,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final AnimationController animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    )..forward();
    final scaleAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    final slideAnimation = Tween<double>(begin: 5, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
            offset: Offset(slideAnimation.value, slideAnimation.value),
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: Dialog(
                child: LayoutBuilder(builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  return Container(
                    width: width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    decoration: BoxDecoration(
                      color: MyColor.greenLight,
                      border: Border.all(
                          width: 1,
                          color: MyColor.greenText,
                          strokeAlign: BorderSide.strokeAlignCenter),
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 5),
                          blurRadius: 5,
                        ),
                        const BoxShadow(
                          color: MyColor.greenText,
                          blurRadius: 0.5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        icon != null
                            ? Column(
                                children: [
                                  icon!,
                                  const SizedBox(height: 6),
                                ],
                              )
                            : const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(title,
                              style: const TextStyle(
                                fontSize: 24,
                                color: MyColor.greenText,
                                fontWeight: FontWeight.w700,
                                fontFamily: FontFamily.mPlusRounded1c,
                              )),
                        ),
                        content != null
                            ? Text(content!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: FontFamily.mPlusRounded1c,
                                ))
                            : const SizedBox.shrink(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                                onLeftButtonPressed();
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: MyColor.greenText,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                    topRight: Radius.circular(3),
                                    bottomRight: Radius.circular(3),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 2),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                    child: Text(leftButtonText,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: FontFamily.mPlusRounded1c,
                                        ))),
                              ),
                            )),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.pop(context);
                                  onRightButtonPressed();
                                },
                                child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: MyColor.greenSuperLight,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(18),
                                        bottomRight: Radius.circular(18),
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 2),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                        child: Text(rightButtonText,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: MyColor.greenText,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  FontFamily.mPlusRounded1c,
                                            )))),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ));
      },
    );
  }
}
