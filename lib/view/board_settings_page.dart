import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/utils/color_utils.dart';
import 'package:membo/view_model/board_settings_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/custom_list_content.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:membo/widgets/hue_ring_custom_picker.dart';

class BoardSettingsPage extends HookConsumerWidget {
  final String boardId;
  const BoardSettingsPage({super.key, required this.boardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final isFocus = useState(false);
    final focusNode = useFocusNode();
    final showPassword = useState(false);
    final showColorPicker = useState(false);
    final boardSettingsState = ref.watch(boardSettingsViewModelProvider);
    final boardNameTextController = useTextEditingController();

    final isFirstTextInput = useState(true);

    void initialize() {
      ref.read(boardSettingsViewModelProvider.notifier).initializeLoad(boardId);
    }

    void handleHideModal() {
      showColorPicker.value = false;
    }

    void handleSelectColor(Color color) {
      ref
          .read(boardSettingsViewModelProvider.notifier)
          .updateBoardSettings(color: ColorUtils.colorToHexString(color));
    }

    void handleUpdateWidth(int width) {
      ref
          .read(boardSettingsViewModelProvider.notifier)
          .updateBoardSettings(width: width);
    }

    void handleUpdateHeight(int height) {
      ref
          .read(boardSettingsViewModelProvider.notifier)
          .updateBoardSettings(height: height);
    }

    void handleUpdatePublicState() {
      final newPublicState = !boardSettingsState.currentBoard!.isPublic;
      ref
          .read(boardSettingsViewModelProvider.notifier)
          .updateBoardSettings(isPublic: newPublicState);
      context.go('/edit', extra: boardId);
    }

    void saveTempBoardSettings() {
      try {
        ref
            .read(boardSettingsViewModelProvider.notifier)
            .saveTempBoardSettings();
        context.go('/edit', extra: boardId);
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    void deleteBoard() {
      ref.read(boardSettingsViewModelProvider.notifier).deleteBoard();
      context.go('/');
    }

    bool isSaveable() {
      return ref.read(boardSettingsViewModelProvider.notifier).isChangeCheck();
    }

    useEffect(() {
      focusNode.addListener(() {
        isFocus.value = focusNode.hasFocus;
      });
      return null;
    }, []);

    useEffect(() {
      initialize();
      return;
    }, []);

    /// tempBoardName（Nameの初期値）が1度だけセットされる
    useEffect(() {
      if (!isFirstTextInput.value) return;
      if (boardSettingsState.tempBoard == null) return;
      boardNameTextController.text = boardSettingsState.tempBoard!.boardName;
      isFirstTextInput.value = false;
      return;
    }, [boardSettingsState.tempBoard]);

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          onPressed: () {
            if (isSaveable()) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  title: const Text('設定変更データを保存していません'),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.greenDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99.0),
                          ),
                        ),
                        onPressed: () {
                          try {
                            Navigator.of(context).pop();
                            saveTempBoardSettings();
                          } catch (e) {
                            ErrorDialog.show(context, e.toString());
                          }
                        },
                        child: Text(
                          '保存する',
                          style: lightTextTheme.bodyMedium!
                              .copyWith(color: MyColor.greenSuperLight),
                        )),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/edit', extra: boardId);
                      },
                      child: Text('保存しない', style: lightTextTheme.bodyMedium),
                    ),
                  ],
                ),
              );
            } else {
              context.go('/edit', extra: boardId);
            }
          },
        ),
      ),
      body: (boardSettingsState.tempBoard == null)
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                BgPaint(width: w, height: h),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(boardSettingsViewModelProvider.notifier)
                                  .changeOwner();
                            },
                            child: const Text('仮 Change Owner'),
                          ),
                          CustomListContent(
                            titleIcon: const Icon(Icons.local_mall),
                            title: 'Board Name',
                            titleStyle: lightTextTheme.bodyLarge!,
                            backgroundColor: MyColor.greenLight,
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical:
                                    boardSettingsState.isOwner ? 0.0 : 21),
                            contentWidgets: [
                              GestureDetector(
                                onTap: () {
                                  //
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Name',
                                        style: lightTextTheme.bodyLarge),
                                    const SizedBox(width: 22.0),
                                    Expanded(
                                        child: boardSettingsState.isOwner
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: TextField(
                                                      focusNode: focusNode,
                                                      textAlign: TextAlign.end,
                                                      decoration:
                                                          const InputDecoration(
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .transparent),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .transparent),
                                                              )),
                                                      controller:
                                                          boardNameTextController,
                                                      onChanged: (value) {
                                                        ref
                                                            .read(
                                                                boardSettingsViewModelProvider
                                                                    .notifier)
                                                            .updateBoardSettings(
                                                                boardName:
                                                                    value);
                                                      },
                                                      style: lightTextTheme
                                                          .bodyLarge,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.edit,
                                                    color: MyColor.greenDark,
                                                  )
                                                ],
                                              )
                                            : Text(
                                                boardSettingsState
                                                    .tempBoard!.boardName,
                                                textAlign: TextAlign.end,
                                                style: lightTextTheme.bodyLarge!
                                                    .copyWith(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          CustomListContent(
                            titleIcon: const Icon(Icons.zoom_out_map),
                            title: 'Board Size',
                            titleStyle: lightTextTheme.bodyLarge!,
                            backgroundColor: MyColor.greenLight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 6.0),
                            contentWidgets: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Width',
                                      style: lightTextTheme.bodyLarge),
                                  boardSettingsState.isOwner
                                      ? SizedBox(
                                          width: 100,
                                          child: SizeDropDown(
                                            initialSize: boardSettingsState
                                                .tempBoard!.width
                                                .toInt(),
                                            onChanged: (value) {
                                              handleUpdateWidth(value);
                                            },
                                            minSize: 100,
                                            maxSize: 2000,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            boardSettingsState.tempBoard!.width
                                                .toStringAsFixed(0),
                                            style: lightTextTheme.bodyLarge,
                                          ),
                                        ),
                                  // Text(currentSettings.width.toStringAsFixed(0),
                                  //     style: lightTextTheme.bodyLarge),
                                ],
                              ),
                              const Divider(color: MyColor.greenDark),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Height',
                                      style: lightTextTheme.bodyLarge),
                                  boardSettingsState.isOwner
                                      ? SizedBox(
                                          width: 100,
                                          child: SizeDropDown(
                                            initialSize: boardSettingsState
                                                .tempBoard!.height
                                                .toInt(),
                                            onChanged: (value) {
                                              handleUpdateHeight(value);
                                            },
                                            minSize: 100,
                                            maxSize: 2000,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            boardSettingsState.tempBoard!.height
                                                .toStringAsFixed(0),
                                            style: lightTextTheme.bodyLarge,
                                          ),
                                        ),
                                  // Text(currentSettings.height.toStringAsFixed(0),
                                  //     style: lightTextTheme.bodyLarge),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          CustomListContent(
                            titleIcon: const Icon(Icons.color_lens),
                            title: 'Background Color',
                            titleStyle: lightTextTheme.bodyLarge!,
                            backgroundColor: MyColor.greenLight,
                            contentWidgets: [
                              GestureDetector(
                                onTap: () {
                                  if (!boardSettingsState.isOwner) return;

                                  showColorPicker.value =
                                      !showColorPicker.value;
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Color',
                                        style: lightTextTheme.bodyLarge),
                                    Row(
                                      children: [
                                        Container(
                                          width: 24.0,
                                          height: 24.0,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                // offset: const Offset(0, 1),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            color: Color(int.parse(
                                                boardSettingsState
                                                    .tempBoard!.bgColor)),
                                          ),
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          ColorUtils.colorToString(
                                            Color(int.parse(boardSettingsState
                                                .tempBoard!.bgColor)),
                                          ),
                                          style: lightTextTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          CustomListContent(
                            titleIcon:
                                const Icon(Icons.sentiment_satisfied_alt),
                            title: 'Board Owner',
                            titleStyle: lightTextTheme.bodyLarge!,
                            backgroundColor: MyColor.greenLight,
                            contentWidgets: [
                              GestureDetector(
                                onTap: () {
                                  //
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('OwnerName',
                                        style: lightTextTheme.bodyLarge),
                                    const SizedBox(width: 22.0),
                                    Expanded(
                                        child: Text(
                                      boardSettingsState.ownerName,
                                      textAlign: TextAlign.end,
                                      style: lightTextTheme.bodyLarge!.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          CustomListContent(
                            titleIcon: const Icon(Icons.language),
                            title: 'Share Setting',
                            titleStyle: lightTextTheme.bodyLarge!,
                            backgroundColor: MyColor.greenLight,
                            contentWidgets: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('PublicState',
                                      style: lightTextTheme.bodyLarge),
                                  Row(
                                    children: [
                                      boardSettingsState.currentBoard!.isPublic
                                          ? Text(
                                              'Public',
                                              style: lightTextTheme.bodyLarge!
                                                  .copyWith(color: MyColor.red),
                                            )
                                          : Text('Private',
                                              style: lightTextTheme.bodyLarge),
                                    ],
                                  ),
                                ],
                              ),
                              // TODO: 仮に反転している
                              boardSettingsState.currentBoard!.isPublic !=
                                          true &&
                                      boardSettingsState.isOwner
                                  ? Column(
                                      children: [
                                        const Divider(color: MyColor.greenDark),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Password',
                                                style:
                                                    lightTextTheme.bodyLarge),
                                            Row(
                                              children: [
                                                Text(
                                                    showPassword.value
                                                        ? boardSettingsState
                                                                .tempPassword ??
                                                            boardSettingsState
                                                                .currentBoard!
                                                                .password
                                                        : '⚫︎' * 7,
                                                    style: lightTextTheme
                                                        .bodyLarge),
                                                const SizedBox(width: 6.0),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (!boardSettingsState
                                                        .isOwner) return;
                                                    showPassword.value =
                                                        !showPassword.value;
                                                  },
                                                  child: Icon(showPassword.value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          boardSettingsState.isOwner
                              ? CustomButton(
                                  width: double.infinity,
                                  height: 50,
                                  color: isSaveable()
                                      ? MyColor.pink
                                      : MyColor.greenDark,
                                  onTap: isSaveable()
                                      ? () {
                                          try {
                                            saveTempBoardSettings();
                                          } catch (e) {
                                            ErrorDialog.show(
                                                context, e.toString());
                                          }
                                        }
                                      : null,
                                  child: Center(
                                      child: Text('Save',
                                          style: lightTextTheme.bodyLarge)),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 32.0),
                          CustomButton(
                            width: double.infinity,
                            height: 50,
                            color: MyColor.blue,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(boardSettingsState
                                          .currentBoard!.isPublic
                                      ? 'Would you like to keep this board private?'
                                      : 'Would you like to make this board public?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () => {
                                              handleUpdatePublicState(),
                                              Navigator.of(context).pop(),
                                            },
                                        child: Text(boardSettingsState
                                                .currentBoard!.isPublic
                                            ? 'Unpublish'
                                            : 'Publish')),
                                    ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancel')),
                                  ],
                                ),
                              );
                            },
                            child: Center(
                                child: Text(
                                    boardSettingsState.currentBoard!.isPublic
                                        ? 'Unpublish'
                                        : 'Publish',
                                    style: lightTextTheme.bodyLarge!.copyWith(
                                        color: MyColor.greenSuperLight))),
                          ),
                          const SizedBox(height: 32.0),
                          CustomButton(
                            width: double.infinity,
                            height: 50,
                            color: MyColor.pink,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                      'Are you sure you want to delete this board?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () => deleteBoard(),
                                        child: const Text('Delete')),
                                    ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancel')),
                                  ],
                                ),
                              );
                            },
                            child: Center(
                                child: Text('Delete',
                                    style: lightTextTheme.bodyLarge)),
                          ),
                          const SizedBox(height: 100.0),
                        ],
                      ),
                    ),
                  ),
                ),
                isFocus.value
                    // focusNode.hasFocus
                    ? GestureDetector(
                        onTap: () {
                          focusNode.unfocus();
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.transparent,
                        ),
                      )
                    : const SizedBox.shrink(),
                showColorPicker.value
                    ? BoardColorPicker(
                        hideModal: handleHideModal,
                        selectColor: handleSelectColor,
                      )
                    : const SizedBox.shrink()
              ],
            ),
    );
  }
}

