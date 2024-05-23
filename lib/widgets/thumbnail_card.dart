import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:membo/gen/assets.gen.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';

class ThumbnailCard extends StatelessWidget {
  final BoardModel boardModel;
  final Function() onViewTap;
  final Function() onCancelTap;

  const ThumbnailCard(
      {super.key,
      required this.boardModel,
      required this.onViewTap,
      required this.onCancelTap});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: (w * 0.6).clamp(200, 300),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
            decoration: BoxDecoration(
              color: MyColor.greenSuperLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 5,
                color: MyColor.greenDark,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(1, 3),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      boardModel.boardName,
                      style: lightTextTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                    child: Image.network(boardModel.thumbnailUrl ?? "",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, url, error) => SvgPicture.asset(
                              'assets/images/svg/title.svg',
                              width: 100,
                              height: 100,
                              colorFilter: const ColorFilter.mode(
                                  MyColor.greenText, BlendMode.srcIn),
                            ))),
                Container(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 0),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(child: CancelButton(onTap: () {
                        HapticFeedback.lightImpact();
                        onCancelTap();
                      })),
                      const SizedBox(width: 10),
                      Expanded(child: ViewButton(onTap: () {
                        HapticFeedback.lightImpact();
                        onViewTap();
                      })),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class ViewButton extends StatelessWidget {
  final Function() onTap;
  const ViewButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MyColor.green,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(3),
            topLeft: Radius.circular(3),
            topRight: Radius.circular(3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 3,
              spreadRadius: 0.2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: SvgPicture.asset(
          Assets.images.svg.view,
          colorFilter:
              const ColorFilter.mode(MyColor.greenSuperLight, BlendMode.srcIn),
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final Function() onTap;
  const CancelButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            color: MyColor.lightRed,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(3),
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 3,
                spreadRadius: 0.2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: const Icon(
            Icons.clear_rounded,
            color: MyColor.greenSuperLight,
            size: 30,
          )),
    );
  }
}
