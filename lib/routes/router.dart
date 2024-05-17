import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/state/navigation_state.dart';
import 'package:membo/view/account_page.dart';
import 'package:membo/view/board_settings_page.dart';
import 'package:membo/view/connect_page.dart';
import 'package:membo/view/custom_license_page.dart';
import 'package:membo/view/edit_list_page.dart';
import 'package:membo/view/edit_page.dart';
import 'package:membo/view/board_view_page.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/view/policy_page.dart';
import 'package:membo/view/scan_page.dart';
import 'package:membo/view/terms_of_service_page.dart';
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
  static const qrScan = '/qr-scan';
  static const license = '/license';
  static const termsOfService = '/terms-of-service';
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
        SlideTransition(
      position: Tween<Offset>(
              begin: const Offset(0.03, -0.005), end: const Offset(0, 0))
          .animate(animation),
      child: child,
    ),
    transitionDuration: const Duration(milliseconds: 50),
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

                  /// 画面下部にナビゲーションバーを表示
                  // const Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: CustomBottomNav(),
                  // ),
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
            child: EditPage(boardId: state.extra as String),
          ),
        ),
        GoRoute(
          path: PagePath.boardView,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: BoardViewPage(boardId: state.extra as String),
          ),
        ),
        GoRoute(
          path: PagePath.boardSettings,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: BoardSettingsPage(
              boardId: state.extra as String,
            ),
          ),
        ),
        GoRoute(
          path: PagePath.connect,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: ConnectPage(uuid: state.extra as String?),
          ),
        ),
        GoRoute(
          path: PagePath.qrScan,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const QrScanPage(),
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
        GoRoute(
          path: PagePath.termsOfService,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const TermsOfServicePage(),
          ),
        ),
        GoRoute(
          path: PagePath.license,
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const CustomLicensePage(),
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
