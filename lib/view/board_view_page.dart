import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/models/view_model_state/board_view_page_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/state/stream_board_state.dart';
import 'package:membo/utils/custom_indicator.dart';
import 'package:membo/view_model/board_view_page_view_model.dart';
import 'package:membo/widgets/board_widget.dart';
import 'package:membo/widgets/custom_snackbar.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:membo/widgets/two_way_dialog.dart';

import '../gen/assets.gen.dart';

class BoardViewPage extends HookConsumerWidget {
  final String boardId;
  final bool? isFromConnect;
  const BoardViewPage(
      {super.key, required this.boardId, this.isFromConnect = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamBoard = ref.watch(streamBoardModelProvider);
    final boardViewPageState = ref.watch(boardViewPageViewModelProvider);

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final isLoading = useState(true);
    final isMatrixSet = useState(false);
    final timer = useState<Timer?>(null);

    const scaleMin = 0.07;
    const scaleMax = 0.8;
    const bgColor = MyColor.greenLight;

    /// interactive viewerのコントローラー
    final TransformationController transformController =
        useTransformationController();

    void initialize() async {
      isLoading.value = true;
      try {
        await ref
            .read(boardViewPageViewModelProvider.notifier)
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
          ErrorDialog.show(context, 'データ取得に失敗しました', onTapFunction: () {
            context.go('/');
          });
          // showDialog(
          //   barrierDismissible: false,
          //   context: context,
          //   builder: (dialogContext) => TwoWayDialog(
          //     title: 'データ取得に失敗しました',
          //     leftButtonText: 'サインアウト',
          //     rightButtonText: 'リロード',
          //     onLeftButtonPressed: () {
          //       ref.read(supabaseAuthRepositoryProvider).signOut();
          //       context.go('/sign-in');
          //     },
          //     onRightButtonPressed: () {
          //       initialize();
          //     },
          //   ),
          // );
        }
      }
    }

    void handleAddLinkBoardIds() async {
      try {
        await ref
            .read(boardViewPageViewModelProvider.notifier)
            .addLinkedBoardId(
              boardId,
            );
        if (context.mounted) {
          CustomSnackBar.show(context, 'ブックマークに追加しました', MyColor.lightBlue);
        }
      } catch (e) {
        if (context.mounted) {
          if (e.toString() == 'Exist linked board') {
            ErrorDialog.show(context, '既に追加済みです');
            return;
          }
          ErrorDialog.show(context, '追加に失敗しました : $e');
        }
      }
    }

    void handleEditRequest() async {
      /// linked user 以外はリクエストできない
      if (boardViewPageState.userType != ViewPageUserTypes.linkedUser) return;

      /// サンプルボードはリクエストできない
      if (boardId == '80c81fac-b1d1-4780-86dd-05ac643278cf') {
        ErrorDialog.show(
          context,
          'サンプルボードは\nリクエストできません',
        );
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return TwoWayDialog(
            icon: SvgPicture.asset(Assets.images.svg.circleQuestion,
                width: 36,
                height: 36,
                colorFilter:
                    const ColorFilter.mode(MyColor.greenText, BlendMode.srcIn)),
            title: '編集リクエストを\n送りますか？',
            leftButtonText: 'リクエスト',
            rightButtonText: 'キャンセル',
            onLeftButtonPressed: () async {
              await ref
                  .read(boardViewPageViewModelProvider.notifier)
                  .sendEditRequest(boardId);
              if (context.mounted) {
                CustomSnackBar.show(context, 'リクエストを送りました', MyColor.lightBlue);
              }
            },
            onRightButtonPressed: () {},
          );
        },
      );
    }

    void handleAfterRequest(BuildContext context) async {
      /// requested user 以外はリクエストできない
      if (boardViewPageState.userType != ViewPageUserTypes.requestedUser) {
        return;
      }
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return TwoWayDialog(
            icon: SvgPicture.asset(Assets.images.svg.circleQuestion,
                width: 36,
                height: 36,
                colorFilter:
                    const ColorFilter.mode(MyColor.greenText, BlendMode.srcIn)),
            title: 'リクエスト済みです',
            content: 'リクエストを削除しますか？',
            leftButtonText: '削除',
            rightButtonText: 'キャンセル',
            onLeftButtonPressed: () async {
              await ref
                  .read(boardViewPageViewModelProvider.notifier)
                  .cancelRequest(boardId);
              if (context.mounted) {
                CustomSnackBar.show(context, 'リクエストを削除しました', MyColor.lightBlue);
              }
            },
            onRightButtonPressed: () {},
          );
        },
      );
    }

    useEffect(() {
      initialize();
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

    /// マトリックスの更新（基本的には初期化時）
    useEffect(() {
      if (boardViewPageState.transformationMatrix == null) return;
      transformController.value = boardViewPageState.transformationMatrix!;
      isMatrixSet.value = true;
      return null;
    }, [boardViewPageState.transformationMatrix]);

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
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: bgColor,
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
                Assets.images.svg.view,
                colorFilter:
                    const ColorFilter.mode(MyColor.greenDark, BlendMode.srcIn),
                width: 30,
                height: 30,
              ),
            ),
            boardViewPageState.userType == ViewPageUserTypes.requestedUser
                ? Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.greenSuperLight,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        handleAfterRequest(context);
                      },
                      child: SvgPicture.asset(
                        Assets.images.svg.request,
                        colorFilter: const ColorFilter.mode(
                            MyColor.green, BlendMode.srcIn),
                        width: 35,
                        height: 35,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            boardViewPageState.userType == ViewPageUserTypes.linkedUser
                ? Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.green,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        handleEditRequest();
                      },
                      child: SvgPicture.asset(
                        Assets.images.svg.request,
                        colorFilter: const ColorFilter.mode(
                            MyColor.greenText, BlendMode.srcIn),
                        width: 35,
                        height: 35,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            boardViewPageState.userType == ViewPageUserTypes.visitor
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        handleAddLinkBoardIds();
                      },
                      child: Text('ブックマークに追加', style: lightTextTheme.bodySmall),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        body: isLoading.value
            ? const Center(child: CustomIndicator())
            : Container(
                color: bgColor,
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
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
                          child: streamBoard == null
                              ? const SizedBox.shrink()
                              : BoardWidget(
                                  board: streamBoard, selectedObject: null),
                        )),
                  ],
                ),
              ));
  }
}
