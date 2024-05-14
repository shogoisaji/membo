import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/view_model/home_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_home_card_widget.dart';
import 'package:membo/widgets/custom_snackbar.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:membo/widgets/sharing_widget.dart';

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

    void handleTapQr(String boardId) {
      tappedBoardId.value = boardId;
    }

    void handleTapView(String boardId) {
      context.go('/view', extra: boardId);
    }

    void handleTapDelete(String boardId) async {
      try {
        await ref
            .read(homePageViewModelProvider.notifier)
            .deleteBoardFromCard(boardId);
        if (context.mounted) {
          CustomSnackBar.show(context, 'Board deleted', MyColor.blue);
        }
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, e.toString());
        }
      }
    }

    useEffect(() {
      init();
      return null;
    }, []);

    final List<Widget> imageSliders = homePageState.carouselImageUrls
        .map((imageUrl) => CachedNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: double.infinity,
            imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            placeholder: (context, url) =>
                const ColoredBox(color: Colors.white),
            errorWidget: (context, url, error) => Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                )))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          homePageState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      stretch: true,
                      expandedHeight: 150,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.only(left: 0, bottom: 2),

                        /// TITLE
                        title: Text('',
                            // 'Membo',
                            style:
                                lightTextTheme.titleLarge!.copyWith(shadows: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.7),
                                blurRadius: 2,
                                spreadRadius: 1,
                                offset: const Offset(
                                    1, 2), // changes position of shadow
                              ),
                            ], color: MyColor.greenSuperLight, fontSize: 32)),
                        background: Container(
                          color: Colors.white,
                          height: double.infinity,
                          width: double.infinity,
                          child: CarouselSlider(
                            items: imageSliders,
                            options: CarouselOptions(
                              height: double.infinity,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              // aspectRatio: 2.0,
                              autoPlayInterval:
                                  const Duration(milliseconds: 3500),
                              enlargeCenterPage: false,
                              onPageChanged: (index, _) {
                                // print('index: $index');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 18),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return CustomHomeCardWidget(
                                  board:
                                      homePageState.cardBoardList[index].board,
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  imageUrl: homePageState.cardBoardList[index]
                                          .board.thumbnailUrl ??
                                      '',
                                  onTapQr: () {
                                    handleTapQr(homePageState
                                        .cardBoardList[index].board.boardId);
                                  },
                                  onTapView: () {
                                    handleTapView(homePageState
                                        .cardBoardList[index].board.boardId);
                                  },
                                  onTapDelete: () {
                                    handleTapDelete(homePageState
                                        .cardBoardList[index].board.boardId);
                                  },
                                  permission: homePageState
                                      .cardBoardList[index].permission,
                                );
                              },
                            );
                          },
                          childCount: homePageState.cardBoardList.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 150),
                    ),
                  ],
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
