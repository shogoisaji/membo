import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/widgets/custom_snackbar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SharingWidget extends HookWidget {
  final String boardId;
  final Function onTapModal;
  const SharingWidget(
      {super.key, required this.boardId, required this.onTapModal});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    )..forward();

    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    return GestureDetector(
      onTap: () {
        onTapModal();
      },
      child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [
                      0.0,
                      1
                      // animation.value,
                    ],
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.7 * animation.value),
                    ]),
              ),
              child: Transform.translate(
                offset: Offset(0, 8 * (animation.value - 1)),
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
                        style: lightTextTheme.bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        boardId.replaceAll('-', ''),
                        style: lightTextTheme.bodySmall!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.greenSuperLight,
                        ),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: boardId.replaceAll('-', '')));
                          CustomSnackBar.show(
                              context, 'IDをコピーしました', MyColor.lightBlue);
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
          }),
    );
  }
}
