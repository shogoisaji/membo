import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:membo/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:membo/routes/route.dart';
import 'package:membo/settings/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  late final SharedPreferences sharedPreferences;
  WidgetsFlutterBinding.ensureInitialized();
  await (
    Supabase.initialize(
      url: 'https://mawzoznhibuhrvxxyvtt.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hd3pvem5oaWJ1aHJ2eHh5dnR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTMzNDQwMTQsImV4cCI6MjAyODkyMDAxNH0.bSTbMeFthbBlWbGlX7XAh5Romh2l8-Cptv-gRC2dX70',
    ),
    Future(() async {
      sharedPreferences = await SharedPreferences.getInstance();
    })
  ).wait;
  const app = MyApp();
  final scope = ProviderScope(overrides: [
    sharedPreferencesRepositoryProvider.overrideWithValue(SharedPreferencesRepository(sharedPreferences)),
  ], child: app);
  runApp(scope);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'InterTight',
        colorScheme: myColorTheme,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: myRouter(),
    );
  }
}
