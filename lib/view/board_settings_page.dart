import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/utils/color_utils.dart';
import 'package:membo/view_model/board_settings_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/custom_list_content.dart';
import 'package:membo/widgets/custom_snackbar.dart';
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
      ref.read(boardSettingsViewModelProvider.notifier).switchPublic();
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

    void showEditRequestList() async {
      if (!context.mounted) return;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const EditorListModal();
        },
      );
    }

    void deleteBoard() async {
      try {
        await ref.read(boardSettingsViewModelProvider.notifier).deleteBoard();

        if (context.mounted) {
          CustomSnackBar.show(context, 'Board deleted', MyColor.blue);
          context.go('/');
        }
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, e.toString());
        }
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                showEditRequestList();
                              },
                              child: SvgPicture.asset(
                                'assets/images/svg/editor.svg',
                                colorFilter: const ColorFilter.mode(
                                    MyColor.greenText, BlendMode.srcIn),
                                width: 35,
                                height: 35,
                              ),
                            ),
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
                                                      maxLength: 10,
                                                      focusNode: focusNode,
                                                      textAlign: TextAlign.end,
                                                      decoration:
                                                          const InputDecoration(

                                                              /// maxLength のカウンターは表示しない
                                                              counterText: '',
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
                            title: 'Share',
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
                            color: MyColor.blueDark,
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
                            color: MyColor.red,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                      'Are you sure you want to delete this board?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deleteBoard();
                                        },
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
                                    style: lightTextTheme.bodyLarge!
                                        .copyWith(color: Colors.white))),
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

class EditorListModal extends HookConsumerWidget {
  const EditorListModal({super.key});

  Widget divider() {
    return Container(
      width: double.infinity,
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, MyColor.greenDark, Colors.transparent],
        ),
      ),
    );
  }

  Widget avatar(String? avatarUrl) {
    return CircleAvatar(
      radius: 20,
      foregroundImage: NetworkImage(
        avatarUrl ?? '',
      ),
      child: const Icon(Icons.person, size: 24),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;

    final editors = useState<List<EditorUserData>>([]);
    final requestors = useState<List<EditorUserData>>([]);

    void initialize() async {
      editors.value =
          await ref.read(boardSettingsViewModelProvider.notifier).getEditors();
      requestors.value = await ref
          .read(boardSettingsViewModelProvider.notifier)
          .getRequestors();
    }

    void handleApproveRequest(String requestId) async {
      try {
        await ref
            .read(boardSettingsViewModelProvider.notifier)
            .approveRequest(requestId);
        await Future.delayed(const Duration(milliseconds: 500));
        initialize();
        if (context.mounted) {
          CustomSnackBar.show(context, 'Request approved', MyColor.blue);
        }
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, e.toString());
        }
      }
    }

    void handleExcludeEditor(String excludeEditorId) async {
      try {
        await ref
            .read(boardSettingsViewModelProvider.notifier)
            .excludeEditor(excludeEditorId);
        initialize();
        if (context.mounted) {
          CustomSnackBar.show(context, 'Editor excluded', MyColor.blue);
        }
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, e.toString());
        }
      }
    }

    useEffect(() {
      initialize();
      return;
    }, []);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: w,
          height: constraints.maxHeight,
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: MyColor.greenSuperLight),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              Text('Request List', style: lightTextTheme.bodyLarge),
              divider(),
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: requestors.value.length,
                  itemBuilder: (context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              avatar(requestors.value[index].avatarUrl),
                              Expanded(
                                child: Text(
                                  requestors.value[index].userName,
                                  style: lightTextTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              handleApproveRequest(
                                  requestors.value[index].userId);
                            },
                            child: Text('Approve',
                                style: lightTextTheme.bodyMedium))
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Text('Editor List', style: lightTextTheme.bodyLarge),

              divider(),
              Expanded(
                flex: 5,
                child: ListView.builder(
                  itemCount: editors.value.length,
                  itemBuilder: (context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                avatar(editors.value[index].avatarUrl),
                                Expanded(
                                  child: Text(
                                    editors.value[index].userName,
                                    style: lightTextTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                handleExcludeEditor(
                                    editors.value[index].userId);
                              },
                              child: Text('Exclude',
                                  style: lightTextTheme.bodyMedium))
                        ],
                      ),
                    );
                  },
                ),
              ),
              // ...editors.map((editor) => Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         avatar(editor.avatarUrl),
              //         Text(editor.userName, style: lightTextTheme.bodyMedium),
              //       ],
              //     )),
            ],
          ),
        );
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
