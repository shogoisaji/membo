import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/exceptions/app_exception.dart';
import 'package:membo/models/user/membership_type.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/view_model/home_page_view_model.dart';
import 'package:membo/widgets/app_hint_dailog.dart';
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

    final isLoading = useState(true);

    final pageController = usePageController();
    final textFocusNode = useFocusNode();

    final currentPage = useState(0);

    final tappedQrBoardId = useState<String?>(null);

    final homePageState = ref.watch(homePageViewModelProvider);

    void initialize() async {
      isLoading.value = true;
      try {
        await ref.read(homePageViewModelProvider.notifier).initialize().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            ErrorDialog.show(context, '通信状況を確認してください', onTapFunction: () {
              ref.read(supabaseAuthRepositoryProvider).signOut();
              context.go('/sign-in');
            });
          },
        );

        final isFirst = await ref
            .read(homePageViewModelProvider.notifier)
            .checkFirstLogin();

        /// hint dialog
        if (context.mounted) {
          if (isFirst) {
            AppHintDialog.show(context, () {
              ref.read(homePageViewModelProvider.notifier).firstLogin();
              context.go('/account');
            });
          }
        }
      } on AppException catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, e.title, onTapFunction: () {
            ref.read(supabaseAuthRepositoryProvider).signOut();
            context.go('/sign-in');
          });
        }
        rethrow;
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, e.toString(), onTapFunction: () {
            ref.read(supabaseAuthRepositoryProvider).signOut();
            context.go('/sign-in');
          });
        }
      } finally {
        isLoading.value = false;
      }
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
          CustomSnackBar.show(context, 'ボードを削除しました', MyColor.blue);
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

    Future<void> handleRefresh() async {
      //
      initialize();
    }

    useEffect(() {
      initialize();

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
              errorWidget: (context, url, error) => SvgPicture.asset(
                'assets/images/svg/title.svg',
                fit: BoxFit.contain,
                width: 100,
                height: 100,
                colorFilter:
                    const ColorFilter.mode(MyColor.greenText, BlendMode.srcIn),
              ),
            ))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BgPaint(width: w, height: h),
          isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  color: MyColor.greenText,
                  backgroundColor: MyColor.pink,
                  displacement: 300,
                  onRefresh: handleRefresh,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        stretch: false,
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
                                    SvgPicture.asset(
                                      'assets/images/svg/title.svg',
                                      fit: BoxFit.contain,
                                      width: 100,
                                      height: 100,
                                      colorFilter: const ColorFilter.mode(
                                          MyColor.greenText, BlendMode.srcIn),
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
                                          width: 170,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.settings,
                                                  size: 42,
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.lightImpact();
                                                  context.go('/settings');
                                                },
                                              ),
                                              IconButton(
                                                icon: SvgPicture.asset(
                                                  'assets/images/svg/connect.svg',
                                                  width: 40,
                                                  height: 40,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          MyColor.greenText,
                                                          BlendMode.srcIn),
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.lightImpact();
                                                  context.go('/connect');
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12.0),
                                          child: CustomButton(
                                            width: 160,
                                            height: 42,
                                            color: MyColor.lightBlue,
                                            child: Center(
                                                child: Text(
                                              'ボード作成',
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
                                          .allCardBoardList[index]
                                          .board
                                          .boardId);
                                    },
                                    onTapView: () {
                                      handleTapView(homePageState
                                          .allCardBoardList[index]
                                          .board
                                          .boardId);
                                    },
                                    onTapEdit: () {
                                      handleTapEdit(homePageState
                                          .allCardBoardList[index]
                                          .board
                                          .boardId);
                                    },
                                    onTapDelete: () {
                                      handleTapDelete(homePageState
                                          .allCardBoardList[index]
                                          .board
                                          .boardId);
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
                        BoardNameInputContent(
                          pageController: pageController,
                          focusNode: textFocusNode,
                          membershipType:
                              homePageState.userModel?.membershipType ??
                                  MembershipType(type: MembershipTypes.free),
                          currentBoardCount:
                              homePageState.ownedCardBoardList.length,
                          onTapCancel: () {
                            currentPage.value = 0;
                          },
                          onTapCreate: (String boardName) {
                            handleTapCreate(boardName);
                          },
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

class BoardNameInputContent extends HookWidget {
  final PageController pageController;
  final FocusNode focusNode;
  final MembershipType membershipType;
  final int currentBoardCount;
  final int maxBoardNameChars = 16;
  final Function() onTapCancel;
  final Function(String) onTapCreate;
  const BoardNameInputContent(
      {super.key,
      required this.pageController,
      required this.focusNode,
      required this.membershipType,
      required this.currentBoardCount,
      required this.onTapCancel,
      required this.onTapCreate});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final textController = useTextEditingController();

    final isBoardMax = currentBoardCount == membershipType.maxBoardCount;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('ボードの新規作成', style: lightTextTheme.titleLarge),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          onPressed: () {
            HapticFeedback.lightImpact();
            onTapCancel();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 50),
                isBoardMax
                    ? Container(
                        decoration: BoxDecoration(
                          color: MyColor.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Column(
                          children: [
                            Text(
                              'ボードの作成数が上限に達しています',
                              style: lightTextTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: onTapCancel,
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                margin: const EdgeInsets.only(top: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '戻る',
                                    style: lightTextTheme.bodyMedium!.copyWith(
                                      color: MyColor.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('ボード名', style: lightTextTheme.titleMedium),
                                Text('$maxBoardNameChars文字以下',
                                    style: lightTextTheme.bodySmall),
                              ],
                            ),
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
                                  return '入力欄が空欄です';
                                } else if (value.length > maxBoardNameChars) {
                                  return '$maxBoardNameChars文字以下で入力してください';
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
                                        child: Text('作成',
                                            style: lightTextTheme.bodyLarge!
                                                .copyWith(
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
                                        child: Text('キャンセル',
                                            style: lightTextTheme.bodyLarge!
                                                .copyWith(
                                              color: MyColor.greenText,
                                            ))),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('マイボード', style: lightTextTheme.bodyMedium),
                            Row(
                              children: [
                                Text('$currentBoardCount',
                                    style: isBoardMax
                                        ? lightTextTheme.bodyLarge!.copyWith(
                                            color: MyColor.red,
                                          )
                                        : lightTextTheme.bodyMedium!.copyWith(
                                            color: MyColor.greenText)),
                                Text(' / ${membershipType.maxBoardCount}',
                                    style: lightTextTheme.bodyMedium),
                              ],
                            ),
                          ],
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                              height: 50,
                              width: constraints.maxWidth,
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14.0)),
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    width: 2,
                                    color: MyColor.greenText,
                                  ),
                                ),
                                color: MyColor.greenSuperLight,
                              ),
                              child: Row(children: [
                                Expanded(
                                  flex: currentBoardCount,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: currentBoardCount ==
                                              membershipType.maxBoardCount
                                          ? const BorderRadius.all(
                                              Radius.circular(10.0))
                                          : const BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(3.0),
                                              bottomRight: Radius.circular(3.0),
                                            ),
                                      color: MyColor.greenText,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: membershipType.maxBoardCount -
                                      currentBoardCount,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ]));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
