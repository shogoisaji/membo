import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/custom_snackbar.dart';
import 'package:membo/widgets/error_dialog.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordFirstController = useTextEditingController();
    final passwordSecondController = useTextEditingController();
    final emailFocusNode = useFocusNode();
    final passwordFirstFocusNode = useFocusNode();
    final passwordSecondFocusNode = useFocusNode();

    final isLoading = useState(false);

    void handleSubmitEmail() async {
      if (formKey.currentState!.validate()) {
        try {
          isLoading.value = true;
          await ref.read(supabaseAuthRepositoryProvider).signUpWithEmail(
              emailController.text, passwordFirstController.text);
          if (context.mounted) {
            CustomSnackBar.show(context, '確認メールを送信しました', MyColor.blue);
            context.go('/sigh-in');
          }
        } catch (e) {
          if (context.mounted) {
            ErrorDialog.show(context, 'Error signing up with Email');
            print(e);
          }
        } finally {
          isLoading.value = false;
        }
      }
    }

    return Stack(
      children: [
        BgPaint(width: w, height: h),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back, size: 36),
              ),
            ),
            body: isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          constraints: const BoxConstraints(
                            maxWidth: 300,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Text('新規登録',
                                      style: lightTextTheme.titleLarge),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text('メールアドレス',
                                      style: lightTextTheme.bodyMedium),
                                ),
                                TextFormField(
                                  // autofocus: true,
                                  focusNode: emailFocusNode,
                                  controller: emailController,
                                  style: lightTextTheme.bodyMedium,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      counterText: '',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide: BorderSide(
                                            color: MyColor.greenText),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide: BorderSide(
                                            color: MyColor.greenText),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide:
                                            BorderSide(color: MyColor.red),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide:
                                            BorderSide(color: MyColor.red),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '入力欄が空欄です';
                                    } else if (!value.contains('@') ||
                                        !value.contains('.')) {
                                      return 'メールアドレスの形式が正しくありません';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('パスワード',
                                        style: lightTextTheme.bodyMedium),
                                    Text('6文字以上',
                                        style: lightTextTheme.bodySmall),
                                  ],
                                ),
                                TextFormField(
                                  // autofocus: true,
                                  focusNode: passwordFirstFocusNode,
                                  controller: passwordFirstController,
                                  style: lightTextTheme.bodyMedium,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      counterText: '',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide: BorderSide(
                                            color: MyColor.greenText),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide: BorderSide(
                                            color: MyColor.greenText),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide:
                                            BorderSide(color: MyColor.red),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide:
                                            BorderSide(color: MyColor.red),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '入力欄が空欄です';
                                    } else if (value.length < 6) {
                                      return '6文字以上で入力してください';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text('パスワード確認',
                                      style: lightTextTheme.bodyMedium),
                                ),
                                TextFormField(
                                  // autofocus: true,
                                  focusNode: passwordSecondFocusNode,
                                  controller: passwordSecondController,
                                  style: lightTextTheme.bodyMedium,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      counterText: '',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide: BorderSide(
                                            color: MyColor.greenText),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide: BorderSide(
                                            color: MyColor.greenText),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide:
                                            BorderSide(color: MyColor.red),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide:
                                            BorderSide(color: MyColor.red),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '入力欄が空欄です';
                                    } else if (value !=
                                        passwordFirstController.text) {
                                      return 'パスワードが一致しません';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  width: 100,
                                  height: 40,
                                  color: MyColor.blue,
                                  child: Center(
                                      child: Text('登録',
                                          style: lightTextTheme.bodyLarge!
                                              .copyWith(
                                            color: Colors.white,
                                          ))),
                                  onTap: () {
                                    handleSubmitEmail();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
