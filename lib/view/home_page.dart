import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/widgets/bg_paint.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: MyColor.pink,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(supabaseAuthRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
              alignment: const Alignment(0, -0.2),
              child: Container(
                decoration: BoxDecoration(
                  color: MyColor.greenSuperLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 10,
                    color: MyColor.greenDark,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(1, 2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                width: 300,
                height: 300,
              )),
        ],
      ),
    );
  }
}
