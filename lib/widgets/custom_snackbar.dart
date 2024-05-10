import 'package:flutter/material.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';

class CustomSnackBar {
  static void show(
    BuildContext context,
    String message,
    Color color,
  ) {
    final snackBar = SnackBar(
      content: Center(
          child: Text(message,
              style: lightTextTheme.bodyLarge!
                  .copyWith(color: MyColor.greenSuperLight))),
      backgroundColor: color,
      duration: const Duration(milliseconds: 1500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
