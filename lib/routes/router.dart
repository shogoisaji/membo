import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/state/navigation_state.dart';
import 'package:membo/view/account_page.dart';
import 'package:membo/view/board_settings_page.dart';
import 'package:membo/view/connect_page.dart';
import 'package:membo/view/edit_list_page.dart';
import 'package:membo/view/edit_page.dart';
import 'package:membo/view/board_view_page.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/view/policy_page.dart';
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
  static const boardSettings = '/board-settings';
  static const connect = '/connect';
  static const settings = '/settings';
  static const account = '/account';
  static const policy = '/policy';
  static const publicPolicy = '/public-policy';
}

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    opaque: false,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0.03, -0.005),
                      end: const Offset(0, 0))
                  .animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                child: child,
              ),
            )),
    transitionDuration: const Duration(milliseconds: 150),
  );
}

@riverpod
GoRouter router(RouterRef ref) {
  final routes = [
    GoRoute(
      path: PagePath.signIn,
      builder: (_, __) => const SignInPage(),
    ),
    GoRoute(
      path: PagePath.publicPolicy,
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const PolicyPage(),
      ),
    ),
    ShellRoute(
      builder: (_, __, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColor.green,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Stack(
                children: [
                  child,
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomBottomNav(),
                  ),
                ],
              )
            ],
          )),
      routes: [
        GoRoute(
          path: PagePath.home,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: PagePath.boardEditList,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const EditListPage(),
          ),
        ),
        GoRoute(
          path: PagePath.boardEdit,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const EditPage(),
          ),
        ),
        GoRoute(
          path: PagePath.boardView,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const BoardViewPage(),
          ),
        ),
        GoRoute(
          path: PagePath.boardSettings,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const BoardSettingsPage(),
          ),
        ),
        GoRoute(
          path: PagePath.connect,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const ConnectPage(),
          ),
        ),
        GoRoute(
          path: PagePath.settings,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const SettingsPage(),
          ),
        ),
        GoRoute(
          path: PagePath.account,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const AccountPage(),
          ),
        ),
        GoRoute(
          path: PagePath.policy,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const PolicyPage(),
          ),
        ),
      ],
    ),
  ];

  String? redirect(BuildContext context, GoRouterState state) {
    final page = state.uri.toString();
    final signedIn = ref.watch(userStateProvider) != null ? true : false;

    if (signedIn && page == PagePath.signIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(bottomNavigationStateProvider.notifier)
            .setRoute(PagePath.home);
      });
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
