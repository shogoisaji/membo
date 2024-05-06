import 'package:flutter/material.dart';

class ErrorDialog {
  static void show(BuildContext context, String message,
      {String? secondaryMessage, Function? onTap}) {
    print('ErrorDialog: $message');
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              secondaryMessage != null
                  ? Text(secondaryMessage)
                  : const SizedBox.shrink(),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (onTap != null) {
                  onTap();
                }
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
