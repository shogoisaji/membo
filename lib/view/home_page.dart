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
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/custom_home_card_widget.dart';
import 'package:membo/widgets/custom_snackbar.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:membo/widgets/sharing_widget.dart';

class HomePage extends HookConsumerWidget {
  final double appBarHeight = 240;
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final pageController = usePageController();
    final textFocusNode = useFocusNode();

    final currentPage = useState(0);

    final tappedQrBoardId = useState<String?>(null);

    final homePageState = ref.watch(homePageViewModelProvider);

    void init() async {
      ref.read(homePageViewModelProvider.notifier).initialize();
    }

    void handleTapQr(String boardId) {
      tappedQrBoardId.value = boardId;
    }

    void handleTapView(String boardId) {
      context.go('/view', extra: boardId);
    }

    void handleTapEdit(String boardId) async {
      /// 権限のチェック
      final isEditable = await ref
          .read(homePageViewModelProvider.notifier)
          .checkPermission(boardId);
      if (!context.mounted) return;
      if (!isEditable) {
        ErrorDialog.show(context, '権限がありません');
        return;
      }
      context.go('/edit', extra: boardId);
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

    void handleTapCreate(String boardName) async {
      try {
        final insertedBoardId = await ref
            .read(homePageViewModelProvider.notifier)
            .createNewBoard(boardName);
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
      init();

      /// currentPageを監視して変更があればpageを切り替える（board name input page）
      currentPage.addListener(() {
        pageController.animateToPage(currentPage.value,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
        if (currentPage.value == 0) {
          textFocusNode.unfocus();
        }
      });
      return null;
    }, []);

    final List<Widget> carouselImageSliders = homePageState.carouselImageUrls
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
                const ColoredBox(color: MyColor.pink),
            errorWidget: (context, url, error) => Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                )))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          homePageState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      stretch: true,
                      expandedHeight: appBarHeight,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          color: MyColor.pink,
                          height: double.infinity,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              CarouselSlider(
                                items: [
                                  Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  ...carouselImageSliders
                                ],
                                options: CarouselOptions(
                                  height: double.infinity,
                                  viewportFraction: 1.0,
                                  autoPlay: true,
                                  autoPlayInterval:
                                      const Duration(milliseconds: 3500),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.transparent,
                                      MyColor.pink.withOpacity(0.1),
                                      MyColor.pink.withOpacity(0.7),
                                      MyColor.pink,
                                      MyColor.pink,
                                    ],
                                  ),
                                ),
                                child: Align(
                                  alignment: const Alignment(0.0, 0.88),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.settings,
                                                size: 36,
                                              ),
                                              onPressed: () {
                                                context.go('/settings');
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.link,
                                                size: 36,
                                              ),
                                              onPressed: () {
                                                context.go('/connect');
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: CustomButton(
                                          width: 160,
                                          height: 42,
                                          color: MyColor.lightBlue,
                                          child: Center(
                                              child: Text(
                                            'New Board',
                                            style: lightTextTheme.bodyLarge!
                                                .copyWith(
                                              color: Colors.white,
                                            ),
                                          )),
                                          onTap: () {
                                            currentPage.value = 1;
                                            pageController.nextPage(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeInOut);
                                            print(
                                                'New Board ${textFocusNode.hasFocus}');
                                            textFocusNode.requestFocus();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          // childAspectRatio: 1.0,
                          mainAxisExtent: 250,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return CustomHomeCardWidget(
                                  board: homePageState
                                      .allCardBoardList[index].board,
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  imageUrl: homePageState
                                          .allCardBoardList[index]
                                          .board
                                          .thumbnailUrl ??
                                      '',
                                  onTapQr: () {
                                    handleTapQr(homePageState
                                        .allCardBoardList[index].board.boardId);
                                  },
                                  onTapView: () {
                                    handleTapView(homePageState
                                        .allCardBoardList[index].board.boardId);
                                  },
                                  onTapEdit: () {
                                    handleTapEdit(homePageState
                                        .allCardBoardList[index].board.boardId);
                                  },
                                  onTapDelete: () {
                                    handleTapDelete(homePageState
                                        .allCardBoardList[index].board.boardId);
                                  },
                                  permission: homePageState
                                      .allCardBoardList[index].permission,
                                );
                              },
                            );
                          },
                          childCount: homePageState.allCardBoardList.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 150),
                    ),
                  ],
                ),

          /// show QR code
          tappedQrBoardId.value != null
              ? SharingWidget(
                  boardId: tappedQrBoardId.value!,
                  onTapModal: () {
                    tappedQrBoardId.value = null;
                  },
                )
              : const SizedBox.shrink(),
          IgnorePointer(
            ignoring: currentPage.value != 1,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                /// 初期ページに空ページ
                Container(
                  color: Colors.transparent,
                ),

                /// ボード名入力ページ
                GestureDetector(
                  onTap: () {
                    textFocusNode.unfocus();
                  },
                  child: SizedBox(
                    width: w,
                    height: h,
                    child: Stack(
                      children: [
                        BgPaint(width: w, height: h),
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: w,
                            height: appBarHeight + kToolbarHeight,
                            child: BoardNameInputPage(
                              pageController: pageController,
                              focusNode: textFocusNode,
                              onTapCancel: () {
                                currentPage.value = 0;
                              },
                              onTapCreate: (String boardName) {
                                handleTapCreate(boardName);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BoardNameInputPage extends HookWidget {
  final PageController pageController;
  final FocusNode focusNode;
  final int maxBoardNameChars = 16;
  final Function() onTapCancel;
  final Function(String) onTapCreate;
  const BoardNameInputPage(
      {super.key,
      required this.pageController,
      required this.focusNode,
      required this.onTapCancel,
      required this.onTapCreate});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final textController = useTextEditingController();

    return ColoredBox(
      color: MyColor.pink,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: const Alignment(0.0, 0.9),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Board Name', style: lightTextTheme.titleMedium),
                      Text('Max $maxBoardNameChars chars',
                          style: lightTextTheme.bodySmall),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          // autofocus: true,
                          focusNode: focusNode,
                          maxLength: maxBoardNameChars,
                          controller: textController,
                          style: lightTextTheme.bodyMedium,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              counterText: '',
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide:
                                    BorderSide(color: MyColor.greenText),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide:
                                    BorderSide(color: MyColor.greenText),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            } else if (value.length > maxBoardNameChars) {
                              return 'Name cannot be longer than $maxBoardNameChars characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: CustomButton(
                                width: 100,
                                height: 40,
                                color: MyColor.greenDark,
                                child: Center(
                                    child: Text('Create',
                                        style:
                                            lightTextTheme.bodyLarge!.copyWith(
                                          color: Colors.white,
                                        ))),
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    onTapCreate(textController.text);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomButton(
                                width: 100,
                                height: 40,
                                color: MyColor.greenSuperLight,
                                onTap: onTapCancel,
                                child: Center(
                                    child: Text('Cancel',
                                        style:
                                            lightTextTheme.bodyLarge!.copyWith(
                                          color: MyColor.greenText,
                                        ))),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
