import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:membo/gen/assets.gen.dart';

const navItems = [
  {"icon": Icons.home, "route": "/"},
  {"icon": Icons.edit, "route": "/edit"},
  {"icon": Icons.commute, "route": "/connect"},
  {"icon": Icons.settings, "route": "/settings"},
];

class CustomBottomNav extends HookConsumerWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = useState<String>('/');
    final w = MediaQuery.sizeOf(context).width;

    void updateCurrentRoute() {
      final goRouter = GoRouter.of(context);
      final RouteMatchList matchList =
          goRouter.routerDelegate.currentConfiguration;
      currentRoute.value = matchList.uri.toString();
      print('currentRoute: ${matchList.uri}');
    }

    return Container(
      width: w,
      height: 60,
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
                  updateCurrentRoute();
                },
                child:
                    // ItemIcon(
                    //   asset: Assets.lotties.hello,
                    //   isMove: currentRoute.value == item['route'] as String,
                    // )
                    Icon(
                  item['icon'] as IconData,
                  color: currentRoute.value == item['route']
                      ? Colors.blue
                      : Colors.grey,
                )))
            .toList(),
      ),
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
