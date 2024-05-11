import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/view_model/connect_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:membo/widgets/thumbnail_card.dart';

class ConnectPage extends HookConsumerWidget {
  final String? uuid;
  const ConnectPage({super.key, this.uuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectPageState = ref.watch(connectPageViewModelProvider);

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    void checkBoard() async {
      if (uuid == null) return;
      final isExist = await ref
          .read(connectPageViewModelProvider.notifier)
          .checkBoardExist(uuid!);
      if (!isExist && context.mounted) {
        ErrorDialog.show(context, "ボードを取得できませんでした");
      }
    }

    useEffect(() {
      checkBoard();
      return;
    }, [uuid]);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Connect Page', style: lightTextTheme.titleLarge),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/qr-scan');
                    },
                    child: const Text('QR Scan'),
                  ),
                  connectPageState.board == null
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () {
                            context.go('/view',
                                extra: connectPageState.board!.boardId);
                          },
                          child: ThumbnailCard(
                              boardModel: connectPageState.board!)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
