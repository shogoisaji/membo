import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Settings Page', style: lightTextTheme.titleLarge),
            ElevatedButton(
                onPressed: () {
                  context.go('/sign-in');
                  ref.read(supabaseAuthRepositoryProvider).signOut();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColor.greenLight,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: Text('Sign Out', style: lightTextTheme.bodyLarge)),
          ],
        ),
      ),
    );
  }
}
