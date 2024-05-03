import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:membo/state/navigation_state.dart';
import 'package:membo/view/board_setting_page.dart';
import 'package:membo/view/connect_page.dart';
import 'package:membo/view/edit_list_page.dart';
import 'package:membo/view/edit_page.dart';
import 'package:membo/view/view_page.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/widgets/custom_bottom_nav.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:membo/view/sign_in_page.dart';
import 'package:membo/view/home_page.dart';
import 'package:membo/view/settings_page.dart';

part 'router.g.dart';

class PagePath {
  static const home = '/';
  static const signIn = '/sign-in';
  static const boardEdit = '/edit';
  static const boardEditList = '/edit-list';
  static const boardView = '/view';
  static const boardSetting = '/board-setting';
  static const connect = '/connect';
  static const settings = '/settings';
}

@riverpod
GoRouter router(RouterRef ref) {
  final routes = [
    GoRoute(
      path: PagePath.signIn,
      builder: (_, __) => const SignInPage(),
    ),
    ShellRoute(
      builder: (_, __, child) => Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: [
          child,
          const Align(
            alignment: Alignment(0, 0.95),
            child: CustomBottomNav(),
          )
        ],
      )),
      routes: [
        GoRoute(
          path: PagePath.home,
          builder: (_, __) => const HomePage(),
        ),
        GoRoute(
          path: PagePath.boardEditList,
          builder: (_, __) => const EditListPage(),
        ),
        GoRoute(
          path: PagePath.boardEdit,
          builder: (_, __) => const EditPage(),
        ),
        GoRoute(
          path: PagePath.boardView,
          builder: (_, __) => const ViewPage(),
        ),
        GoRoute(
          path: PagePath.boardSetting,
          builder: (_, __) => const BoardSettingPage(),
        ),
        GoRoute(
          path: PagePath.connect,
          builder: (_, __) => const ConnectPage(),
        ),
        GoRoute(
          path: PagePath.settings,
          builder: (_, __) => const SettingsPage(),
        ),
      ],
    ),
  ];

  String? redirect(BuildContext context, GoRouterState state) {
    final page = state.uri.toString();
    final signedIn = ref.watch(userStateProvider) != null ? true : false;

    if (signedIn && page == PagePath.signIn) {
      return PagePath.home;
    } else if (!signedIn) {
      return PagePath.signIn;
    } else {
      return null;
    }
  }

  final listenable = ValueNotifier<Object?>(null);
  ref.listen<Object?>(userStateProvider, (_, newState) {
    listenable.value = newState;
  });
  ref.onDispose(listenable.dispose);

  return GoRouter(
    initialLocation: PagePath.signIn,
    routes: routes,
    redirect: redirect,
    refreshListenable: listenable,
  );
}
