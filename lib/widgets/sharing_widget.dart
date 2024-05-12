import 'package:flutter/material.dart';
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
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(32)),
            child: QrImageView(
              data: boardId,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
        ),
      ),
    );
  }
}
