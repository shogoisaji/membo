import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/view_model/home_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/sharing_widget.dart';
import 'package:membo/widgets/thumbnail_card.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final tappedBoardId = useState<String?>(null);

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
              : PageView.builder(
                  controller: PageController(viewportFraction: 0.8),
                  scrollDirection: Axis.horizontal,
                  itemCount: homePageState.boardModel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Align(
                        alignment: const Alignment(0, 0.2),
                        child: GestureDetector(
                          child: GestureDetector(
                            onTap: () {
                              context.go('/view',
                                  extra:
                                      homePageState.boardModel[index].boardId);
                            },
                            onLongPress: () {
                              tappedBoardId.value =
                                  homePageState.boardModel[index].boardId;
                            },
                            child: ThumbnailCard(
                                boardModel: homePageState.boardModel[index]),
                          ),
                        ));
                  },
                ),
          tappedBoardId.value != null
              ? SharingWidget(
                  boardId: tappedBoardId.value!,
                  onTapModal: () {
                    tappedBoardId.value = null;
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
