import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/utils/image_utils.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:uuid/uuid.dart';

class EditPage extends HookConsumerWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    /// interactive viewerのコントローラー
    final TransformationController transformController =
        useTransformationController();

    final board = ref.watch(boardModelStateProvider);
    final editPageState = ref.watch(editPageViewModelProvider);
    final isLoaded = useState(false);
    final isCalcComplete = useState(false);

    /// 初期のスケールと位置を計算
    void calcInitialTransform() {
      if (editPageState.boardModel == null) return;
      final board = editPageState.boardModel!;
      final scaleW = w / board.settings.width;
      final scaleH = (h - kToolbarHeight) / board.settings.height;
      final scale = scaleW < scaleH ? scaleW : scaleH;

      /// 横長の画面の場合
      if (scaleW > scaleH) {
        final addX = (w - board.settings.width * scale) / 2;
        final translateX = (board.settings.width - w) / 2 * scale + addX;
        final translateY = (board.settings.height - h) / 2 * scale;
        transformController.value = Matrix4.identity()
          ..translate(translateX, translateY, 0.0)
          ..scale(scale, scale, 1.0);

        /// 縦長の画面の場合
      } else {
        final addY = (h - board.settings.height * scale) / 2;
        final translateX = (board.settings.width - w) / 2 * scale;
        final translateY = (board.settings.height - h) / 2 * scale + addY;
        transformController.value = Matrix4.identity()
          ..translate(translateX, translateY, 0.0)
          ..scale(scale, scale, 1.0);
      }
      isCalcComplete.value = true;
    }

    void selectObject() {
      final object = ObjectModel(
          objectId: '3',
          type: ObjectType.text,
          positionX: 530,
          positionY: 750,
          angle: 0.2,
          scale: 10.2,
          text: 'HelloHollo',
          creatorId: '1',
          createdAt: DateTime.now(),
          bgColor: '0xFF000000');
      ref.read(editPageViewModelProvider.notifier).selectObject(object);
    }

    void initialize() async {
      await ref.read(editPageViewModelProvider.notifier).initializeLoad();

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   if (board == null) return;
      //   ref.read(editPageViewModelProvider.notifier).setBoardModel(board);
      // });
      // editPageState.boardModel
      while (!isCalcComplete.value) {
        await Future.delayed(const Duration(milliseconds: 100), () {
          if (editPageState.boardModel != null) {
            calcInitialTransform();
          }
        });
      }

      /// interactive viewerのcontrollerの監視とscaleの更新
      transformController.addListener(() {
        final matrix = transformController.value;
        final scale = matrix.getMaxScaleOnAxis();
        ref.read(editPageViewModelProvider.notifier).updateViewScale(scale);
      });

      if (isCalcComplete.value) {
        isLoaded.value = true;
      }
    }

    useEffect(() {
      initialize();
      return null;
    }, []);

    useEffect(() {
      if (board == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(editPageViewModelProvider.notifier).setBoardModel(board);
      });
      return null;
    }, [board]);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Page'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: SafeArea(
          child: !isLoaded.value
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  color: Colors.grey,
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      InteractiveViewer(
                          transformationController: transformController,
                          boundaryMargin: const EdgeInsets.all(double.infinity),
                          minScale: 0.1,
                          maxScale: 10.0,
                          child: OverflowBox(
                            minWidth: 0.0,
                            maxWidth: double.infinity,
                            minHeight: 0.0,
                            maxHeight: double.infinity,
                            alignment: Alignment.center,
                            child: BoardWidget(
                                board: editPageState.boardModel!,
                                selectedObject: editPageState.selectedObject),
                          )),
                      Align(
                        alignment: const Alignment(0.85, -0.95),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // selectObject();
                              },
                              child: const Text('object'),
                            ),
                          ],
                        ),
                      ),
                      const CustomFloatingButton(),
                      editPageState.selectedObject != null
                          ? Align(
                              alignment: const Alignment(0.0, 0.9),
                              child: EditToolBar(width: w * 0.9))
                          : const SizedBox.shrink(),
                      Align(
                          alignment: const Alignment(-0.93, 1.0),
                          child: Text(
                              editPageState.boardModel!.boardId.toString())),
                      Align(
                          alignment: const Alignment(-0.93, 0.92),
                          child: Text(
                              'objects : ${editPageState.boardModel!.objects.length}')),
                    ],
                  ),
                ),
        ));
  }
}

