import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/state/stream_board_state.dart';
import 'package:membo/utils/color_utils.dart';
import 'package:membo/utils/image_utils.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:membo/widgets/board_widget.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:membo/string.dart';

class EditPage extends HookConsumerWidget {
  final String boardId;
  const EditPage({super.key, required this.boardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamBoard = ref.watch(streamBoardModelProvider);

    /// Drawerで使用
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>(), []);

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    /// interactive viewerのコントローラー
    final TransformationController transformController =
        useTransformationController();

    final editPageState = ref.watch(editPageViewModelProvider);
    final objectList = editPageState.boardModel?.objects ?? [];

    final isLoading = useState(true);
    final isMatrixSet = useState(false);
    final timer = useState<Timer?>(null);

    void initialize() async {
      await ref
          .read(editPageViewModelProvider.notifier)
          .initialize(boardId, w, h)
          .catchError((e) {
        if (context.mounted) {
          ErrorDialog.show(
            context,
            e.toString(),
            secondaryMessage: 'Please check your network connection.',
            onTap: () => context.go('/'),
          );
        }
      });
    }

    useEffect(() {
      initialize();
      return null;
    }, []);

    useEffect(() {
      if (streamBoard == null) return;
      ref.read(editPageViewModelProvider.notifier).setBoardModel(streamBoard);
      return null;
    }, [streamBoard]);

    /// マトリックスの更新（基本的には初期化時）
    useEffect(() {
      if (editPageState.transformationMatrix == null) return;
      transformController.value = editPageState.transformationMatrix!;
      isMatrixSet.value = true;
      return null;
    }, [editPageState.transformationMatrix]);

    /// 準備ができたらloadingをfalseにする
    void standbyCheck() {
      if (isMatrixSet.value == false) return;

      /// 故意的に遅延させている
      Future.delayed(const Duration(milliseconds: 500), () {
        isLoading.value = false;
      });
    }

    useEffect(() {
      timer.value = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!isLoading.value) {
          timer.cancel();
        }
        standbyCheck();
      });
      return () {
        timer.value?.cancel();
      };
    }, []);

    return Scaffold(
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 36),
            onPressed: () => context.go('/edit-list'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: MyColor.green,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(width: 3, color: MyColor.greenText),
                ),
                child: Text(
                  editPageState.boardModel?.isPublic == true
                      ? 'Public'
                      : 'Private',
                  style: lightTextTheme.bodyLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(editPageViewModelProvider.notifier)
                      .clearSelectedObject();
                  context.go('/board-settings', extra: boardId);
                },
                child: const Icon(Icons.settings),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElevatedButton(
                onPressed: () {
                  scaffoldKey.currentState?.openEndDrawer();
                  // Scaffold.of(context).openDrawer();
                },
                child: const Icon(Icons.format_list_bulleted),
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          width: (w * 0.85).clamp(200, 500),
          backgroundColor: MyColor.green,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 200
                        : 130,
                decoration: const BoxDecoration(
                  color: MyColor.greenDark,
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 0),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Object List',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(12),
                        icon: const Icon(Icons.arrow_forward,
                            size: 32, color: Colors.white),
                        onPressed: () {
                          scaffoldKey.currentState?.closeEndDrawer();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const SizedBox(height: 6),
                    ...objectList.map((object) {
                      return DrawerCard(
                        object: object,
                        onTap: () {
                          //
                        },
                      );
                    }),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: isLoading.value || streamBoard == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Container(
                    color: MyColor.green,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  InteractiveViewer(
                      transformationController: transformController,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      minScale: 0.1,
                      maxScale: 20.0,
                      child: OverflowBox(
                          minWidth: 0.0,
                          maxWidth: double.infinity,
                          minHeight: 0.0,
                          maxHeight: double.infinity,
                          alignment: Alignment.center,
                          child: Center(
                            child: BoardWidget(
                                board: streamBoard,
                                selectedObject: editPageState.selectedObject),
                          ))),
                  editPageState.selectedObject == null
                      ? const CustomFloatingButton()
                      : const SizedBox.shrink(),
                  const TextInputModal(),
                  Align(
                    alignment: const Alignment(0, 0.9),
                    child: EditToolBar(width: w),
                  ),
                ],
              ));
  }
}

class DrawerCard extends HookConsumerWidget {
  final Function onTap;
  final ObjectModel object;
  const DrawerCard({super.key, required this.onTap, required this.object});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTaped = useState(false);
    final isDeleteTaped = useState(false);
    final creatorName = useState('');

