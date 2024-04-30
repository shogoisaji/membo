import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page', style: lightTextTheme.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Settings Page',
                style: TextStyle(color: Colors.green, fontSize: 40)),
            ElevatedButton(
                onPressed: () {
                  context.go('/sign-in');
                  ref.read(supabaseAuthRepositoryProvider).signOut();
                },
                child: const Text('Go Sign Out')),
          ],
        ),
      ),
    );
  }
}