class EditToolBar extends HookConsumerWidget {
  final double width;
  final double height = 120;
  const EditToolBar({super.key, required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editPageState = ref.watch(editPageViewModelProvider);
    final scale = useState(1.0);
    final angle = useState(0.0);

    void moveSelectedObject(Offset offset) {
      ref.read(editPageViewModelProvider.notifier).moveSelectedObject(offset);
    }

    void scaleSelectedObject(double delta) {
      scale.value += delta;
      ref
          .read(editPageViewModelProvider.notifier)
          .scaleSelectedObject(scale.value);
    }

    void rotateSelectedObject(double delta) {
      angle.value += delta;
      ref
          .read(editPageViewModelProvider.notifier)
          .rotateSelectedObject(angle.value);
    }

    final double joyStickStrength = 7.0 / editPageState.viewScale;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                ref.read(editPageViewModelProvider.notifier).selectObject(null);
              },
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                ref
                    .read(editPageViewModelProvider.notifier)
                    .addSelectedObject();
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    scaleSelectedObject(-details.delta.dy * 0.001);
                  },
                  child: Container(
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                    ),
                    child: const Icon(Icons.zoom_out_map),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    rotateSelectedObject(details.delta.dy * 0.01);
                  },
                  child: Container(
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                    child: const Icon(Icons.refresh),
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                height: 150,
                child: JoystickArea(
                  base: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  stick: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.open_with),
                  ),
                  period: const Duration(milliseconds: 5),
                  listener: (details) {
                    moveSelectedObject(Offset(details.x * joyStickStrength,
                        details.y * joyStickStrength));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BoardWidget extends HookWidget {
  final BoardModel board;
  final ObjectModel? selectedObject;
  const BoardWidget({super.key, required this.board, this.selectedObject});

  @override
  Widget build(BuildContext context) {
    final AnimationController animationController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    final animation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    return Container(
        width: board.settings.width,
        height: board.settings.height,
        color: Color(int.parse(board.settings.bgColor)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: BoardCanvasPainter(
                  canvasColor: Color(int.parse(board.settings.bgColor)),
                  objects: board.objects),
              size: Size(board.settings.width, board.settings.height),
            ),
            ...board.objects
                .map((object) => ObjectWidget(object: object, opacity: 1.0)),
            if (selectedObject != null)
              AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return ObjectWidget(
                        object: selectedObject!, opacity: animation.value);
                  })
            else
              const SizedBox.shrink(),
          ],
        ));
  }
}

class ObjectWidget extends StatelessWidget {
  final ObjectModel object;
  final double opacity;
  const ObjectWidget({super.key, required this.object, required this.opacity});

  Widget objectCheck() {
    if (object.type == ObjectType.networkImage) {
      return _networkImageWidget();
    } else if (object.type == ObjectType.localImage) {
      return _localImageWidget();
    } else if (object.type == ObjectType.text) {
      return _textWidget();
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = objectCheck();
    return Positioned(
      top: object.positionY,
      left: object.positionX,
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scale: object.scale,
        child: Transform.rotate(
          alignment: Alignment.center,
          angle: object.angle, // angle: object.angle,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _networkImageWidget() {
    const nullImage = 'assets/images/title.png';
    if (object.imageUrl == null) {
      return Image.asset(nullImage);
    }
    return CachedNetworkImage(
      imageUrl: object.imageUrl!,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _localImageWidget() {
    const nullImage = 'assets/images/title.png';
    if (object.imageUrl == null) {
      return Image.asset(nullImage);
    }
    return Image.file(File(object.imageUrl!));
  }

  Widget _textWidget() {
    final text = object.text ?? '???';
    return Text(text);
  }
}

class BoardCanvasPainter extends CustomPainter {
  final Color canvasColor;
  final List<ObjectModel> objects;

  BoardCanvasPainter({
    required this.canvasColor,
    required this.objects,
  });

  @override
  void paint(Canvas canvas, Size size) async {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomFloatingButton extends HookConsumerWidget {
  const CustomFloatingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editPageState = ref.watch(editPageViewModelProvider);

    Offset initialPosition() {
      if (editPageState.boardModel == null) return const Offset(0, 0);
      final boardSettings = editPageState.boardModel!.settings;
      final initialPositionX = boardSettings.width / 2;
      final initialPositionY = boardSettings.height / 2;
      return Offset(initialPositionX, initialPositionY);
    }

    final isShowMenu = useState(false);
    return isShowMenu.value
        ? Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: () {
                  isShowMenu.value = false;
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                    // width: 50,
                    // height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            //
                          },
                          icon: const Icon(Icons.text_format),
                        ),
                        IconButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              maxWidth: 1000,
                              maxHeight: 1000,
                              imageQuality: 85,
                            );
                            if (image == null) {
                              isShowMenu.value = false;
                              return;
                            }

                            /// centerに表示するために画像サイズを取得
                            final imageSize =
                                await ImageUtils().getImageSize(image) ??
                                    const Size(0, 0);
                            ref
                                .read(editPageViewModelProvider.notifier)
                                .selectObject(ObjectModel(
                                    objectId: const Uuid().v4(),
                                    type: ObjectType.localImage,
                                    positionX: initialPosition().dx -
                                        imageSize.width / 2,
                                    positionY: initialPosition().dy -
                                        imageSize.height / 2,
                                    angle: 0.0,
                                    scale: 1.0,
                                    imageUrl: image.path,
                                    creatorId: ref.read(userStateProvider)!.id,
                                    createdAt: DateTime.now(),
                                    bgColor: '0xFF000000'));
                            isShowMenu.value = false;
                          },
                          icon: const Icon(Icons.image),
                        ),
                      ],
                    )),
              ),
            ],
          )
        : Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                isShowMenu.value = true;
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          );
  }
}
