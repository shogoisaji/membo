import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
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
              : PageView.builder(
                  controller: PageController(viewportFraction: 0.8),
                  scrollDirection: Axis.horizontal,
                  itemCount: homePageState.boardModel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Align(
                        alignment: const Alignment(0, 0.2),
                        child: GestureDetector(
                          onTap: () {
                            context.go('/view',
                                extra: homePageState.boardModel[index].boardId);
                          },
                          child: ThumbnailCard(
                              boardModel: homePageState.boardModel[index]),
                          // child: Container(
                          //   decoration: BoxDecoration(
                          //     color: MyColor.greenSuperLight,
                          //     borderRadius: BorderRadius.circular(100),
                          //     border: Border.all(
                          //       width: 10,
                          //       color: MyColor.greenDark,
                          //     ),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.black.withOpacity(0.5),
                          //         offset: const Offset(1, 2),
                          //         blurRadius: 10,
                          //       ),
                          //     ],
                          //   ),
                          //   width: 300,
                          //   height: 200,
                          //   child: Center(
                          //       child: Text(
                          //           homePageState.boardModel[index].boardName,
                          //           style: lightTextTheme.bodyLarge)),
                          // ),
                        ));
                  },
                ),
        ],
      ),
    );
  }
}

class ThumbnailCard extends StatelessWidget {
  final BoardModel boardModel;

  const ThumbnailCard({super.key, required this.boardModel});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: (w * 0.7).clamp(200, 400),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
            decoration: BoxDecoration(
              color: MyColor.greenSuperLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 5,
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
            child: Column(
              children: [
                Container(
                  height: 50,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      boardModel.boardName,
                      style: lightTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Expanded(
                    child: CachedNetworkImage(
                        imageUrl:
                            'https://mawzoznhibuhrvxxyvtt.supabase.co/storage/v1/object/public/public_image/0996ec38-d300-4dd4-9e8b-1a887954c275/c7151efe-1fde-4dfd-ad80-269ae09b5daf.png',
                        width: double.infinity,
                        height: double.infinity,
                        imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                        placeholder: (context, url) =>
                            const ColoredBox(color: Colors.white),
                        errorWidget: (context, url, error) => const ColoredBox(
                            color: Colors.white, child: Icon(Icons.error)))),
                Container(
                  height: 50,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      boardModel.boardName,
                      style: lightTextTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
