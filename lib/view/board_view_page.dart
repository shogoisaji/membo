import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/state/board_view_state.dart';
import 'package:membo/view_model/board_view_page_view_model.dart';
import 'package:membo/widgets/board_widget.dart';
import 'package:membo/widgets/error_dialog.dart';

class BoardViewPage extends HookConsumerWidget {
  const BoardViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    /// interactive viewerのコントローラー
    final TransformationController transformController =
        useTransformationController();

    final board = ref.watch(boardModelStateProvider);
    final isLoading = useState(false);

    void setInitialTransform() {
      final state = ref.read(boardViewPageViewModelProvider);
      transformController.value = Matrix4.identity()
        ..translate(state.viewTranslateX, state.viewTranslateY, 0.0)
        ..scale(state.viewScale, state.viewScale, 1.0);
    }

    void initialize() async {
      try {
        await ref
            .read(boardViewPageViewModelProvider.notifier)
            .initializeLoad(w, h);
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
        ref
            .read(boardViewPageViewModelProvider.notifier)
            .updateViewScale(scale);
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
        ref.read(boardViewPageViewModelProvider.notifier).setBoardModel(board);
      });
      return null;
    }, [board]);

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: isLoading.value
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
                        minScale: 0.1,
                        maxScale: 20.0,
                        child: OverflowBox(
                          minWidth: 0.0,
                          maxWidth: double.infinity,
                          minHeight: 0.0,
                          maxHeight: double.infinity,
                          alignment: Alignment.center,
                          child: board == null
                              ? const SizedBox.shrink()
                              : BoardWidget(board: board, selectedObject: null),
                        )),
                  ],
                ),
              ));
  }
}