const itemList = [1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000];

class SizeDropDown extends HookConsumerWidget {
  final Function(int) onChanged;
  final int initialSize;
  final minSize;
  final maxSize;
  SizeDropDown(
      {super.key,
      required this.initialSize,
      required this.onChanged,
      required this.minSize,
      required this.maxSize})
      : assert(itemList.contains(initialSize));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropDownValue = useState<int>(initialSize);

    return DropdownButtonFormField(
      style: lightTextTheme.bodyLarge!.copyWith(color: MyColor.greenText),
      isDense: true,
      padding: EdgeInsets.zero,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      ),
      value: dropDownValue.value,
      items: itemList
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Center(
                child: Text(
                  item.toString(),
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        onChanged(value as int);
      },
    );
  }
}

class BoardColorPicker extends HookConsumerWidget {
  final Function hideModal;
  final Function selectColor;
  const BoardColorPicker(
      {super.key, required this.hideModal, required this.selectColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(boardSettingsViewModelProvider).tempBoard;
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final selectedColor = useState<Color>(board?.bgColor != null
        ? Color(int.parse(board!.bgColor))
        : Colors.black);

    void handleChangeColor(Color color) {
      selectedColor.value = color;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () {
            hideModal();
          },
          child: Container(
            width: w,
            height: h,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _colorPicker(selectedColor.value, handleChangeColor, h * 0.3),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  selectColor(selectedColor.value);
                  hideModal();
                },
                child: Text(
                  'OK',
                  style: lightTextTheme.bodyLarge,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _colorPicker(
      Color selectedColor, Function(Color) onColorChanged, double height) {
    return HueRingCustomPicker(
      colorPickerHeight: height,
      pickerColor: selectedColor, //default color
      onColorChanged: (Color color) {
        onColorChanged(color);
      },
    );
  }
}
