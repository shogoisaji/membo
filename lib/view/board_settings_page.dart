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

    void handleHideModal() {
      showColorPicker.value = false;
    }

    void handleSelectColor(Color color) {
      ref
          .read(boardSettingsViewModelProvider.notifier)
          .updateColor(ColorUtils.colorToHexString(color));
    }

    void handleUpdateWidth(double width) {
      ref.read(boardSettingsViewModelProvider.notifier).updateWidth(width);
    }

    void handleUpdateHeight(double height) {
      ref.read(boardSettingsViewModelProvider.notifier).updateHeight(height);
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

    bool isSaveable() {
      return ref.read(boardSettingsViewModelProvider.notifier).isChangeCheck();
    }

    useEffect(() {
      focusNode.addListener(() {
        isFocus.value = focusNode.hasFocus;
      });
      return null;
    }, []);

    void init() {
      ref.read(boardSettingsViewModelProvider.notifier).initializeLoad(boardId);
    }

    useEffect(() {
      init();
      return;
    }, []);

    /// tempBoardName（Nameの初期値）が1度だけセットされる
    useEffect(() {
      if (!isFirstTextInput.value) return;
      if (boardSettingsState.tempBoardName == null) return;
      boardNameTextController.text = boardSettingsState.tempBoardName!;
      isFirstTextInput.value = false;
      return;
    }, [boardSettingsState.tempBoardName]);

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
                        ref
                            .read(boardSettingsViewModelProvider.notifier)
                            .clear();
                        Navigator.of(context).pop();
                        context.go('/edit', extra: boardId);
                      },
                      child: Text('保存しない', style: lightTextTheme.bodyMedium),
                    ),
                  ],
                ),
              );
            } else {
              ref.read(boardSettingsViewModelProvider.notifier).clear();
              context.go('/edit', extra: boardId);
            }
          },
        ),
      ),
      body: (boardSettingsState.tempBoardSettings == null ||
              boardSettingsState.tempBoardName == null)
          ? const SizedBox.shrink()
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
                                                            .updateBoardName(
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
                                                    .tempBoardName!,
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
                                                .tempBoardSettings!.width
                                                .toInt(),
                                            onChanged: (value) {
                                              handleUpdateWidth(
                                                  value.toDouble());
                                            },
                                            minSize: 100,
                                            maxSize: 2000,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            boardSettingsState
                                                .tempBoardSettings!.width
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
                                                .tempBoardSettings!.height
                                                .toInt(),
                                            onChanged: (value) {
                                              handleUpdateHeight(
                                                  value.toDouble());
                                            },
                                            minSize: 100,
                                            maxSize: 2000,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            boardSettingsState
                                                .tempBoardSettings!.height
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
                                                    .tempBoardSettings!
                                                    .bgColor)),
                                          ),
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          ColorUtils.colorToString(
                                            Color(int.parse(boardSettingsState
                                                .tempBoardSettings!.bgColor)),
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
                            title: 'Share Settings',
                            titleStyle: lightTextTheme.bodyLarge!,
                            backgroundColor: MyColor.greenLight,
                            contentWidgets: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Public State',
                                      style: lightTextTheme.bodyLarge),
                                  Row(
                                    children: [
                                      Text(
                                          boardSettingsState.tempBoardSettings!
                                                      .isPublished ==
                                                  true
                                              ? 'Public'
                                              : 'Private',
                                          style: lightTextTheme.bodyLarge),
                                    ],
                                  ),
                                ],
                              ),
                              // TODO: 仮に反転している
                              boardSettingsState
                                              .tempBoardSettings!.isPublished !=
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
                          const SizedBox(height: 24.0),
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
                    ? BoardColorChangeModal(
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

class BoardColorChangeModal extends HookConsumerWidget {
  final Function hideModal;
  final Function selectColor;
  const BoardColorChangeModal(
      {super.key, required this.hideModal, required this.selectColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardSettings =
        ref.watch(boardSettingsViewModelProvider).tempBoardSettings;
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final selectedColor = useState<Color>(boardSettings?.bgColor != null
        ? Color(int.parse(boardSettings!.bgColor))
        : Colors.black);

    void handleChangeColor(Color color) {
      selectedColor.value = color;
    }

    return Stack(
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
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 400.0,
                  child: _colorPicker(selectedColor.value, handleChangeColor)),
              ElevatedButton(
                onPressed: () {
                  selectColor(selectedColor.value);
                  hideModal();
                },
                child: const Text('OK'),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _colorPicker(Color selectedColor, Function(Color) onColorChanged) {
    return HueRingCustomPicker(
      pickerColor: selectedColor, //default color
      onColorChanged: (Color color) {
        onColorChanged(color);
      },
    );
  }
}
