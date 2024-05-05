import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/utils/color_utils.dart';
import 'package:membo/utils/image_utils.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/widgets/error_dialog.dart';
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
    final isLoading = useState(false);

    void setInitialTransform() {
      final state = ref.read(editPageViewModelProvider);
      transformController.value = Matrix4.identity()
        ..translate(state.viewTranslateX, state.viewTranslateY, 0.0)
        ..scale(state.viewScale, state.viewScale, 1.0);
    }

    void initialize() async {
      try {
        await ref.read(editPageViewModelProvider.notifier).initializeLoad(w, h);
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, e.toString(),
              secondaryMessage: 'Please check your network connection.',
              onTap: () => context.go('/'));
        }
        return;
      }

      /// interactive viewerのcontrollerの監視とscaleの更新
      transformController.addListener(() {
        final matrix = transformController.value;
        final scale = matrix.getMaxScaleOnAxis();
        ref.read(editPageViewModelProvider.notifier).updateViewScale(scale);
      });

      setInitialTransform();

      isLoading.value = false;
    }

    useEffect(() {
      isLoading.value = true;
      initialize();
      return null;
    }, []);

    /// BoardModelが更新されたら再描画
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
          child: isLoading.value
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
                                setInitialTransform();
                              },
                              child: const Text('object'),
                            ),
                          ],
                        ),
                      ),
                      const CustomFloatingButton(),
                      const TextInputModal(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: EditToolBar(width: w),
                      ),
                      Align(
                          alignment: const Alignment(-0.93, 0.85),
                          child: Text(editPageState.viewScale.toString())),
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

    return editPageState.selectedObject == null
        ? const SizedBox.shrink()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      ref
                          .read(editPageViewModelProvider.notifier)
                          .selectObject(null, null);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      // ref.read(supabaseStorageProvider).uploadImage(
                      //     editPageState.selectedImageFile!, 'test');
                      ref
                          .read(editPageViewModelProvider.notifier)
                          .insertSelectedObject();
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
                          moveSelectedObject(Offset(
                              details.x * joyStickStrength,
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
    if (object.imageUrl == null) {
      return _errorImageWidget();
    }
    return CachedNetworkImage(
        imageUrl: object.imageUrl!,
        width: object.imageWidth != null
            ? object.imageWidth! * object.scale
            : null,
        height: object.imageHeight != null
            ? object.imageHeight! * object.scale
            : null,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        placeholder: (context, url) => const ColoredBox(color: Colors.grey),
        errorWidget: (context, url, error) => _errorImageWidget());
  }

  Widget _localImageWidget() {
    if (object.imageUrl == null) {
      return _errorImageWidget();
    }
    return Image.file(
      width:
          object.imageWidth != null ? object.imageWidth! * object.scale : null,
      height: object.imageHeight != null
          ? object.imageHeight! * object.scale
          : null,
      File(object.imageUrl!),
      errorBuilder: (context, error, stackTrace) {
        return _errorImageWidget();
      },
    );
  }

  Widget _errorImageWidget() {
    final double hue =
        object.imageWidth != null ? (object.imageWidth! % 360) : 0;
    final color = HSVColor.fromAHSV(1.0, hue, 0.3, 0.7).toColor();
    final bgColor = ColorUtils.moreDark(color);
    return Container(
      width:
          object.imageWidth != null ? object.imageWidth! * object.scale : null,
      height: object.imageHeight != null
          ? object.imageHeight! * object.scale
          : null,
      color: bgColor,
      child: Center(
          child: Icon(
        Icons.error,
        size: object.imageWidth != null
            ? object.imageWidth! * object.scale * 0.7
            : 100,
        color: color,
      )),
    );
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
    return editPageState.showInputMenu
        ? Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(editPageViewModelProvider.notifier).hideInputMenu();
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
                            ref
                                .read(editPageViewModelProvider.notifier)
                                .showTextInput();
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
                                .selectObject(
                                    ObjectModel(
                                        objectId: const Uuid().v4(),
                                        type: ObjectType.localImage,
                                        positionX: initialPosition().dx -
                                            imageSize.width / 2,
                                        positionY: initialPosition().dy -
                                            imageSize.height / 2,
                                        angle: 0.0,
                                        scale: 1.0,
                                        imageUrl: image.path,
                                        imageWidth: imageSize.width,
                                        imageHeight: imageSize.height,
                                        creatorId:
                                            ref.read(userStateProvider)!.id,
                                        createdAt: DateTime.now(),
                                        bgColor: '0xFF000000'),
                                    image);
                            ref
                                .read(editPageViewModelProvider.notifier)
                                .hideInputMenu();
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
                ref.read(editPageViewModelProvider.notifier).showInputMenu();
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          );
  }
}

class TextInputModal extends HookConsumerWidget {
  const TextInputModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController textController = useTextEditingController();
    final editPageState = ref.watch(editPageViewModelProvider);

    Offset initialPosition() {
      if (editPageState.boardModel == null) return const Offset(0, 0);
      final boardSettings = editPageState.boardModel!.settings;
      final initialPositionX = boardSettings.width / 2;
      final initialPositionY = boardSettings.height / 2;
      return Offset(initialPositionX, initialPositionY);
    }

    return editPageState.showTextInput
        ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: () {
                    textController.clear();
                    ref
                        .read(editPageViewModelProvider.notifier)
                        .hideTextInput();
                  },
                  child: const ColoredBox(
                    color: Colors.transparent,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: textController,
                              decoration: const InputDecoration(
                                hintText: 'Input Text',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (textController.text.isEmpty) return;
                                ref
                                    .read(editPageViewModelProvider.notifier)
                                    .selectObject(
                                        ObjectModel(
                                            objectId: const Uuid().v4(),
                                            type: ObjectType.text,
                                            positionX: initialPosition().dx,
                                            positionY: initialPosition().dy,
                                            angle: 0.0,
                                            scale: 10.0,
                                            text: textController.text,
                                            creatorId:
                                                ref.read(userStateProvider)!.id,
                                            createdAt: DateTime.now(),
                                            bgColor: '0xFF000000'),
                                        null);
                                ref
                                    .read(editPageViewModelProvider.notifier)
                                    .hideTextInput();
                                ref
                                    .read(editPageViewModelProvider.notifier)
                                    .hideInputMenu();
                                textController.clear();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
