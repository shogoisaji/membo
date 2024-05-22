import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/board_permission.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/utils/color_utils.dart';

class CustomHomeCardWidget extends HookConsumerWidget {
  final BoardModel board;
  final double width;
  final double height;
  final String imageUrl;
  final BoardPermission permission;
  final Function() onTapQr;
  final Function() onTapView;
  final Function() onTapDelete;
  final Function() onTapEdit;
  const CustomHomeCardWidget(
      {super.key,
      required this.board,
      required this.width,
      required this.height,
      required this.imageUrl,
      required this.onTapQr,
      required this.onTapView,
      required this.onTapEdit,
      required this.onTapDelete,
      required this.permission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const cardRadius = 14.0;
    const ownerAvatarRadius = 24.0;
    const editorAvatarRadius = 18.0;
    const positionXFromRight = 45.0;
    const contentBaseHeight = 80.0;
    const slideHeight = 105.0;

    final deleteFirstTap = useState(false);
    final ownerAvatarUrl = useState<String?>(null);
    final editorAvatarUrlList = useState<List<String>>([]);

    final AnimationController animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final Animation<double> animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    Future<List<String>> fetchAvatarUrls(List<String> userIds) async {
      final urls = <String>[];
      for (final userId in userIds) {
        final url = await ref
            .read(supabaseRepositoryProvider)
            .fetchAvatarImageUrl(userId)
            .catchError((_) {
          return '-';
        });
        urls.add(url);
      }
      return urls;
    }

    void initialize() async {
      try {
        ownerAvatarUrl.value = await fetchAvatarUrls([board.ownerId])
            .then((value) => value.isNotEmpty ? value.first : null);
      } catch (e) {
        throw Exception('Owner avatar image url is not loaded');
      }

      try {
        editorAvatarUrlList.value =
            await fetchAvatarUrls(board.editableUserIds);
      } catch (e) {
        throw Exception('Editor avatar image url is not loaded');
      }
    }

    void handleTapDelete() {
      onTapDelete();
      animationController.reset();
      deleteFirstTap.value = false;
    }

    void handleTapDeleteCancel() {
      deleteFirstTap.value = false;
    }

    useEffect(() {
      initialize();
      return null;
    }, const []);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (animationController.isCompleted) {
          animationController.reverse();
          Future.delayed(const Duration(milliseconds: 300), () {
            deleteFirstTap.value = false;
          });
        } else {
          animationController.forward();
        }
      },
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final contentHeight =
              contentBaseHeight + animation.value * slideHeight;
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(2, 3), // changes position of shadow
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(cardRadius),
              ),
              child: Stack(
                children: [
                  /// thumbnail image
                  Align(
                    alignment: Alignment.topCenter,
                    child: board.thumbnailUrl != null
                        ? CachedNetworkImage(
                            imageUrl: board.thumbnailUrl!,
                            fit: BoxFit.cover,
                            width: width,
                            height: height,
                            placeholder: (context, url) =>
                                ColoredBox(color: Colors.grey.shade200),
                            errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ))
                        : Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),

                  /// permission label
                  Positioned(
                      top: 0,
                      left: 0,
                      child: CustomPaint(
                        size: const Size(60, 60),
                        painter: LabelPainter(
                            color: permission == BoardPermission.owner
                                ? MyColor.lightRed
                                : permission == BoardPermission.editor
                                    ? const Color.fromARGB(255, 72, 90, 255)
                                    // ? MyColor.lightBlue
                                    : null),
                      )),

                  /// permission icon
                  Positioned(
                      top: 5,
                      left: 5,
                      child: Icon(
                        permission == BoardPermission.owner
                            ? Icons.star
                            : permission == BoardPermission.editor
                                ? Icons.edit
                                : null,
                        color: MyColor.greenSuperLight,
                        size: 24,
                      )),

                  /// bookmark label
                  permission == BoardPermission.owner
                      ? const SizedBox.shrink()
                      : Positioned(
                          top: 5,
                          right: 5,
                          child: Icon(Icons.bookmark_rounded,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                              color: MyColor.greenDark,
                              size: 30)),

                  /// delete label
                  Positioned(
                      bottom: 0,
                      left: 32,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          deleteFirstTap.value = !deleteFirstTap.value;
                        },
                        child: Container(
                          width: 50,
                          height: contentHeight + animation.value * 55 - 10,
                          padding: const EdgeInsets.only(top: 8),
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: MyColor.red,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                                spreadRadius: 1,
                                offset: const Offset(1, 0),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: MyColor.greenSuperLight,
                            size: 30,
                          ),
                        ),
                      )),

                  /// card 下部のウェーブコンテントエリア
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomPaint(
                      size: Size(width, contentHeight),
                      painter: CardBasePainter(
                          avatarRadius: ownerAvatarRadius,
                          height: contentHeight,
                          positionXFromRight: positionXFromRight,
                          bottomRRadius: 14),
                    ),
                  ),

                  /// Owner Avatar
                  Positioned(
                    bottom: contentHeight - ownerAvatarRadius,
                    right: positionXFromRight - ownerAvatarRadius,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(ownerAvatarRadius),
                      child: ColoredBox(
                        color: MyColor.greenText,
                        child: CachedNetworkImage(
                          imageUrl: ownerAvatarUrl.value ?? '',
                          fit: BoxFit.cover,
                          width: ownerAvatarRadius * 2,
                          height: ownerAvatarRadius * 2,
                          placeholder: (context, url) =>
                              ColoredBox(color: Colors.grey.shade200),
                          errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 30,
                              color: MyColor.greenSuperLight),
                        ),
                      ),
                    ),
                  ),

                  /// Content
                  Positioned(
                    bottom: (animation.value - 1) * slideHeight,
                    child: Container(
                      height: contentBaseHeight + slideHeight,
                      width: width,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SizedBox(
                                  width: width -
                                      positionXFromRight -
                                      ownerAvatarRadius,
                                  child: Text(
                                    board.boardName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),

                              /// linked user list
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ...editorAvatarUrlList.value.map((url) =>
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      editorAvatarRadius),
                                              child: ColoredBox(
                                                color: MyColor.greenText,
                                                child: CachedNetworkImage(
                                                  imageUrl: url,
                                                  fit: BoxFit.cover,
                                                  width: editorAvatarRadius * 2,
                                                  height:
                                                      editorAvatarRadius * 2,
                                                  placeholder: (context, url) =>
                                                      ColoredBox(
                                                          color: Colors
                                                              .grey.shade200),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.person,
                                                          size: 30,
                                                          color: MyColor
                                                              .greenSuperLight),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          animationController.value == 0.0
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: deleteFirstTap.value
                                                ? DeleteButton(
                                                    onTap: () {
                                                      HapticFeedback
                                                          .lightImpact();
                                                      handleTapDelete();
                                                    },
                                                    permission: permission,
                                                  )
                                                : QrButton(
                                                    onTap: () {
                                                      HapticFeedback
                                                          .lightImpact();
                                                      onTapQr();
                                                    },
                                                    permission: permission,
                                                  ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: deleteFirstTap.value
                                                ? DeleteCancelButton(onTap: () {
                                                    HapticFeedback
                                                        .lightImpact();
                                                    handleTapDeleteCancel();
                                                  })
                                                : EditButton(
                                                    onTap: () {
                                                      HapticFeedback
                                                          .lightImpact();
                                                      onTapEdit();
                                                    },
                                                    permission: permission,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ViewButton(
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                onTapView();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
        height: 40,
        decoration: BoxDecoration(
          color: MyColor.green,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10),
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
        child: SvgPicture.asset(
          'assets/images/svg/view.svg',
          colorFilter:
              const ColorFilter.mode(MyColor.greenSuperLight, BlendMode.srcIn),
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}

class QrButton extends StatelessWidget {
  final Function() onTap;
  final BoardPermission permission;
  const QrButton({super.key, required this.onTap, required this.permission});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (permission != BoardPermission.owner) {
          return;
        }
        onTap();
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: permission != BoardPermission.owner
              ? Colors.grey.shade400
              : MyColor.blue,
          borderRadius: const BorderRadius.all(
            Radius.circular(3),
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
          'assets/images/svg/qr.svg',
          width: 30,
          height: 30,
          colorFilter:
              const ColorFilter.mode(MyColor.greenSuperLight, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final Function() onTap;
  final BoardPermission permission;
  const EditButton({super.key, required this.onTap, required this.permission});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (permission == BoardPermission.viewer) {
          return;
        }
        onTap();
      },
      child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: permission == BoardPermission.viewer
                ? Colors.grey.shade400
                : MyColor.greenDark,
            borderRadius: const BorderRadius.all(
              Radius.circular(3),
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
            'assets/images/svg/edit.svg',
            colorFilter: const ColorFilter.mode(
                MyColor.greenSuperLight, BlendMode.srcIn),
            width: 30,
            height: 30,
          )),
    );
  }
}

class DeleteCancelButton extends StatelessWidget {
  final Function() onTap;
  const DeleteCancelButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: ColorUtils.moreLight(MyColor.red),
          borderRadius: const BorderRadius.all(
            Radius.circular(3),
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
        child: const Icon(Icons.clear_rounded,
            color: MyColor.greenSuperLight, size: 30),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final Function() onTap;
  final BoardPermission permission;
  const DeleteButton(
      {super.key, required this.onTap, required this.permission});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: MyColor.red,
            borderRadius: const BorderRadius.all(
              Radius.circular(3),
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
          child: Align(
            child: permission == BoardPermission.owner
                ? SvgPicture.asset(
                    'assets/images/svg/dustbox.svg',
                    colorFilter: const ColorFilter.mode(
                        MyColor.greenSuperLight, BlendMode.srcIn),
                    width: 30,
                    height: 30,
                  )
                : SvgPicture.asset(
                    'assets/images/svg/unlink.svg',
                    colorFilter: const ColorFilter.mode(
                        MyColor.greenSuperLight, BlendMode.srcIn),
                    width: 30,
                    height: 30,
                  ),
          )),
    );
  }
}

class CardBasePainter extends CustomPainter {
  final double avatarRadius;
  final double height;
  final double positionXFromRight;
  final double bottomRRadius;

  CardBasePainter(
      {required this.avatarRadius,
      required this.height,
      required this.positionXFromRight,
      required this.bottomRRadius});

  @override
  void paint(Canvas canvas, Size size) {
    const paddingValue = 12.0;
    final strength = avatarRadius + paddingValue * 0.2;
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..style = PaintingStyle.fill;

    final Offset p0 = Offset(
        size.width - positionXFromRight - avatarRadius - paddingValue * 2, 0);
    final Offset p1 = Offset(p0.dx + strength, 0);
    final Offset p3 = Offset(size.width - positionXFromRight,
        -avatarRadius / 2 - paddingValue * 1.35);
    final Offset p2 = Offset(p3.dx - strength, p3.dy);
    final Offset p4 = Offset(p3.dx + strength, p3.dy);
    final Offset p6 = Offset(
        size.width - positionXFromRight + avatarRadius + paddingValue * 2, 0);
    final Offset p5 = Offset(p6.dx - strength, 0);
    final Offset p7 = Offset(size.width, 0);

    final Offset p8 = Offset(size.width, height);
    final Offset p9 = Offset(0, height);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(p0.dx, p0.dy)
      ..cubicTo(
        p1.dx,
        p1.dy,
        p2.dx,
        p2.dy,
        p3.dx,
        p3.dy,
      )
      ..cubicTo(
        p4.dx,
        p4.dy,
        p5.dx,
        p5.dy,
        p6.dx,
        p6.dy,
      )
      ..lineTo(p7.dx, p7.dy)
      ..lineTo(p7.dx, p8.dy - bottomRRadius)
      ..arcToPoint(Offset(p8.dx - bottomRRadius, p8.dy),
          radius: Radius.circular(bottomRRadius), clockwise: true)
      ..lineTo(p9.dx + bottomRRadius, p9.dy)
      ..arcToPoint(Offset(p9.dx, p9.dy - bottomRRadius),
          radius: Radius.circular(bottomRRadius), clockwise: true)
      ..close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LabelPainter extends CustomPainter {
  final Color? color;
  LabelPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.transparent
      ..style = PaintingStyle.fill;
    final shadowPaint = Paint()
      ..color =
          color != null ? Colors.black.withOpacity(0.6) : Colors.transparent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(60, 0)
      ..lineTo(0, 55)
      ..close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
