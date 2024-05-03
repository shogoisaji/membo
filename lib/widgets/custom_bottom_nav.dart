import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:membo/gen/assets.gen.dart';
import 'package:membo/state/navigation_state.dart';

/// TODO:refactoring
const navItems = [
  {"icon": Icons.home, "route": "/"},
  {"icon": Icons.edit, "route": "/edit-list"},
  {"icon": Icons.commute, "route": "/connect"},
  {"icon": Icons.settings, "route": "/settings"},
];

class CustomBottomNav extends HookConsumerWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(bottomNavigationStateProvider);
    final currentRoute = navState.currentRoute;
    final w = MediaQuery.sizeOf(context).width;
    final navSize = Size(w, 60);

    /// Listen to route & change the current route
    void routeListener() {
      final currentRoute =
          GoRouter.of(context).routerDelegate.currentConfiguration;
      print('Current route: ${currentRoute.uri}');
      ref
          .read(bottomNavigationStateProvider.notifier)
          .setRoute(currentRoute.uri.toString());
    }

    useEffect(() {
      GoRouter.of(context).routerDelegate.addListener(routeListener);
      return () {
        GoRouter.of(context).routerDelegate.removeListener(routeListener);
      };
    }, []);

    return navState.visible
        ? Container(
            width: navSize.width,
            height: navSize.height,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: navItems
                  .map((item) => GestureDetector(
                      onTap: () {
                        context.go(item['route'] as String);
                      },
                      child:
                          // ItemIcon(
                          //   asset: Assets.lotties.hello,
                          //   isMove: currentRoute.value == item['route'] as String,
                          // )
                          Icon(
                        item['icon'] as IconData,
                        color: currentRoute == item['route']
                            ? Colors.blue
                            : Colors.grey,
                      )))
                  .toList(),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    ref.read(bottomNavigationStateProvider.notifier).show();
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  )),
            ],
          );
  }
}

class NavItemIcon extends StatefulWidget {
  final String asset;
  final bool isMove;
  const NavItemIcon({super.key, required this.asset, required this.isMove});

  @override
  State<NavItemIcon> createState() => _NavItemIconState();
}

class _NavItemIconState extends State<NavItemIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  didUpdateWidget(NavItemIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMove != widget.isMove) {
      if (widget.isMove) {
        _controller.animateTo(0.8);
      } else {
        _controller.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      width: 50,
      height: 50,
      widget.asset,
      controller: _controller,
    );
  }
}
