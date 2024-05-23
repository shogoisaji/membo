import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/gen/fonts.gen.dart';
import 'package:membo/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:membo/routes/router.dart';
import 'package:membo/settings/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  runApp(scope);
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    useEffect(() {
      FlutterNativeSplash.remove();
      // initDeepLinks();
      return null;
    }, []);

    return MaterialApp.router(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
        ),
        fontFamily: FontFamily.mPlusRounded1c,
        colorScheme: myColorTheme,
        iconTheme: const IconThemeData(color: MyColor.greenText),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
