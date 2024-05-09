import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/models/user/user_model.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/state/board_view_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/view_model/home_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final homePageState = ref.watch(homePageViewModelProvider);

    void init() async {
      ref.read(homePageViewModelProvider.notifier).initialize();
    }

    useEffect(() {
      init();
      return null;
    }, []);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(supabaseAuthRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          homePageState.boardModel.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  itemCount: homePageState.boardModel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Align(
                        alignment: const Alignment(0, 0.2),
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .read(selectedBoardIdProvider.notifier)
                                .setSelectedBoardId(
                                    homePageState.boardModel[index].boardId);
                            context.go('/view');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColor.greenSuperLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 10,
                                color: MyColor.greenDark,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(1, 2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            width: 300,
                            height: 300,
                            child: Center(
                                child: Text(
                                    homePageState.boardModel[index].boardName)),
                          ),
                        ));
                  },
                ),
          // ...userData.value!.ownedBoardsId.map((id) {
          //   return Align(
          //     alignment: const Alignment(0, 0.2),
          //     child: GestureDetector(
          //       onTap: () {
          //         ref
          //             .read(selectedBoardIdProvider.notifier)
          //             .setSelectedBoardId(id);
          //         context.go('/view');
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: MyColor.greenSuperLight,
          //           shape: BoxShape.circle,
          //           border: Border.all(
          //             width: 10,
          //             color: MyColor.greenDark,
          //           ),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withOpacity(0.5),
          //               offset: const Offset(1, 2),
          //               blurRadius: 10,
          //             ),
          //           ],
          //         ),
          //         width: 300,
          //         height: 300,
          //       ),
          //     ),
          //   );
          // }),
          // Align(
          //     alignment: const Alignment(0, -0.2),
          //     child: GestureDetector(
          //       onTap: () {
          //         if (userData.value == null) return;
          //         ref
          //             .read(selectedBoardIdProvider.notifier)
          //             .setSelectedBoardId(userData.value!.ownedBoardsId.first);
          //         context.go('/view');
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: MyColor.greenSuperLight,
          //           shape: BoxShape.circle,
          //           border: Border.all(
          //             width: 10,
          //             color: MyColor.greenDark,
          //           ),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withOpacity(0.5),
          //               offset: const Offset(1, 2),
          //               blurRadius: 10,
          //             ),
          //           ],
          //         ),
          //         width: 300,
          //         height: 300,
          //       ),
          //     )),
        ],
      ),
    );
  }
}
