import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/widgets/custom_bottom_nav.dart';
import 'package:membo/widgets/custom_paint/app_bar_painter.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final paddingTop = MediaQuery.of(context).padding.top;
    final progress = useState(0.0);

    useEffect(() {
      scrollController.addListener(() {
        progress.value =
            scrollController.offset / scrollController.position.maxScrollExtent;
      });
      return scrollController.dispose;
    }, [scrollController]);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: kToolbarHeight),
              Expanded(
                  child: ListView.builder(
                controller: scrollController,
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item $index'),
                  );
                },
              ))
            ],
          ),
          Positioned(
            top: 0,
            child: CustomAppBar(
              width: w,
              height: kToolbarHeight,
              paddingTop: paddingTop,
              progress: progress.value,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => context.go('/settings'),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () =>
                      ref.read(supabaseAuthRepositoryProvider).signOut(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final double width;
  final double height;
  final double paddingTop;
  final double progress;
  final List<Widget> actions;
  const CustomAppBar(
      {super.key,
      required this.width,
      required this.height,
      required this.paddingTop,
      required this.progress,
      required this.actions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height + paddingTop,
      child: Stack(
        children: [
          Positioned(
            top: paddingTop,
            child: CustomPaint(
              size: Size(width, kToolbarHeight),
              painter: AppBarPainter(
                  color: Theme.of(context).colorScheme.surface,
                  progress: progress),
            ),
          ),
          Positioned(
            top: paddingTop,
            child: SizedBox(
              width: width,
              height: kToolbarHeight,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Expanded(
                    child: Center(
                        child: Text('Home Page',
                            style: lightTextTheme.titleLarge))),
                ...actions,
              ]),
            ),
          ),
          Positioned(
            top: 0,
            child: CustomPaint(
              size: Size(width, kToolbarHeight + 10),
              painter: AppBarPainter(
                  color: Theme.of(context).colorScheme.onSurface,
                  isShadow: true,
                  progress: progress),
            ),
          ),
        ],
      ),
    );
  }
}
