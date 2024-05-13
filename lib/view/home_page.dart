import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/view_model/home_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_home_card_widget.dart';
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

    useEffect(() {
      init();
      return null;
    }, []);

    final List<Widget> imageSliders = homePageState.showBoardModels
        .map((board) => CachedNetworkImage(
            imageUrl: board.boardModel.objects.first.imageUrl ?? '',
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
            errorWidget: (context, url, error) => const ColoredBox(
                color: Colors.white, child: Icon(Icons.error))))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                stretch: true,
                expandedHeight: 150,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 0, bottom: 2),
                  title: Text('Membo',
                      style: lightTextTheme.titleLarge!.copyWith(shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.7),
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset:
                              const Offset(1, 2), // changes position of shadow
                        ),
                      ], color: MyColor.greenSuperLight, fontSize: 32)),
                  background: homePageState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                                homePageState.showBoardModels[index].boardModel,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            imageUrl: homePageState.showBoardModels[index]
                                    .boardModel.objects.first.imageUrl ??
                                '',
                            onTapQr: () {
                              //
                            },
                            onTapView: () {
                              //
                            },
                          );
                        },
                      );
                    },
                    childCount: homePageState.showBoardModels.length,
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
