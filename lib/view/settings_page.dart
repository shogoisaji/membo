import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/widgets/bg_paint.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(),
          body: Stack(
            children: [
              BgPaint(width: w, height: h),
              SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        Text('Settings Page', style: lightTextTheme.titleLarge),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                            onPressed: () {
                              // context.go('/sign-in');
                              ref
                                  .read(supabaseAuthRepositoryProvider)
                                  .signOut();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: MyColor.greenLight,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: Text('Sign Out',
                                style: lightTextTheme.bodyLarge)),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                            onPressed: () {
                              context.go('/account');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: MyColor.greenLight,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: Text('Account',
                                style: lightTextTheme.bodyLarge)),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                            onPressed: () {
                              context.go('/policy');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: MyColor.greenLight,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: Text('policy',
                                style: lightTextTheme.bodyLarge)),
                        const SizedBox(height: 100.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