    void handleCardTap() async {
      isTaped.value = !isTaped.value;
      creatorName.value = await ref
          .read(editPageViewModelProvider.notifier)
          .getObjectCreatorName(object.creatorId);
    }

    void handleDeleteIconTap() async {
      isTaped.value = true;
      isDeleteTaped.value = true;
      creatorName.value = await ref
          .read(editPageViewModelProvider.notifier)
          .getObjectCreatorName(object.creatorId);
    }

    void handleDeleteCancel() {
      isTaped.value = false;
      isDeleteTaped.value = false;
    }

    void handleDelete() async {
      try {
        await ref
            .read(editPageViewModelProvider.notifier)
            .deleteObject(object.objectId);
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, e.toString());
        }
      }
      isTaped.value = false;
      isDeleteTaped.value = false;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDeleteTaped.value ? MyColor.pink : MyColor.greenLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(1, 1.5),
            blurRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(children: [
          object.type == ObjectType.text
              ? const Icon(Icons.text_fields)
              : const Icon(Icons.image),
          Expanded(
            child: GestureDetector(
              onTap: () {
                handleCardTap();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          // color: MyColor.greenSuperLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: MyColor.greenDark),
                        ),
                        child: object.type == ObjectType.text
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(object.text ?? 'Text',
                                    style: lightTextTheme.bodyMedium,
                                    overflow: isTaped.value
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                    imageUrl: object.imageUrl!,
                                    width: double.infinity,
                                    height: isTaped.value ? 200 : 100,
                                    alignment: Alignment.centerLeft,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: isTaped.value
                                                  ? BoxFit.contain
                                                  : BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) =>
                                        const ColoredBox(color: Colors.white),
                                    errorWidget: (context, url, error) =>
                                        const ColoredBox(color: Colors.white)),
                              ),
                      ),
                    ),
                    isTaped.value
                        ? Column(
                            children: [
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: MyColor.greenDark),
                                ),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 6.0),
                                      child: Icon(Icons.person),
                                    ),
                                    Expanded(
                                      child: Text(
                                        creatorName.value,
                                        style: lightTextTheme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: MyColor.greenDark),
                                ),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 6.0),
                                      child: Icon(
                                        Icons.calendar_month,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        object.createdAt
                                            .toIso8601String()
                                            .toYMDString(),
                                        style: lightTextTheme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    isDeleteTaped.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade300,
                                      ),
                                      onPressed: () {
                                        handleDelete();
                                      },
                                      child: Text('Delete',
                                          style: lightTextTheme.bodyMedium!
                                              .copyWith(color: Colors.white))),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            MyColor.greenSuperLight,
                                      ),
                                      onPressed: () {
                                        handleDeleteCancel();
                                      },
                                      child: Text('Cancel',
                                          style: lightTextTheme.bodyMedium)),
                                ]),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.delete)),
            onTap: () {
              handleDeleteIconTap();
            },
          )
        ]),
      ),
    );
  }
}

