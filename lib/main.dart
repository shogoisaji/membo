import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/gen/fonts.gen.dart';
import 'package:membo/models/notice/public_notices_model.dart';
import 'package:membo/repositories/shared_preferences/shared_preferences_key.dart';
import 'package:membo/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:membo/routes/router.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:membo/widgets/two_way_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'env/env.dart';

void main() async {
  late final SharedPreferences sharedPreferences;
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await (
    Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      debug: false,
    ),
    Future(() async {
      sharedPreferences = await SharedPreferences.getInstance();
    })
  ).wait;

  /// 画面の向きを固定.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  const app = MyApp();
  final scope = ProviderScope(overrides: [
    sharedPreferencesRepositoryProvider
        .overrideWithValue(SharedPreferencesRepository(sharedPreferences)),
  ], child: app);
  runApp(MaterialApp(
    home: scope,
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeData = useState<PublicNoticesModel?>(null);
    final router = ref.watch(routerProvider);

    //Deeplink経由で起動したことを検知
    // Future<void> initDeepLinks() async {
    //   final appLinks = AppLinks();
    //   appLinks.uriLinkStream.listen((uri) {
    //     print('url : $uri');
    //   }).onError((error) {
    //     print(error.message);
    //   });
    // }
    Future<void> appStore() async {
      final Uri url = Uri.parse('https://membo.vercel.app/privacy-policy');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ErrorDialog.show(context, 'Could not launch $url');
        }
      }
    }

    void showUpdateDialog(String distVersion) {
      showDialog(
          context: context,
          builder: (context) {
            return TwoWayDialog(
              title: 'アップデートがあります',
              leftButtonText: 'Storeへ',
              rightButtonText: 'スキップ',
              onLeftButtonPressed: () {
                appStore();
              },
              onRightButtonPressed: () async {
                await ref
                    .read(sharedPreferencesRepositoryProvider)
                    .save<String>(
                        SharedPreferencesKey.skipUpdateVersion, distVersion);
                if (!context.mounted) return;
                Navigator.pop(context);
              },
            );
          });
    }

    Future<void> fetchPublicNotices() async {
      try {
        noticeData.value =
            await ref.read(supabaseRepositoryProvider).fetchPublicNotices();
        if (noticeData.value == null) throw Exception();

        /// メンテナンスのチェック
        if (noticeData.value!.noticeCode == 200) {
          /// メンテナンス中のダイアログを表示
          if (!context.mounted) return;
          ErrorDialog.show(context, 'メンテナンス中', onTapFunction: () {
            Future.delayed(const Duration(seconds: 2), () {
              fetchPublicNotices();
            });
          });
          return;
        }

        /// app version check
        final packageInfo = await PackageInfo.fromPlatform();
        final currentAppVersion = packageInfo.version;
        final distributeAppVersion = noticeData.value!.appVersion;

        /// 現在のバージョンと配信されているバージョンをチェック
        if (currentAppVersion == distributeAppVersion) return;
        final skipUpdateVersion = ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<String>(SharedPreferencesKey.skipUpdateVersion);

        /// すでにアップデートをスキップしている場合はスキップ
        if (skipUpdateVersion == distributeAppVersion) return;

        /// スキップしていなければダイアログで通知
        showUpdateDialog(distributeAppVersion);
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, '通信状況を確認してください', onTapFunction: () {
            Future.delayed(const Duration(seconds: 2), () {
              fetchPublicNotices();
            });
          });
        }
      }
    }

    final maintenanceRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const MaintenancePage(),
        ),
      ],
    );

    useEffect(() {
      FlutterNativeSplash.remove();
      fetchPublicNotices();
      // initDeepLinks();
      return null;
    }, []);

    return MaterialApp.router(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
          ),
          fontFamily: FontFamily.mPlusRounded1c,
          colorScheme: myColorTheme,
          iconTheme: const IconThemeData(color: MyColor.greenText),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig:
            noticeData.value == null || noticeData.value!.noticeCode != 100
                ? maintenanceRouter
                : router);
  }
}

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: MyColor.green,
      ),
      home: Scaffold(
        body: Center(
          child: Image.asset(
            'assets/images/splash.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
