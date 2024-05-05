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
              children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: width,
                    height: height - elevation * (1 - controller.value * 0.5),
                    decoration: BoxDecoration(
                      color: ColorUtils.moreDark(color),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Positioned(
                  top: elevation * controller.value * 0.5,
                  child: Container(
                    width: width,
                    height: height - elevation,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
