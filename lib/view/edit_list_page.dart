import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/view_model/edit_list_page_view_model.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/error_dialog.dart';

class EditListPage extends HookConsumerWidget {
  const EditListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;

    final editListPageState = ref.watch(editListPageViewModelProvider);

    void initialize() {
      ref.read(editListPageViewModelProvider.notifier).initialize();
    }

    useEffect(() {
      initialize();
      return;
    }, []);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      // backgroundColor: const Color(0xFFEE9AD2),
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          Align(
            alignment: Alignment.center,
            child: CustomButton(
              width: 200,
              height: 50,
              color: Colors.blue,
              child: Center(
                  child: Text('New Board', style: lightTextTheme.bodyLarge)),
              onTap: () {
                try {
                  // ref
                  //     .read(editPageViewModelProvider.notifier)
                  //     .createNewBoard();
                  context.go('/edit');
                } catch (e) {
                  ErrorDialog.show(context, e.toString());
                }
              },
            ),
          ),
          ListView.builder(
              itemCount: editListPageState.boardModels.length,
              itemBuilder: (context, index) {
                return CustomButton(
                  width: 200,
                  height: 50,
                  color: Colors.orange,
                  child: Center(
                      child: Text(
                          editListPageState.boardModels[index].boardName,
                          style: lightTextTheme.bodyLarge)),
                  onTap: () async {
                    try {
                      ref
                          .read(editPageViewModelProvider.notifier)
                          .setSelectedBoardId(
                            editListPageState.boardModels[index].boardId,
                          );
                      context.go('/edit');
                    } catch (e) {
                      ErrorDialog.show(context, e.toString());
                    }
                  },
                );
              }),
          ...editListPageState.boardModels.map((board) {
            return Align(
              alignment: const Alignment(0, 0.3),
              child: CustomButton(
                width: 200,
                height: 50,
                color: Colors.orange,
                child: Center(
                    child:
                        Text(board.boardName, style: lightTextTheme.bodyLarge)),
                onTap: () async {
                  try {
                    ref
                        .read(editPageViewModelProvider.notifier)
                        .setSelectedBoardId(
                          board.boardId,
                        );
                    context.go('/edit');
                  } catch (e) {
                    ErrorDialog.show(context, e.toString());
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
