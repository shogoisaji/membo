import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/view_model/board_view_page_view_model.dart';
import 'package:membo/widgets/board_widget.dart';
import 'package:membo/widgets/error_dialog.dart';

class BoardViewPage extends HookConsumerWidget {
  final String boardId;
  const BoardViewPage({super.key, required this.boardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    const scaleMin = 0.1;
    const scaleMax = 20.0;

    /// interactive viewerのコントローラー
    final TransformationController transformController =
        useTransformationController();

    final boardViewPageState = ref.watch(boardViewPageViewModelProvider);

    void initialize() async {
      await ref
          .read(boardViewPageViewModelProvider.notifier)
          .initializeLoad(boardId, w, h)
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
      return () {
        ref.read(boardViewPageViewModelProvider.notifier).clear();
      };
    }, []);

    /// マトリックスの更新（基本的には初期化時）
    useEffect(() {
      if (boardViewPageState.transformationMatrix == null) return;
      transformController.value = boardViewPageState.transformationMatrix!;
      return null;
    }, [boardViewPageState.transformationMatrix]);

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 36),
            onPressed: () {
              context.go('/');
            },
          ),
        ),
        body: boardViewPageState.boardModel == null
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: MyColor.green,
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
                          child: boardViewPageState.boardModel == null
                              ? const SizedBox.shrink()
                              : BoardWidget(
                                  board: boardViewPageState.boardModel!,
                                  selectedObject: null),
                        )),
                  ],
                ),
              ));
  }
}