class EditToolBar extends HookConsumerWidget {
  final double width;
  final double height = 150;
  const EditToolBar({super.key, required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editPageState = ref.watch(editPageViewModelProvider);
    final scale = useState(1.0);
    final angle = useState(0.0);

    void clearState() {
      scale.value = 1.0;
      angle.value = 0.0;
    }

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

    const double joyStickStrength = 7.0;

    return editPageState.selectedObject == null
        ? const SizedBox.shrink()
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onPanUpdate: (details) {
                          final scaleDelta = -details.delta.dy * 0.003;
                          scaleSelectedObject(scaleDelta);
                        },
                        child: Container(
                          width: width / 4 > 100 ? 100 : width / 4,
                          height: height,
                          decoration: BoxDecoration(
                            color: MyColor.greenSuperLight,
                            borderRadius: BorderRadius.circular(99),
                            border:
                                Border.all(width: 6, color: MyColor.greenDark),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.zoom_out_map,
                            size: 36,
                            color: MyColor.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onPanUpdate: (details) {
                          rotateSelectedObject(details.delta.dy * 0.01);
                        },
                        child: Container(
                          width: width / 4 > 100 ? 100 : width / 4,
                          height: height,
                          decoration: BoxDecoration(
                            color: MyColor.greenSuperLight,
                            borderRadius: BorderRadius.circular(99),
                            border:
                                Border.all(width: 6, color: MyColor.greenDark),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.refresh,
                            size: 36,
                            color: MyColor.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: height,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(editPageViewModelProvider.notifier)
                                    .selectObject(null, null);
                                clearState();
                              },
                              child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: MyColor.greenSuperLight,
                                    borderRadius: BorderRadius.circular(99),
                                    border: Border.all(
                                        width: 5, color: MyColor.greenDark),
                                  ),
                                  child: const Icon(Icons.clear,
                                      color: MyColor.blue)),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(editPageViewModelProvider.notifier)
                                    .insertSelectedObject();
                                clearState();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: MyColor.greenSuperLight,
                                  borderRadius: BorderRadius.circular(99),
                                  border: Border.all(
                                      width: 5, color: MyColor.greenDark),
                                ),
                                child: const Icon(Icons.done),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: height,
                          height: height,
                          child: Joystick(
                            base: Container(
                              decoration: BoxDecoration(
                                color: MyColor.greenSuperLight,
                                shape: BoxShape.circle,
                                // borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                    width: 6, color: MyColor.greenDark),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            stick: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: MyColor.pink,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.games,
                                color: MyColor.blue,
                                size: 36,
                              ),
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

    final isShowMenu = useState(false);

    Offset initialPosition() {
      if (editPageState.boardModel == null) return const Offset(0, 0);
      final initialPositionX = editPageState.boardModel!.width / 2;
      final initialPositionY = editPageState.boardModel!.height / 2;
      return Offset(initialPositionX, initialPositionY);
    }

    void handleTextSelect() {
      ref.read(editPageViewModelProvider.notifier).showTextInput();
    }

    Future<void> handleImageSelect() async {
      const imageMaxSize = 1000.0;
      final picker = ImagePicker();
      try {
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: imageMaxSize,
          maxHeight: imageMaxSize,
          imageQuality: 85,
        );

        if (image == null) {
          isShowMenu.value = false;
          return;
        }

        /// 画像のデータサイズチェック
        final uint8List = await image.readAsBytes();
        final imageSizeInBytes = uint8List.lengthInBytes;

        double imageSizeInMB = imageSizeInBytes / (1024 * 1024);

        // print('Image size: $imageSizeInMB MB');

        if (imageSizeInMB > 1.0) {
          if (context.mounted) {
            ErrorDialog.show(context, 'Image size is too large.');
          }
          return;
        }

        /// 画像サイズを取得
        final imageSize =
            await ImageUtils().getImageSize(image) ?? const Size(0, 0);

        var resizeRate = 1.0;

        /// 画像サイズが大きい場合はリサイズ
        if (imageSize.width > imageMaxSize || imageSize.height > imageMaxSize) {
          if (imageSize.width > imageSize.height) {
            resizeRate = imageMaxSize / imageSize.width;
          } else {
            resizeRate = imageMaxSize / imageSize.height;
          }
        }

        final selectedObject = ObjectModel(
            objectId: const Uuid().v4(),
            type: ObjectType.localImage,
            positionX: initialPosition().dx,
            positionY: initialPosition().dy,
            angle: 0.0,
            scale: 1.0,
            imageUrl: image.path,
            imageWidth: imageSize.width * resizeRate,
            imageHeight: imageSize.height * resizeRate,
            creatorId: ref.read(userStateProvider)!.id,
            createdAt: DateTime.now(),
            bgColor: '0xFF000000');
        ref
            .read(editPageViewModelProvider.notifier)
            .selectObject(selectedObject, image);
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, e.toString());
        }
        return;
      }
    }

    return (editPageState.showInputMenu)
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
                bottom: 40,
                right: 30,
                child: !editPageState.showTextInput
                    ? CustomButton(
                        width: 60,
                        height: 140,
                        color: ColorUtils.moreDark(
                          MyColor.pink,
                        ),
                        onTap: () {
                          // none
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                handleTextSelect();
                              },
                              icon: const Icon(
                                Icons.text_format,
                                size: 42,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await handleImageSelect();
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
            bottom: 40,
            right: 30,
            child: CustomButton(
              width: 60,
              height: 60,
              elevation: 5.0,
              color: MyColor.pink,
              child: const Icon(
                Icons.add,
                size: 32,
              ),
              onTap: () {
                animationController.forward();
                ref.read(editPageViewModelProvider.notifier).showInputMenu();
              },
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
    final focusNode = useFocusNode();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    useEffect(() {
      focusNode.requestFocus();
      return;
    }, [editPageState.showTextInput]);

    Offset initialTextPosition() {
      if (editPageState.boardModel == null) return const Offset(0, 0);
      final initialPositionX = editPageState.boardModel!.width / 2;
      final initialPositionY = editPageState.boardModel!.height / 2;
      return Offset(initialPositionX, initialPositionY);
    }

    void handleChangeTextColor(Color color) {
      selectedTextColor.value = color;
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
