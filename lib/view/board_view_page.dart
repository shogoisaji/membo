import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/state/stream_board_state.dart';
import 'package:membo/view_model/board_view_page_view_model.dart';
import 'package:membo/widgets/board_widget.dart';
import 'package:membo/widgets/error_dialog.dart';

class BoardViewPage extends HookConsumerWidget {
  final String boardId;
  const BoardViewPage({super.key, required this.boardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamBoard = ref.watch(streamBoardModelProvider);
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

    final boardViewPageState = ref.watch(boardViewPageViewModelProvider);

    void initialize() async {
      await ref
          .read(boardViewPageViewModelProvider.notifier)
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

    void handleAddLinkBoardIds() async {
      try {
        await ref
            .read(boardViewPageViewModelProvider.notifier)
            .addLinkedBoardId(
              boardId,
            );
      } catch (e) {
        if (context.mounted) {
          if (e.toString() == 'Exist linked board') {
            ErrorDialog.show(context, '既に追加済みです');
            return;
          }
          ErrorDialog.show(context, '追加に失敗しました');
        }
      }
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
              context.go('/');
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: SvgPicture.asset(
                'assets/images/svg/view.svg',
                color: MyColor.greenDark,
                width: 30,
                height: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  handleAddLinkBoardIds();
                },
                child: const Text('このボードを登録'),
              ),
            ),
          ],
        ),
        body: isLoading.value
            ? const Center(child: CircularProgressIndicator())
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
