import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/view_model/account_page_view_model.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/custom_list_content.dart';
import 'package:membo/widgets/custom_snackbar.dart';
import 'package:membo/widgets/error_dialog.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nameTextController = useTextEditingController();
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final accountPageState = ref.watch(accountPageViewModelProvider);

    Future<void> handleSubmitName(
        String name, BuildContext dialogContext) async {
      try {
        await ref
            .read(accountPageViewModelProvider.notifier)
            .updateUserName(name);

        if (context.mounted) {
          Navigator.pop(dialogContext);
          Future.delayed(const Duration(milliseconds: 300), () {
            CustomSnackBar.show(context, 'Name updated', MyColor.blue);
          });
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(dialogContext);

          Future.delayed(const Duration(milliseconds: 300), () {
            CustomSnackBar.show(
                context, 'Name update Error', Colors.red.shade400);
          });
        }
      }
    }

    Future<void> handleTapNameEdit() async {
      nameTextController.text = accountPageState.user!.userName;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Edit Name', style: lightTextTheme.titleLarge!),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: lightTextTheme.bodyLarge,
                  autofocus: true,
                  controller: nameTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    } else if (value.length > 8) {
                      return 'Name cannot be longer than 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          handleSubmitName(nameTextController.text, context);
                        }
                      },
                      child: const Text('Save')),
                )
              ],
            ),
          ),
        ),
      );
    }

    Future<void> handleTapEditAvatar() async {
      try {
        await ref.read(accountPageViewModelProvider.notifier).updateAvatar();
        if (context.mounted) {
          CustomSnackBar.show(context, 'Avatar updated', MyColor.blue);
        }
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, 'Error handleTapEditAvatar : $e');
        }
      }
    }

    void handleTapSignOut() {
      ref.read(supabaseAuthRepositoryProvider).signOut();
    }

    Future<void> handleDeleteAccount() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Account', style: lightTextTheme.titleLarge!),
          content: Text('Are you sure you want to delete your account?',
              style: lightTextTheme.bodyLarge),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: MyColor.red),
              onPressed: () async {
                if (accountPageState.user == null) return;
                try {
                  await ref
                      .read(supabaseAuthRepositoryProvider)
                      .deleteAccount(accountPageState.user!.userId);
                  if (context.mounted) {
                    CustomSnackBar.show(
                        context, 'Account deleted', MyColor.blue);
                    context.go('/sign-in');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ErrorDialog.show(context, 'Error deleting account');
                  }
                }
              },
              child: Text('Delete',
                  style:
                      lightTextTheme.bodyLarge!.copyWith(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: lightTextTheme.bodyLarge),
            ),
          ],
        ),
      );
    }

    void initialize() {
      ref.read(accountPageViewModelProvider.notifier).initializeLoad();
    }

    useEffect(() {
      initialize();
      return null;
    }, []);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 36),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ),
        body: Stack(
          children: [
            BgPaint(width: w, height: h),
            SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 16.0),
                      child: Column(
                        children: [
                          accountPageState.isLoading
                              ? const Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(height: 200.0),
                                  ],
                                )
                              : Column(
                                  children: [
                                    const SizedBox(height: 30.0),
                                    _avatarImage(
                                        accountPageState.user!.avatarUrl,
                                        handleTapEditAvatar),
                                    const SizedBox(height: 30.0),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: MyColor.green,
                                        border: Border.all(
                                            color: MyColor.greenText, width: 2),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        accountPageState.user!.userType.type
                                            .toString()
                                            .split('.')[1]
                                            .toUpperCase(),
                                        style: lightTextTheme.bodyLarge,
                                      ),
                                    ),
                                    CustomListContent(
                                      title: 'Name',
                                      titleStyle: lightTextTheme.titleLarge!,
                                      backgroundColor: MyColor.greenLight,
                                      contentWidgets: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                accountPageState.user!.userName,
                                                style: lightTextTheme.bodyLarge,
                                              ),
                                            ),
                                            InkWell(
                                              child: const Icon(Icons.edit),
                                              onTap: () {
                                                handleTapNameEdit();
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                    CustomListContent(
                                      title: 'Owned Boards',
                                      titleStyle: lightTextTheme.titleLarge!,
                                      backgroundColor: MyColor.greenLight,
                                      contentWidgets: [
                                        Text(
                                          (accountPageState.user!.ownedBoardIds)
                                              .length
                                              .toString(),
                                          style: lightTextTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                    CustomListContent(
                                      title: 'Link Boards',
                                      titleStyle: lightTextTheme.titleLarge!,
                                      backgroundColor: MyColor.greenLight,
                                      contentWidgets: [
                                        Text(
                                          (accountPageState
                                                  .user!.linkedBoardIds)
                                              .length
                                              .toString(),
                                          style: lightTextTheme.bodyLarge,
                                        ),
                                      ],
                                    ),

                                    /// subscription features
                                    ///
                                    // accountPageState.user!.userType.type ==
                                    //         UserTypes.free
                                    //     ? CustomButton(
                                    //         width: double.infinity,
                                    //         height: 50,
                                    //         color: MyColor.blue,
                                    //         onTap: null,
                                    //         child: Center(
                                    //             child: Text('Upgrade to Pro',
                                    //                 style: lightTextTheme
                                    //                     .titleLarge!
                                    //                     .copyWith(
                                    //                         color: MyColor
                                    //                             .greenSuperLight))),
                                    //       )
                                    //     : const SizedBox(),
                                    const SizedBox(height: 36.0),
                                  ],
                                ),
                          CustomButton(
                            width: double.infinity,
                            height: 50,
                            color: MyColor.pink,
                            child: Center(
                                child: Text('Sign out',
                                    style: lightTextTheme.titleLarge)),
                            onTap: () {
                              handleTapSignOut();
                            },
                          ),
                          const SizedBox(height: 32.0),
                          accountPageState.user == null
                              ? const SizedBox.shrink()
                              : CustomButton(
                                  width: double.infinity,
                                  height: 50,
                                  color: MyColor.red,
                                  child: Center(
                                      child: Text('Delete Account',
                                          style: lightTextTheme.titleLarge!
                                              .copyWith(color: Colors.white))),
                                  onTap: () async {
                                    handleDeleteAccount();
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

  Widget _avatarImage(String? avatarUrl, Function() handleTapEditAvatar) {
    const double avatarSize = 120;
    return SizedBox(
      width: avatarSize + 60,
      height: avatarSize,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                handleTapEditAvatar();
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: MyColor.greenDark,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: MyColor.greenSuperLight),
              ),
            ),
          ),
          Align(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize / 2),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: const BoxDecoration(
                  color: MyColor.greenLight,
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  avatarUrl ?? '',
                  width: avatarSize,
                  height: avatarSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _defaultAvatar(avatarSize, color: MyColor.lightRed),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _defaultAvatar(double avatarSize, {Color? color}) {
    return CircleAvatar(
      backgroundColor: color ?? MyColor.greenDark,
      radius: avatarSize / 2,
      child: const Icon(Icons.person, size: 70),
    );
  }
}
