import 'package:flutter/material.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';

class TwoWayDialog extends StatelessWidget {
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
    return Dialog(
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        print(width);
        return Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          decoration: BoxDecoration(
            color: MyColor.greenLight,
            border: Border.all(
                width: 5,
                color: MyColor.greenText,
                strokeAlign: BorderSide.strokeAlignCenter),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 5),
                blurRadius: 5,
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
                        const SizedBox(height: 8),
                      ],
                    )
                  : const SizedBox.shrink(),
              Text(
                title,
                style: lightTextTheme.titleLarge,
              ),
              content != null
                  ? Text(
                      content!,
                      style: lightTextTheme.bodyLarge,
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () => onLeftButtonPressed(),
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
                              style: lightTextTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ))),
                    ),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => onRightButtonPressed(),
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
                              child: Text(
                            rightButtonText,
                            style: lightTextTheme.bodyMedium,
                          ))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
