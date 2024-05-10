import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/view_model/edit_list_page_view_model.dart';
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

    void createNewBoard() async {
      /// TODO:ボード数を確認した後に新しいボードを作成する
      /// checkBoardCount()
      try {
        final insertedBoardId = await ref
            .read(editListPageViewModelProvider.notifier)
            .createNewBoard();
        if (insertedBoardId == null) {
          if (context.mounted) {
            ErrorDialog.show(context, "ボードが作成できませんでした");
          }
          return;
        }
        if (context.mounted) {
          context.go('/edit', extra: insertedBoardId);
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          Column(
            children: [
              const SizedBox(height: 100),
              CustomButton(
                width: 200,
                height: 50,
                color: Colors.blue,
                child: Center(
                    child: Text('New Board', style: lightTextTheme.bodyLarge)),
                onTap: () {
                  createNewBoard();
                },
              ),
              // CustomButton(
              //   width: 300,
              //   height: 50,
              //   color: Colors.orange,
              //   child: Center(
              //       child: Text('sasa', style: lightTextTheme.bodyLarge)),
              //   onTap: () async {
              //     try {
              //       context.go('/edit',
              //           extra: '0996ec38-d300-4dd4-9e8b-1a887954c275');
              //     } catch (e) {
              //       ErrorDialog.show(context, e.toString());
              //     }
              //   },
              // ),
              Expanded(
                child: ListView.builder(
                    itemCount: editListPageState.boardModels.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                            width: 300,
                            height: 50,
                            color: Colors.orange,
                            child: Center(
                                child: Text(
                                    editListPageState
                                        .boardModels[index].boardName,
                                    style: lightTextTheme.bodyLarge)),
                            onTap: () async {
                              try {
                                context.go('/edit',
                                    extra: editListPageState
                                        .boardModels[index].boardId);
                              } catch (e) {
                                ErrorDialog.show(context, e.toString());
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }
}
