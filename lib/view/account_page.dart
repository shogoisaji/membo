import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:membo/widgets/two_way_dialog.dart';

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
            CustomSnackBar.show(context, '名前を更新しました', MyColor.lightBlue);
          });
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(dialogContext);

          Future.delayed(const Duration(milliseconds: 300), () {
            CustomSnackBar.show(context, '名前の更新に失敗しました', Colors.red.shade400);
          });
        }
      }
    }

    Future<void> handleTapNameEdit() async {
      nameTextController.text = '';
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('名前の編集', style: lightTextTheme.titleLarge!),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: lightTextTheme.bodyLarge,
                  autofocus: true,
                  controller: nameTextController,
                  decoration: const InputDecoration(
                    hintText: '8文字以下',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '入力欄が空です';
                    } else if (value.length > 8) {
                      return '8文字以下です';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.greenText,
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await handleSubmitName(
                              nameTextController.text, context);
                        }
                      },
                      child: Text('保存',
                          style: lightTextTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ))),
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
          CustomSnackBar.show(context, 'アバターが更新されました', MyColor.lightBlue);
        }
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, 'アバターの更新に失敗しました');
        }
      }
    }

    void handleTapSignOut(BuildContext context) {
      showDialog(
          context: context,
          builder: (dialogContext) => TwoWayDialog(
                icon: SvgPicture.asset('assets/images/svg/circle-question.svg',
                    width: 36,
                    height: 36,
                    colorFilter: const ColorFilter.mode(
                        MyColor.greenText, BlendMode.srcIn)),
                title: 'ログアウトしますか？',
                leftButtonText: 'ログアウト',
                rightButtonText: 'キャンセル',
                onLeftButtonPressed: () async {
                  Navigator.of(dialogContext).pop();
                  ref.read(supabaseAuthRepositoryProvider).signOut();
                },
                onRightButtonPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ));
    }

    Future<void> handleDeleteAccount() async {
      showDialog(
        context: context,
        builder: (dialogContext) => TwoWayDialog(
          icon: SvgPicture.asset('assets/images/svg/circle-question.svg',
              width: 36,
              height: 36,
              colorFilter:
                  const ColorFilter.mode(MyColor.greenText, BlendMode.srcIn)),
          title: 'アカウントの削除',
          content: '本当にこのアカウントを削除しますか?',
          leftButtonText: '削除',
          rightButtonText: 'キャンセル',
          onLeftButtonPressed: () async {
            Navigator.of(dialogContext).pop();
            if (accountPageState.user == null) return;
            try {
              await ref
                  .read(accountPageViewModelProvider.notifier)
                  .deleteAccount();

              if (context.mounted) {
                CustomSnackBar.show(context, 'アカウントを削除しました', MyColor.lightBlue);
                context.go('/sign-in');
              }
            } catch (e) {
              if (context.mounted) {
                ErrorDialog.show(context, 'アカウントの削除に失敗しました');
              }
            }
          },
          onRightButtonPressed: () {
            Navigator.of(dialogContext).pop();
          },
        ),
      );
    }

    Future<void> initialize() async {
      try {
        await ref
            .read(accountPageViewModelProvider.notifier)
            .initializeLoad()
            .timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            ErrorDialog.show(context, '通信状況を確認してください', onTapFunction: () {
              context.go('/sign-in');
            });
          },
        );
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, '通信状況を確認してください');
        }
      }
    }

    useEffect(() {
      initialize();
      return null;
    }, []);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('アカウント', style: lightTextTheme.titleLarge),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 36),
            onPressed: () {
              if (accountPageState.user!.userName == '') {
                ErrorDialog.show(context, '名前を入力してください');
                return;
              }
              HapticFeedback.lightImpact();
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
                                    const SizedBox(height: 10.0),
                                    _avatarImage(
                                        accountPageState.user!.avatarUrl,
                                        handleTapEditAvatar),
                                    const SizedBox(height: 30.0),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: MyColor.greenDark,
                                        // border: Border.all(
                                        //     color: MyColor.greenText, width: 2),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        accountPageState
                                            .user!.membershipType.type
                                            .toString()
                                            .split('.')[1]
                                            .toUpperCase(),
                                        style:
                                            lightTextTheme.bodyLarge!.copyWith(
                                          color: MyColor.greenSuperLight,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Text(
                                        '※名前、アバターは公開されます',
                                        style: lightTextTheme.bodySmall,
                                      ),
                                    ),
                                    CustomListContent(
                                      title: '名前',
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
                                              child: const CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      MyColor.greenDark,
                                                  child: Icon(Icons.edit)),
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                handleTapNameEdit();
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                    CustomListContent(
                                      title: 'マイボード',
                                      titleStyle: lightTextTheme.titleLarge!,
                                      backgroundColor: MyColor.greenLight,
                                      contentWidgets: [
                                        Text(
                                          '${accountPageState.user!.ownedBoardIds.length} / ${accountPageState.user!.membershipType.maxBoardCount}',
                                          style: lightTextTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(height: 20.0),
                                    // CustomListContent(
                                    //   title: 'リンクボード',
                                    //   titleStyle: lightTextTheme.titleLarge!,
                                    //   backgroundColor: MyColor.greenLight,
                                    //   contentWidgets: [
                                    //     Text(
                                    //       'coming soon',
                                    //       style: lightTextTheme.bodyLarge,
                                    //     ),
                                    //   ],
                                    // ),

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
                                child: Text('ログアウト',
                                    style: lightTextTheme.titleLarge)),
                            onTap: () {
                              handleTapSignOut(context);
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
                                      child: Text('アカウント削除',
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
                HapticFeedback.lightImpact();
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
            child: CircleAvatar(
              radius: avatarSize / 2,
              foregroundImage: NetworkImage(
                avatarUrl ?? '',
              ),
              child: const Icon(Icons.person, size: 70),
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
