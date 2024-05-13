import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/view_model/home_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_card_widget.dart';
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

    final List<Widget> imageSliders = homePageState.showBoardModels
        .map((board) => GestureDetector(
            onTap: () {
              context.go('/view', extra: board.boardModel.boardId);
            },
            onLongPress: () {
              tappedBoardId.value = board.boardModel.boardId;
            },
            child: ThumbnailCard(
              boardModel: board.boardModel,
              thumbnailImageUrl: null,
            )))
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
                              // print('index: $index');
                            },
                          ),
                          items: imageSliders,
                        ),
                      ),
                CustomCardWidget(
                  board: homePageState.showBoardModels[0].boardModel,
                  width: 200,
                  height: 250,
                  imageUrl:
                      'https://mawzoznhibuhrvxxyvtt.supabase.co/storage/v1/object/public/avatar_image/07b77fc9-b55e-4734-9a42-e5755d486f35/1715592393818.webp',
                ),
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
