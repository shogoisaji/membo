import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SharingWidget extends StatelessWidget {
  final String boardId;
  final Function onTapModal;
  const SharingWidget(
      {super.key, required this.boardId, required this.onTapModal});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: () {
        onTapModal();
      },
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32)),
                child: QrImageView(
                  data: boardId,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 50),
              Text(
                'ボードID',
                style: lightTextTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              SelectableText(
                boardId.replaceAll('-', ''),
                style: lightTextTheme.bodySmall!.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: boardId.replaceAll('-', '')));
                },
                child: Text(
                  'IDをコピー',
                  style: lightTextTheme.bodySmall,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
