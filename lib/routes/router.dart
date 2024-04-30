import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:membo/pages/sign_in_page.dart';
import 'package:membo/pages/home_page.dart';
import 'package:membo/pages/settings_page.dart';

part 'router.g.dart';

class PagePath {
  static const home = '/';
  static const signIn = '/sign-in';
  static const settings = '/settings';
}

@riverpod
GoRouter router(RouterRef ref) {
  final routes = [
    GoRoute(
      path: PagePath.signIn,
      builder: (_, __) => const SignInPage(),
    ),
    GoRoute(
      path: PagePath.home,
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: PagePath.settings,
      builder: (_, __) => const SettingsPage(),
    ),
  ];

  String? redirect(BuildContext context, GoRouterState state) {
    final page = state.uri.toString();
    final signedIn = ref.watch(userStateProvider) != null ? true : false;

    if (signedIn && page == PagePath.signIn) {
      return PagePath.home;
    } else if (!signedIn) {
      // return PagePath.signIn;
    } else {
      return null;
    }
    return null;
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
