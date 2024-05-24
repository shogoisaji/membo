import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/exceptions/app_exception.dart';
import 'package:membo/gen/assets.gen.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/state/stream_board_state.dart';
import 'package:membo/utils/color_utils.dart';
import 'package:membo/utils/custom_indicator.dart';
import 'package:membo/utils/image_utils.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:membo/widgets/board_widget.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:membo/widgets/two_way_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:membo/string.dart';

class EditPage extends HookConsumerWidget {
  final String boardId;
  const EditPage({super.key, required this.boardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const scaleMin = 0.07;
    const scaleMax = 0.8;

    const bgColor = MyColor.green;

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
      isLoading.value = true;
      try {
        await ref
            .read(editPageViewModelProvider.notifier)
            .initialize(boardId, w, h)
            .timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (dialogContext) => TwoWayDialog(
                title: '通信状況を確認してください',
                leftButtonText: 'サインアウト',
                rightButtonText: 'リロード',
                onLeftButtonPressed: () {
                  ref.read(supabaseAuthRepositoryProvider).signOut();
                  context.go('/sign-in');
                },
                onRightButtonPressed: () {
                  initialize();
                },
              ),
            );
          },
        );
      } catch (e) {
        if (context.mounted) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (dialogContext) => TwoWayDialog(
              title: e.toString(),
              leftButtonText: 'サインアウト',
              rightButtonText: 'リロード',
              onLeftButtonPressed: () {
                ref.read(supabaseAuthRepositoryProvider).signOut();
                context.go('/sign-in');
              },
              onRightButtonPressed: () {
                initialize();
              },
            ),
          );
        }
      }
    }

    useEffect(() {
      initialize();

      /// 画面回転を可能にする
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      return () => SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
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

      isLoading.value = false;
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
        backgroundColor: bgColor,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 36),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.go('/');
            },
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SvgPicture.asset(
                  Assets.images.svg.edit,
                  colorFilter: const ColorFilter.mode(
                      MyColor.greenText, BlendMode.srcIn),
                  width: 30,
                  height: 30,
                )),
            editPageState.isOwner
                ? Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(width: 3, color: MyColor.greenText),
                      ),
                      child: Text(
                        editPageState.boardModel?.isPublic == true
                            ? '公開'
                            : '非公開',
                        style: lightTextTheme.bodyLarge,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref
                      .read(editPageViewModelProvider.notifier)
                      .clearSelectedObject();
                  context.go('/board-settings', extra: boardId);
                },
                child: const Icon(Icons.settings, size: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  scaffoldKey.currentState?.openEndDrawer();
                  // Scaffold.of(context).openDrawer();
                },
                child: const Icon(Icons.format_list_bulleted, size: 32),
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
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      padding: const EdgeInsets.all(12),
                      icon: const Icon(Icons.arrow_forward,
                          size: 32, color: Colors.white),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        scaffoldKey.currentState?.closeEndDrawer();
                      },
                    ),
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
                        currentUserId: editPageState.userId ?? '',
                        // currentUserId: ref.read(userStateProvider)!.id,
                        isOwner: editPageState.isOwner,
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
            ? const Center(child: CustomIndicator())
            : Stack(
                children: [
                  Container(
                    color: bgColor,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  InteractiveViewer(
                      transformationController: transformController,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      minScale: scaleMin,
                      maxScale: scaleMax,
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
                      ? CustomFloatingButton(userId: editPageState.userId ?? '')
                      : const SizedBox.shrink(),
                  TextInputModal(userId: editPageState.userId ?? ''),
                  Align(
                    alignment: const Alignment(0, 0.9),
                    child: EditToolBar(width: w, isLoading: isLoading),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: const Alignment(-0.95, -0.99),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 12),
                        decoration: BoxDecoration(
                          color: MyColor.greenLight,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.image,
                                size: 32, color: MyColor.greenDark),
                            Text(
                                ' ${editPageState.currentImageCount}/${editPageState.boardModel!.maxImageCount}',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  color: MyColor.greenDark,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}

class DrawerCard extends HookConsumerWidget {
  final String currentUserId;
  final ObjectModel object;
  final bool isOwner;
  const DrawerCard(
      {super.key,
      required this.object,
      required this.currentUserId,
      required this.isOwner});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTaped = useState(false);
    final isDeleteTaped = useState(false);
    final creatorName = useState('');

    bool deleteCheck() {
      return object.creatorId == currentUserId || isOwner;
    }

    void handleCardTap() async {
      isTaped.value = !isTaped.value;
      creatorName.value = await ref
          .read(editPageViewModelProvider.notifier)
          .getObjectCreatorName(object.creatorId);
    }

    void handleTapDeleteIcon() async {
      if (!deleteCheck()) return;
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
                HapticFeedback.lightImpact();
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
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        backgroundColor: Colors.red.shade300,
                                      ),
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        handleDelete();
                                      },
                                      child: Text('削除',
                                          style: lightTextTheme.bodyMedium!
                                              .copyWith(color: Colors.white))),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        backgroundColor:
                                            MyColor.greenSuperLight,
                                      ),
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        handleDeleteCancel();
                                      },
                                      child: Text('キャンセル',
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
                child: Icon(
                  Icons.delete,
                  color: deleteCheck() ? MyColor.greenText : MyColor.green,
                )),
            onTap: () {
              if (!deleteCheck()) return;
              HapticFeedback.lightImpact();
              handleTapDeleteIcon();
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
  final ValueNotifier<bool> isLoading;
  const EditToolBar({super.key, required this.width, required this.isLoading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<double, String>> moveRateList = [
      {1.0: Assets.images.svg.turtle},
      {4.0: Assets.images.svg.elephant},
      {10.0: Assets.images.svg.rabbit},
    ];
    final editPageState = ref.watch(editPageViewModelProvider);
    final scale = useState(1.0);
    final angle = useState(0.0);
    final moveRate = useState(moveRateList[1].keys.first);

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

    void handleInsertObject(BuildContext context) async {
      if (isLoading.value) return; // 連打防止

      isLoading.value = true;
      try {
        await ref.read(editPageViewModelProvider.notifier).saveSelectedObject();
        clearState();
      } catch (e) {
        if (context.mounted) {
          if (e is AppException) {
            ErrorDialog.show(context, e.title);
            return;
          }
          ErrorDialog.show(context, e.toString());
        }
      } finally {
        isLoading.value = false;
      }
    }

    return editPageState.selectedObject == null
        ? const SizedBox.shrink()
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SafeArea(
                bottom: false,
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                boxShadow: const [
                                  BoxShadow(
                                    color: MyColor.greenDark,
                                    blurRadius: 1,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Align(
                                    child: SvgPicture.asset(
                                      Assets.images.svg.vertical,
                                      width: 40,
                                      height: 100,
                                      colorFilter: const ColorFilter.mode(
                                          MyColor.blue, BlendMode.srcIn),
                                    ),
                                  ),
                                  Align(
                                    child: SvgPicture.asset(
                                      Assets.images.svg.scale,
                                      width: 40,
                                      height: 40,
                                      colorFilter: const ColorFilter.mode(
                                          MyColor.blue, BlendMode.srcIn),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onPanUpdate: (details) {
                              rotateSelectedObject(details.delta.dy * 0.005);
                            },
                            child: Container(
                              width: width / 4 > 100 ? 100 : width / 4,
                              height: height,
                              decoration: BoxDecoration(
                                color: MyColor.greenSuperLight,
                                borderRadius: BorderRadius.circular(99),
                                boxShadow: const [
                                  BoxShadow(
                                    color: MyColor.greenDark,
                                    blurRadius: 1,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Align(
                                    child: SvgPicture.asset(
                                      Assets.images.svg.vertical,
                                      width: 40,
                                      height: 100,
                                      colorFilter: const ColorFilter.mode(
                                          MyColor.blue, BlendMode.srcIn),
                                    ),
                                  ),
                                  Align(
                                    child: SvgPicture.asset(
                                      Assets.images.svg.rotate,
                                      width: 40,
                                      height: 40,
                                      colorFilter: const ColorFilter.mode(
                                          MyColor.blue, BlendMode.srcIn),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height + 100,
                        width: height,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        ref
                                            .read(editPageViewModelProvider
                                                .notifier)
                                            .selectObject(null, null);
                                        clearState();
                                      },
                                      child: Container(
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: MyColor.lightRed,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                offset: const Offset(-1, -1),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          margin:
                                              const EdgeInsets.only(left: 2),
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          alignment: Alignment.topCenter,
                                          child: const Icon(Icons.clear_rounded,
                                              color: MyColor.greenSuperLight,
                                              size: 30)),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          handleInsertObject(context);
                                        },
                                        child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: MyColor.blue,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  offset: const Offset(1, -1),
                                                  blurRadius: 3,
                                                ),
                                              ],
                                            ),
                                            margin:
                                                const EdgeInsets.only(right: 2),
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            alignment: Alignment.topCenter,
                                            child: const Icon(
                                                Icons.done_rounded,
                                                color: MyColor.greenSuperLight,
                                                size: 30))),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(1, -2),
                                      blurRadius: 3,
                                      spreadRadius: 2,
                                    ),
                                    const BoxShadow(
                                      color: MyColor.greenDark,
                                      blurRadius: 1,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                  color: MyColor.greenDark,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(99),
                                    bottomRight: Radius.circular(99),
                                    topLeft: Radius.circular(36),
                                    topRight: Radius.circular(36),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: MyColor.greenSuperLight,
                                            borderRadius:
                                                BorderRadius.circular(99),
                                            // border: Border.all(
                                            //     width: 5, color: MyColor.greenDark),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ...moveRateList.map((rate) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    HapticFeedback
                                                        .lightImpact();
                                                    moveRate.value =
                                                        rate.keys.first;
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: rate.keys.first ==
                                                              moveRate.value
                                                          ? MyColor.pink
                                                          : MyColor
                                                              .greenSuperLight,
                                                      shape: BoxShape.circle,
                                                      // border: Border.all(
                                                      //     width: 2, color: MyColor.greenDark),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      rate.values.first,
                                                      width: 30,
                                                      height: 30,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                              MyColor.blue,
                                                              BlendMode.srcIn),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: height,
                                          height: height,
                                          child: Joystick(
                                            base: Container(
                                              decoration: const BoxDecoration(
                                                color: MyColor.greenSuperLight,
                                                shape: BoxShape.circle,
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
                                                    color: Colors.black
                                                        .withOpacity(0.3),
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
                                            period:
                                                const Duration(milliseconds: 5),
                                            listener: (details) {
                                              moveSelectedObject(Offset(
                                                  details.x * moveRate.value,
                                                  details.y * moveRate.value));
                                            },
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
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}

class CustomFloatingButton extends HookConsumerWidget {
  final String userId;
  const CustomFloatingButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );
    final editPageState = ref.watch(editPageViewModelProvider);

    final isShowMenu = useState(false);

    /// 基点を中央に設定したので不調となった
    /// オブジェクトの初期値を計算（基点が左上の場合）
    // Offset initialPosition() {
    // if (editPageState.boardModel == null) return const Offset(0, 0);
    // final initialPositionX = editPageState.boardModel!.width / 2;
    // final initialPositionY = editPageState.boardModel!.height / 2;
    // return Offset(initialPositionX, initialPositionY);
    // }

    void handleTextSelect() {
      ref.read(editPageViewModelProvider.notifier).showTextInput();
    }

    Future<void> handleImageSelect() async {
      const imageMaxSize = 1980.0;
      const pickImageMaxDataSize = 3.0; //  MB
      final picker = ImagePicker();
      try {
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: imageMaxSize,
          maxHeight: imageMaxSize,
          imageQuality: 100,
        );

        if (image == null) {
          isShowMenu.value = false;
          return;
        }

        /// 画像のデータサイズチェック
        final uint8List = await image.readAsBytes();
        final imageSizeInBytes = uint8List.lengthInBytes;

        double imageSizeInMB = imageSizeInBytes / (1024 * 1024);

        if (imageSizeInMB > pickImageMaxDataSize) {
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
            positionX: 0.0,
            positionY: 0.0,
            angle: 0.0,
            scale: 1.0,
            imageUrl: image.path,
            imageWidth: imageSize.width * resizeRate,
            imageHeight: imageSize.height * resizeRate,
            creatorId: userId,
            createdAt: DateTime.now(),
            bgColor: '0xFF000000');
        ref
            .read(editPageViewModelProvider.notifier)
            .selectObject(selectedObject, image);
      } on PlatformException catch (e) {
        if (context.mounted) {
          if (e.code == 'photo_access_denied') {
            showDialog(
                context: context,
                builder: (dialogContext) => TwoWayDialog(
                      title: '画像にアクセスできません',
                      leftButtonText: '設定画面',
                      rightButtonText: '戻る',
                      onLeftButtonPressed: () {
                        AppSettings.openAppSettings();
                      },
                      onRightButtonPressed: () {},
                    ));
          } else {
            ErrorDialog.show(
              context,
              '画像ギャラリーにアクセスできません',
            );
          }
        }
        return;
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(
            context,
            '画像ギャラリーにアクセスできません',
          );
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
                                HapticFeedback.lightImpact();
                                handleTextSelect();
                              },
                              icon: const Icon(
                                Icons.text_format,
                                size: 42,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                if (editPageState.currentImageCount >=
                                    editPageState.boardModel!.maxImageCount) {
                                  return;
                                }
                                await handleImageSelect();
                              },
                              icon: editPageState.currentImageCount >=
                                      editPageState.boardModel!.maxImageCount
                                  ? const Icon(
                                      Icons.image_not_supported_rounded,
                                      size: 42,
                                      color: MyColor.green)
                                  : const Icon(
                                      Icons.image,
                                      size: 42,
                                      color: MyColor.greenText,
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
                Icons.add_rounded,
                size: 40,
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
  final String userId;
  const TextInputModal({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final TextEditingController textController = useTextEditingController();
    final editPageState = ref.watch(editPageViewModelProvider);
    final selectedTextColor = useState<Color>(Colors.black);
    final focusNode = useFocusNode();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    useEffect(() {
      focusNode.requestFocus();
      return;
    }, [editPageState.showTextInput]);

    void handleChangeTextColor(Color color) {
      selectedTextColor.value = color;
    }

    void handleTapOk() {
      if (textController.text.isEmpty) return;
      HapticFeedback.lightImpact();
      ref.read(editPageViewModelProvider.notifier).selectObject(
          ObjectModel(
              objectId: const Uuid().v4(),
              type: ObjectType.text,
              positionX: 0.0,
              positionY: 0.0,
              angle: 0.0,
              scale: 1.0,
              text: textController.text,
              creatorId: userId,
              createdAt: DateTime.now(),
              bgColor:
                  '0xff${selectedTextColor.value.value.toRadixString(16)}'),
          null);
      ref.read(editPageViewModelProvider.notifier).hideTextInput();
      ref.read(editPageViewModelProvider.notifier).hideInputMenu();
      textController.clear();
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
                        isPortrait
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyColor.pink,
                                      ),
                                      onPressed: () {
                                        handleTapOk();
                                      },
                                      child: Text('OK',
                                          style: lightTextTheme.titleLarge),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: TextField(
                                  maxLines: null,
                                  scrollPadding: const EdgeInsets.all(0),
                                  cursorColor: MyColor.pink,
                                  style: lightTextTheme.bodyLarge!.copyWith(
                                      color: selectedTextColor.value,
                                      fontSize: 32),
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  focusNode: focusNode,
                                  controller: textController,
                                  decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ))),
                            ),
                            isPortrait
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyColor.pink,
                                      ),
                                      onPressed: () {
                                        handleTapOk();
                                      },
                                      child: Text('OK',
                                          style: lightTextTheme.titleLarge),
                                    ),
                                  ),
                          ],
                        ),
                        colorPicker(
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

  Widget colorPicker(Color selectedColor, Function(Color) onColorChanged) {
    return BlockPicker(
      pickerColor: selectedColor, //default color
      onColorChanged: (Color color) {
        onColorChanged(color);
      },
      layoutBuilder: customLayoutBuilder, // customize layout
      itemBuilder: customItemBuilder, // customize builder
    );
  }

  Widget customLayoutBuilder(
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

  Widget customItemBuilder(
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
