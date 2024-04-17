import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:membo/pages/board_page.dart';
import 'package:membo/pages/home_page.dart';
import 'package:membo/pages/settings_page.dart';

class PageConfig {
  final String name;
  final Widget page;

  const PageConfig({required this.name, required this.page});
}

List<PageConfig> pages = [
  const PageConfig(name: '/', page: HomePage()),
  const PageConfig(name: '/board', page: BoardPage()),
  const PageConfig(name: '/settings', page: SettingsPage()),
  // const PageConfig(name: '/format_preview_page', page: FormatPreviewPage()),
  // const PageConfig(name: '/license', page: CustomLicensePage()),
];

GoRouter myRouter() {
  final routes = [
    ShellRoute(
        builder: (_, __, child) => Scaffold(
                body: Stack(
              children: [
                child,
                // const LoadingWidget(),
              ],
            )),
        routes: pages
            .map((pageConfig) => GoRoute(
                  path: pageConfig.name,
                  builder: (
                    BuildContext context,
                    GoRouterState state,
                  ) {
                    return pageConfig.page;
                  },
                ))
            .toList())
  ];

  return GoRouter(
    initialLocation: '/',
    routes: routes,
  );
}
