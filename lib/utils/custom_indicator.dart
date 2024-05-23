import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:membo/settings/color.dart';

class CustomIndicator extends HookWidget {
  const CustomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final AnimationController animationController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return SizedBox(
          width: 120,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...List.generate(
                6,
                (index) => Align(
                  alignment: Alignment(
                    0.0,
                    (sin(animation.value * 2 * pi + index)).clamp(-1, 1),
                  ),
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color:
                          (index % 2 == 0) ? MyColor.pink : MyColor.greenDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
