import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/utils/image_utils.dart';
import 'package:membo/view_model/board_settings_view_model.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:membo/widgets/board_widget.dart';
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: MyColor.pink,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: SafeArea(
          child: isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  color: Colors.grey.shade700,
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
                              child: board == null
                                  ? const SizedBox.shrink()
                                  : Center(
                                      child: BoardWidget(
                                          board: board,
                                          selectedObject:
                                              editPageState.selectedObject),
                                    ))),
                      Align(
                        alignment: const Alignment(0.9, -0.95),
                        child: ElevatedButton(
                          onPressed: () {
                            if (board == null) return;
                            ref
                                .read(editPageViewModelProvider.notifier)
                                .clearSelectedObject();
                            context.push('/board-setting');
                          },
                          child: const Icon(Icons.settings),
                        ),
                      ),
                      const CustomFloatingButton(),
                      const TextInputModal(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: EditToolBar(width: w),
                      ),
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
                          final scaleDelta = -details.delta.dy * 0.003;
                          scaleSelectedObject(scaleDelta);
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

class CustomFloatingButton extends HookConsumerWidget {
  const CustomFloatingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );
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
                  animationController.reset();
                  ref.read(editPageViewModelProvider.notifier).hideInputMenu();
                },
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.4 * animationController.value),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: !editPageState.showTextInput
                    ? Container(
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
                              icon: const Icon(
                                Icons.text_format,
                                size: 42,
                              ),
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
                                            positionX: initialPosition().dx,
                                            positionY: initialPosition().dy,
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
                              icon: const Icon(
                                Icons.image,
                                size: 42,
                              ),
                            ),
                          ],
                        ))
                    : const SizedBox.shrink(),
              ),
            ],
          )
        : Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                animationController.forward();
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
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final TextEditingController textController = useTextEditingController();
    final editPageState = ref.watch(editPageViewModelProvider);
    final selectedTextColor = useState<Color>(Colors.black);
    final selectedBgColor = useState<Color>(Colors.black);
    final focusNode = useFocusNode();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    useEffect(() {
      focusNode.requestFocus();
      return;
    }, [editPageState.showTextInput]);

    Offset initialTextPosition() {
      if (editPageState.boardModel == null) return const Offset(0, 0);
      final boardSettings = editPageState.boardModel!.settings;
      final initialPositionX = boardSettings.width / 2;
      final initialPositionY = boardSettings.height / 2;
      return Offset(initialPositionX, initialPositionY);
    }

    void handleChangeTextColor(Color color) {
      selectedTextColor.value = color;
    }

    void handleChangeBgColor(Color color) {
      selectedBgColor.value = color;
    }

    return editPageState.showTextInput
        ? SizedBox(
            width: w,
            height: h,
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
                Positioned(
                  bottom: keyboardHeight,
                  child: SizedBox(
                    width: w,
                    height: h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColor.pink,
                                ),
                                onPressed: () {
                                  if (textController.text.isEmpty) return;
                                  ref
                                      .read(editPageViewModelProvider.notifier)
                                      .selectObject(
                                          ObjectModel(
                                              objectId: const Uuid().v4(),
                                              type: ObjectType.text,
                                              positionX:
                                                  initialTextPosition().dx,
                                              positionY:
                                                  initialTextPosition().dy,
                                              angle: 0.0,
                                              scale: 1.0,
                                              text: textController.text,
                                              creatorId: ref
                                                  .read(userStateProvider)!
                                                  .id,
                                              createdAt: DateTime.now(),
                                              bgColor:
                                                  '0xff${selectedTextColor.value.value.toRadixString(16)}'),
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
                            ),
                          ],
                        ),
                        TextField(
                            maxLines: 1,
                            cursorColor: MyColor.pink,
                            style: TextStyle(
                                color: selectedTextColor.value, fontSize: 24),
                            textAlign: TextAlign.center,
                            focusNode: focusNode,
                            controller: textController,
                            decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ))),
                        _colorPicker(
                            selectedTextColor.value, handleChangeTextColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _colorPicker(Color selectedColor, Function(Color) onColorChanged) {
    return BlockPicker(
      pickerColor: selectedColor, //default color
      onColorChanged: (Color color) {
        onColorChanged(color);
      },
      layoutBuilder: _customLayoutBuilder, // customize layout
      itemBuilder: _customItemBuilder, // customize builder
    );
  }

  Widget _customLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [for (Color color in colors) child(color)],
        ),
      ),
    );
  }

  Widget _customItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: const Offset(1, 2),
              blurRadius: 2)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(50),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 210),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(Icons.done,
                color: useWhiteForeground(color) ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
