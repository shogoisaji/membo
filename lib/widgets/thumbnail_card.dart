import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';

class ThumbnailCard extends StatelessWidget {
  final BoardModel boardModel;

  const ThumbnailCard({super.key, required this.boardModel});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: (w * 0.7).clamp(200, 400),
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
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(1, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 50,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      boardModel.boardName,
                      style: lightTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Expanded(
                    child: CachedNetworkImage(
                        imageUrl:
                            'https://mawzoznhibuhrvxxyvtt.supabase.co/storage/v1/object/public/public_image/0996ec38-d300-4dd4-9e8b-1a887954c275/c7151efe-1fde-4dfd-ad80-269ae09b5daf.png',
                        width: double.infinity,
                        height: double.infinity,
                        imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                        placeholder: (context, url) =>
                            const ColoredBox(color: Colors.white),
                        errorWidget: (context, url, error) => const ColoredBox(
                            color: Colors.white, child: Icon(Icons.error)))),
                Container(
                  height: 50,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      boardModel.boardName,
                      style: lightTextTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
