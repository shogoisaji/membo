import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/supabase/db/supabase_repository.dart';
import 'package:membo/view_model/account_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/custom_list_content.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final accountPageState = ref.watch(accountPageViewModelProvider);

    void fetchUser() async {
      final signedInUser = ref.read(userStateProvider);
      if (signedInUser == null) return;
      final user = await ref
          .read(supabaseRepositoryProvider)
          .fetchUserData(signedInUser.id);
      if (user == null) return;
      ref.read(accountPageViewModelProvider.notifier).getUser(user);
    }

    useEffect(() {
      fetchUser();
      return null;
    }, []);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ),
        body: accountPageState.user == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  BgPaint(width: w, height: h),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 16.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 30.0),
                                _avatarImage(accountPageState.user!.avatarUrl),
                                CustomListContent(
                                  title: 'Name',
                                  titleStyle: lightTextTheme.titleLarge!,
                                  backgroundColor: MyColor.greenLight,
                                  contentWidgets: [
                                    Text(
                                      accountPageState.user!.userName,
                                      style: lightTextTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                CustomListContent(
                                  title: 'Owned Board',
                                  titleStyle: lightTextTheme.titleLarge!,
                                  backgroundColor: MyColor.greenLight,
                                  contentWidgets: [
                                    Text(
                                      accountPageState
                                          .user!.ownedBoardsId.length
                                          .toString(),
                                      style: lightTextTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 26.0),
                                CustomButton(
                                  width: double.infinity,
                                  height: 50,
                                  color: MyColor.pink,
                                  child: Center(
                                      child: Text('Sign out',
                                          style: lightTextTheme.titleLarge)),
                                  onTap: () {
                                    ref
                                        .read(supabaseAuthRepositoryProvider)
                                        .signOut();
                                  },
                                ),
                                const SizedBox(height: 100.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  Widget _avatarImage(String? avatarUrl) {
    return avatarUrl == null
        ? const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: avatarUrl,
              width: 100,
              height: 100,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) =>
                  const ColoredBox(color: Colors.white),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/sky.jpg'),
            ),
          );
  }
}
