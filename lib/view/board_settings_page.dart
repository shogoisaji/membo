import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/string.dart';
import 'package:membo/utils/color_utils.dart';
import 'package:membo/view_model/board_settings_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/custom_date_picker.dart';
import 'package:membo/widgets/custom_list_content.dart';
import 'package:membo/widgets/custom_snackbar.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:membo/widgets/two_way_dialog.dart';

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

    Future<void> initialize() async {
      await ref
          .read(boardSettingsViewModelProvider.notifier)
          .initializeLoad(boardId)
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          ErrorDialog.show(context, '通信状況を確認してください', onTapFunction: () {
            context.go('/sign-in');
          });
        },
      );
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

    Future<void> handleTapDate() async {
      final DateTime? datePicked = await showCustomDatePicker(
        context: context,
        initialDate: boardSettingsState.tempBoard != null
            ? boardSettingsState.tempBoard!.thatDay
            : DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime.now(),
      );

      if (datePicked == null) return;

      ref
          .read(boardSettingsViewModelProvider.notifier)
          .updateBoardSettings(thatDay: datePicked);
    }

    void handleTapPublic() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return TwoWayDialog(
            icon: SvgPicture.asset('assets/images/svg/circle-question.svg',
                width: 36,
                height: 36,
                colorFilter:
                    const ColorFilter.mode(MyColor.greenText, BlendMode.srcIn)),
            title: '公開ステータスを\n変更しますか？',
            leftButtonText: boardSettingsState.currentBoard?.isPublic == true
                ? '非公開にする'
                : '公開する',
            rightButtonText: 'キャンセル',
            onLeftButtonPressed: () async {
              await ref
                  .read(boardSettingsViewModelProvider.notifier)
                  .switchPublic();
              if (context.mounted) {
                context.go('/edit', extra: boardId);
                Navigator.of(context).pop();
              }
            },
            onRightButtonPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
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

    void handleTapDelete() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return TwoWayDialog(
            icon: SvgPicture.asset('assets/images/svg/circle-question.svg',
                width: 36,
                height: 36,
                colorFilter:
                    const ColorFilter.mode(MyColor.greenText, BlendMode.srcIn)),
            title: 'このボードを\n削除しますか？',
            leftButtonText: '削除',
            rightButtonText: 'キャンセル',
            onLeftButtonPressed: () async {
              try {
                await ref
                    .read(boardSettingsViewModelProvider.notifier)
                    .deleteBoard();

                if (context.mounted) {
                  Navigator.of(context).pop();
                  CustomSnackBar.show(context, 'ボードを削除しました', MyColor.blue);
                  context.go('/');
                }
              } catch (e) {
                if (context.mounted) {
                  ErrorDialog.show(context, e.toString());
                }
              }
            },
            onRightButtonPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
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
            HapticFeedback.lightImpact();
            if (isSaveable()) {
              showDialog(
                  context: context,
                  builder: (context) => TwoWayDialog(
                        icon: SvgPicture.asset(
                            'assets/images/svg/circle-question.svg',
                            width: 36,
                            height: 36,
                            colorFilter: const ColorFilter.mode(
                                MyColor.greenText, BlendMode.srcIn)),
                        title: '設定変更データを\n保存しますか？',
                        leftButtonText: '保存する',
                        rightButtonText: '保存しない',
                        onLeftButtonPressed: () {
                          Navigator.of(context).pop();
                          saveTempBoardSettings();
                        },
                        onRightButtonPressed: () {
                          Navigator.of(context).pop();
                          context.go('/edit', extra: boardId);
                        },
                      ));
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
                                HapticFeedback.lightImpact();
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
                            title: 'ボード名',
                            titleStyle: lightTextTheme.bodyLarge!,
                            backgroundColor: MyColor.greenLight,
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical:
                                    boardSettingsState.isOwner ? 0.0 : 21),
                            contentWidgets: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Name', style: lightTextTheme.bodyLarge),
                                  const SizedBox(width: 22.0),
                                  Expanded(
                                      child: boardSettingsState.isOwner
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 6.0),
                                                    child: TextField(
                                                      maxLength: 10,
                                                      focusNode: focusNode,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .bottom,
                                                      textAlign: TextAlign.end,
                                                      decoration:
                                                          const InputDecoration(
                                                              helperStyle:
                                                                  TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          0),
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          CustomListContent(
                            titleIcon: const Icon(Icons.calendar_month),
                            title: '日付',
                            titleStyle: lightTextTheme.bodyLarge!,
                            backgroundColor: MyColor.greenLight,
                            contentWidgets: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Date', style: lightTextTheme.bodyLarge),
                                  const SizedBox(width: 22.0),
                                  Expanded(
                                      child: boardSettingsState.isOwner
                                          ? Row(
                                              children: [
                                                Expanded(
                                                    child: GestureDetector(
                                                  onTap: () {
                                                    handleTapDate();
                                                  },
                                                  child: Text(
                                                    boardSettingsState
                                                        .tempBoard!.thatDay
                                                        .toIso8601String()
                                                        .toYMDString(),
                                                    textAlign: TextAlign.end,
                                                    style: lightTextTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )),
                                                const SizedBox(width: 10.0),
                                                const Icon(
                                                  Icons.edit_calendar_outlined,
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          CustomListContent(
                            titleIcon: const Icon(Icons.zoom_out_map),
                            title: 'ボードサイズ',
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
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          CustomListContent(
                            titleIcon: const Icon(Icons.color_lens),
                            title: '背景色',
                            titleStyle: lightTextTheme.bodyLarge!,
                            backgroundColor: MyColor.greenLight,
                            contentWidgets: [
                              GestureDetector(
                                onTap: () {
                                  if (!boardSettingsState.isOwner) return;
                                  HapticFeedback.lightImpact();
                                  showColorPicker.value =
                                      !showColorPicker.value;
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Color',
                                        style: lightTextTheme.bodyLarge),
                                    Container(
                                      width: 100,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                        color: Color(int.parse(
                                            boardSettingsState
                                                .tempBoard!.bgColor)),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          CustomListContent(
                            titleIcon:
                                const Icon(Icons.sentiment_satisfied_alt),
                            title: '所有者',
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
                                    Text('Name',
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
                            title: '公開ステータス',
                            titleStyle: lightTextTheme.bodyLarge!,
                            backgroundColor: MyColor.greenLight,
                            contentWidgets: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Status',
                                      style: lightTextTheme.bodyLarge),
                                  Row(
                                    children: [
                                      boardSettingsState.currentBoard!.isPublic
                                          ? Text(
                                              '公開',
                                              style: lightTextTheme.bodyLarge!
                                                  .copyWith(color: MyColor.red),
                                            )
                                          : Text('非公開',
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
                                      child: Text('保存',
                                          style: lightTextTheme.bodyLarge)),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 32.0),
                          boardSettingsState.isOwner
                              ? CustomButton(
                                  width: double.infinity,
                                  height: 50,
                                  color: MyColor.blueDark,
                                  onTap: () {
                                    handleTapPublic();
                                  },
                                  child: Center(
                                      child: Text(
                                          boardSettingsState
                                                  .currentBoard!.isPublic
                                              ? '非公開'
                                              : '公開',
                                          style: lightTextTheme.bodyLarge!
                                              .copyWith(
                                                  color: MyColor
                                                      .greenSuperLight))),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 32.0),
                          boardSettingsState.isOwner
                              ? CustomButton(
                                  width: double.infinity,
                                  height: 50,
                                  color: MyColor.red,
                                  onTap: () {
                                    handleTapDelete();
                                  },
                                  child: Center(
                                      child: Text('削除',
                                          style: lightTextTheme.bodyLarge!
                                              .copyWith(color: Colors.white))),
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
  final int minSize;
  final int maxSize;
  SizeDropDown(
      {super.key,
      required this.initialSize,
      required this.onChanged,
      required this.minSize,
      this.maxSize = 3000})
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

    void handleApproveRequest(String requestorId) async {
      try {
        await ref
            .read(boardSettingsViewModelProvider.notifier)
            .approveRequest(requestorId);
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

    void handleDenyRequest(String requestorId) async {
      try {
        await ref
            .read(boardSettingsViewModelProvider.notifier)
            .denyRequest(requestorId);
        initialize();
        if (context.mounted) {
          CustomSnackBar.show(context, 'リクエストを拒否しました', MyColor.blue);
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
              color: MyColor.greenLight),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              Text('編集リクエスト', style: lightTextTheme.bodyLarge),
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
                        Row(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColor.pink,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  handleDenyRequest(
                                      requestors.value[index].userId);
                                },
                                child: Text('拒否',
                                    style: lightTextTheme.bodyMedium)),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColor.blue,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  handleApproveRequest(
                                      requestors.value[index].userId);
                                },
                                child: Text('承認',
                                    style: lightTextTheme.bodyMedium!.copyWith(
                                        color: MyColor.greenSuperLight))),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Text('編集者一覧', style: lightTextTheme.bodyLarge),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColor.pink,
                              ),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                handleExcludeEditor(
                                    editors.value[index].userId);
                              },
                              child:
                                  Text('拒否', style: lightTextTheme.bodyMedium))
                        ],
                      ),
                    );
                  },
                ),
              ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColor.pink,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  selectColor(selectedColor.value);
                  hideModal();
                },
                child: Text(
                  'OK',
                  style: lightTextTheme.titleLarge,
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
    return BlockPicker(
      pickerColor: selectedColor, //default color
      onColorChanged: (Color color) {
        onColorChanged(color);
      },
      availableColors: bgColorList,
      useInShowDialog: false,
      itemBuilder: customItemBuilder,
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

  static const List<Color> bgColorList = [
    Color(0xFFFFFFFF),
    Color(0xFFCCCCCC),
    Color(0xFFBBBBBB),
    Color(0xFF999999),
    Color(0xFFFFE5E5),
    Color(0xFFFFCCCC),
    Color(0xFFFFB2B2),
    Color(0xFFFF9999),
    Color(0xFFE5FFE5),
    Color(0xFFCCFFCC),
    Color(0xFFB2FFB2),
    Color(0xFF99FF99),
    Color(0xFFE5E5FF),
    Color(0xFFCCCCFF),
    Color(0xFFB2B2FF),
    Color(0xFF9999FF),
    Color(0xFFFFFFE5),
    Color(0xFFFFFFCC),
    Color(0xFFFFFFB2),
    Color(0xFFFFFF99),
    Color(0xFFFFF2E5),
    Color(0xFFFFE5CC),
    Color(0xFFFFD9B2),
    Color(0xFFFFCC99),
    Color(0xFFF2E5F2),
    Color(0xFFE5CCE5),
    Color(0xFFD9B2D9),
    Color(0xFFCC99CC),
    Color(0xFFE5FFFF),
    Color(0xFFCCFFFF),
    Color(0xFFB2FFFF),
    Color(0xFF99FFFF),
    Color(0xFFFFE5F2),
    Color(0xFFFFCCE5),
    Color(0xFFFFB2D9),
    Color(0xFFFF99CC),
    Color(0xFFF2FFE5),
    Color(0xFFE5FFCC),
    Color(0xFFD9FFB2),
    Color(0xFFCCFF99),
  ];
}
