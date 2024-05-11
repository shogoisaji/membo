import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

    final List<Widget> imageSliders = homePageState.ownedBoardModel
        .map((board) => GestureDetector(
            onTap: () {
              context.go('/view', extra: board.boardId);
            },
            onLongPress: () {
              tappedBoardId.value = board.boardId;
            },
            child: ThumbnailCard(boardModel: board)))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 120.0),
                homePageState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 0.7,
                            autoPlay: true,
                            aspectRatio: 2.0,
                            autoPlayInterval:
                                const Duration(milliseconds: 3500),
                            enlargeCenterPage: true,
                            onPageChanged: (index, _) {
                              print('index: $index');
                            },
                          ),
                          items: imageSliders,
                        ),
                      ),
                //  PageView.builder(
                //     controller: PageController(viewportFraction: 0.8),
                //     scrollDirection: Axis.horizontal,
                //     itemCount: homePageState.ownedBoardModel.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return Align(
                //           alignment: const Alignment(0, 0.2),
                //           child: GestureDetector(
                //             child: GestureDetector(
                //               onTap: () {
                //                 context.go('/view',
                //                     extra: homePageState
                //                         .ownedBoardModel[index].boardId);
                //               },
                //               onLongPress: () {
                //                 tappedBoardId.value =
                //                     homePageState.ownedBoardModel[index].boardId;
                //               },
                //               child: ThumbnailCard(
                //                   boardModel:
                //                       homePageState.ownedBoardModel[index]),
                //             ),
                //           ));
                //     },
                //   ),
              ],
            ),
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
