import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';

/// onTap : null -> Navigator.pop(context)
class ErrorDialog {
  static void show(BuildContext context, String message,
      {String? secondaryMessage, Function()? onTap}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
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
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/svg/circle-exclamation.svg',
                        colorFilter: const ColorFilter.mode(
                            MyColor.greenText, BlendMode.srcIn),
                        width: 36,
                        height: 36,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  Text(
                    message,
                    style: lightTextTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(dialogContext);
                        onTap != null ? onTap() : Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: MyColor.greenText,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                            child: Text('OK',
                                style: lightTextTheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                ))),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
