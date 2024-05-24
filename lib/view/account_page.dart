import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/exceptions/app_exception.dart';
import 'package:membo/gen/assets.gen.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/utils/custom_indicator.dart';
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
    final isLoading = useState(true);

    Future<void> initialize() async {
      try {
        await ref
            .read(accountPageViewModelProvider.notifier)
            .initializeLoad()
            .timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            showDialog(
              context: context,
              builder: (dialogContext) => TwoWayDialog(
                title: '通信状況を確認してください',
                leftButtonText: 'サインアウト',
                rightButtonText: 'リロード',
                onLeftButtonPressed: () {
                  ref.read(supabaseAuthRepositoryProvider).signOut();
                  context.go('/sign-in');
                },
                onRightButtonPressed: () {
                  initialize();
                },
              ),
            );
          },
        );
      } catch (e) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (dialogContext) => TwoWayDialog(
              title: 'データ取得に失敗しました',
              leftButtonText: 'サインアウト',
              rightButtonText: 'リロード',
              onLeftButtonPressed: () {
                ref.read(supabaseAuthRepositoryProvider).signOut();
                context.go('/sign-in');
              },
              onRightButtonPressed: () {
                initialize();
              },
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

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
                  style: lightTextTheme.bodyMedium,
                  autofocus: true,
                  controller: nameTextController,
                  decoration: const InputDecoration(
                    hintText: '8文字以下',
                    hintStyle: TextStyle(color: Colors.grey),
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

    Future<void> handleTapSelectAvatar() async {
      try {
        await ref.read(accountPageViewModelProvider.notifier).selectAvatar();
      } on AppException catch (e) {
        /// イメージを選択しなかった場合
        if (e.type == AppExceptionType.notFound) {
          return;
        }
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, 'アバターの更新に失敗しました');
        }
      }
    }

    void handleAvatarCancel() {
      ref.read(accountPageViewModelProvider.notifier).clearTempAvatar();
    }

    void handleAvatarSave() async {
      isLoading.value = true;
      try {
        await ref.read(accountPageViewModelProvider.notifier).saveAvatar();
        if (context.mounted) {
          CustomSnackBar.show(context, 'アバターを更新しました', MyColor.lightBlue);
        }
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, 'アバターの更新に失敗しました');
        }
      } finally {
        isLoading.value = false;
      }
    }

    void handleTapSignOut(BuildContext context) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (dialogContext) => TwoWayDialog(
                icon: SvgPicture.asset(Assets.images.svg.circleQuestion,
                    width: 36,
                    height: 36,
                    colorFilter: const ColorFilter.mode(
                        MyColor.greenText, BlendMode.srcIn)),
                title: 'ログアウトしますか？',
                leftButtonText: 'ログアウト',
                rightButtonText: 'キャンセル',
                onLeftButtonPressed: () async {
                  isLoading.value = true;
                  try {
                    await ref.read(supabaseAuthRepositoryProvider).signOut();
                    if (context.mounted) {
                      if (!context.mounted) return;
                      context.go('/');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ErrorDialog.show(context, 'ログアウトに失敗しました');
                    }
                  } finally {
                    isLoading.value = false;
                  }
                },
                onRightButtonPressed: () {},
              ));
    }

    Future<void> handleDeleteAccount() async {
      showDialog(
        context: context,
        builder: (dialogContext) => TwoWayDialog(
          icon: SvgPicture.asset(Assets.images.svg.circleQuestion,
              width: 36,
              height: 36,
              colorFilter:
                  const ColorFilter.mode(MyColor.greenText, BlendMode.srcIn)),
          title: 'アカウントの削除',
          content: '本当にこのアカウントを削除しますか?',
          leftButtonText: '削除',
          rightButtonText: 'キャンセル',
          onLeftButtonPressed: () async {
            if (accountPageState.user == null) return;
            isLoading.value = true;
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
            } finally {
              isLoading.value = false;
            }
          },
          onRightButtonPressed: () {},
        ),
      );
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
            isLoading.value
                ? SizedBox(
                    width: w,
                    height: h,
                    child: const Center(child: CustomIndicator()),
                  )
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 16.0),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 10.0),
                                    _avatarImage(
                                        accountPageState.user!.avatarUrl,
                                        handleTapSelectAvatar),
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
                                                style: lightTextTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        color: Colors.white))),
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
            accountPageState.tempAvatar != null
                ? TempAvatarDisplay(
                    tempAvatar: accountPageState.tempAvatar!,
                    onTapCancel: () {
                      handleAvatarCancel();
                    },
                    onTapSave: () {
                      handleAvatarSave();
                    },
                  )
                : const SizedBox.shrink(),
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

class TempAvatarDisplay extends HookWidget {
  final XFile tempAvatar;
  final Function onTapCancel;
  final Function onTapSave;
  final double avatarSize = 120;
  const TempAvatarDisplay(
      {super.key,
      required this.tempAvatar,
      required this.onTapCancel,
      required this.onTapSave});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    )..forward();

    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    0.0,
                    1
                    // animation.value,
                  ],
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.6 * animation.value),
                  ]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 1.4 + 0.3 * (animation.value),
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    radius: avatarSize / 2,
                    foregroundImage: FileImage(
                      File(tempAvatar.path),
                    ),
                    child: const Icon(Icons.person, size: 70),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'この画像を保存しますか？',
                  style: lightTextTheme.bodyLarge!.copyWith(
                    color: MyColor.greenSuperLight,
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        backgroundColor: MyColor.greenLight),
                    onPressed: () {
                      onTapSave();
                    },
                    child: Text('保存', style: lightTextTheme.bodyLarge)),
                const SizedBox(height: 20.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        backgroundColor: MyColor.lightRed),
                    onPressed: () {
                      onTapCancel();
                    },
                    child: Text('キャンセル',
                        style: lightTextTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ))),
              ],
            ),
          );
        });
  }
}
