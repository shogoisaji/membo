import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/gen/assets.gen.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color googleColor = MyColor.superLightBlue;
    const Color appleColor = MyColor.lightYellow;
    final shutterColor = useState<Color>(googleColor);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInQuart,
    );

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    Future<void> policyURL() async {
      final Uri url = Uri.parse('https://membo.vercel.app/privacy-policy');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ErrorDialog.show(context, 'Could not launch $url');
        }
      }
    }

    Future<void> termsURL() async {
      final Uri url = Uri.parse('https://membo.vercel.app/terms-of-service');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ErrorDialog.show(context, 'Could not launch $url');
        }
      }
    }

    void handleSignInWithGoogle() async {
      animationController.reset();

      shutterColor.value = googleColor;
      animationController.forward();

      try {
        await ref.read(supabaseAuthRepositoryProvider).signInWithGoogle();
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, 'Error signing in with Google');
        }
      }
      animationController.reverse();
    }

    void handleSignInWithApple() async {
      animationController.reset();

      shutterColor.value = appleColor;
      animationController.forward();

      try {
        await ref.read(supabaseAuthRepositoryProvider).signInWithApple();
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, 'Error signing in with Apple',
              onTapFunction: () {
            context.go('/sign-in');
          });
        }
      }
      animationController.reverse();
    }

    void handleSignInWithEmail() async {
      if (formKey.currentState!.validate()) {
        try {
          await ref
              .read(supabaseAuthRepositoryProvider)
              .signInWithEmail(emailController.text, passwordController.text);
        } catch (e) {
          if (context.mounted) {
            ErrorDialog.show(context, 'Error signing in with Email');
          }
        }
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(),
        body: Stack(
          // fit: StackFit.expand,
          children: [
            BgPaint(width: w, height: h),
            SafeArea(
              child: Align(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          'assets/images/svg/title.svg',
                          // width: 100,
                          fit: BoxFit.fitHeight,
                          height: 100 * h / 1300,
                          colorFilter: const ColorFilter.mode(
                              MyColor.greenText, BlendMode.srcIn),
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
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
                                      borderSide:
                                          BorderSide(color: MyColor.greenText),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: MyColor.greenText),
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
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text('パスワード',
                                    style: lightTextTheme.bodyMedium),
                              ),
                              TextFormField(
                                focusNode: passwordFocusNode,
                                controller: passwordController,
                                style: lightTextTheme.bodyMedium,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    counterText: '',
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: MyColor.greenText),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: MyColor.greenText),
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
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              CustomButton(
                                width: 300,
                                height: 55,
                                color: const Color.fromARGB(255, 84, 85, 103),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 14),
                                        child: SvgPicture.asset(
                                            'assets/images/svg/email.svg',
                                            width: 30,
                                            height: 30,
                                            colorFilter: const ColorFilter.mode(
                                                MyColor.greenSuperLight,
                                                BlendMode.srcIn)),
                                      ),
                                      Text('Sign In with Email',
                                          style: lightTextTheme.bodyLarge!
                                              .copyWith(
                                            color: MyColor.greenSuperLight,
                                          )),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  handleSignInWithEmail();
                                },
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () => context.push('/sign-up'),
                                child: Center(
                                    child: Text('新規登録',
                                        style:
                                            lightTextTheme.bodyLarge!.copyWith(
                                          color: MyColor.greenText,
                                        ))),
                              ),
                            ],
                          ),
                        ),

                        /// divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 2,
                                color: MyColor.greenText,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'or',
                              style: lightTextTheme.titleMedium,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 2,
                                color: MyColor.greenText,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomButton(
                              width: 300,
                              height: 55,
                              color: googleColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 14),
                                    child: SvgPicture.asset(
                                      Assets.images.icons.googleOfficialSvg,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                  Text('Sign In with Google',
                                      style: lightTextTheme.bodyLarge),
                                ],
                              ),
                              onTap: () async {
                                handleSignInWithGoogle();
                              },
                            ),
                            const SizedBox(height: 30),
                            CustomButton(
                              width: 300,
                              height: 55,
                              color: appleColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 14),
                                    child: SvgPicture.asset(
                                      Assets.images.icons.appleOfficialSvg,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                  Text('Sign In with Apple',
                                      style: lightTextTheme.bodyLarge),
                                ],
                              ),
                              onTap: () {
                                handleSignInWithApple();
                              },
                            ),
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: lightTextTheme.bodySmall,
                                      children: [
                                        TextSpan(
                                          text: '利用規約',
                                          style: lightTextTheme.bodySmall!
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 44, 87, 206),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              await termsURL();
                                            },
                                        ),
                                        const TextSpan(text: ' と '),
                                        TextSpan(
                                          text: 'プライバシーポリシー',
                                          style: lightTextTheme.bodySmall!
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 44, 87, 206),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              await policyURL();
                                            },
                                        ),
                                        const TextSpan(
                                            text: 'に同意してサインインをお願いします'),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: animation,
              builder: (context, _) => IgnorePointer(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      bottom: 0,
                      left: w / 2 * (animation.value - 1) * 1.1,
                      child: CustomPaint(
                        size: Size(w, h),
                        painter: BgCustomPainter(shutterColor.value, true),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: w / 2 * (1 - animation.value) * 1.1,
                      child: CustomPaint(
                        size: Size(w, h),
                        painter: BgCustomPainter(shutterColor.value, false),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailSignUpModal extends HookConsumerWidget {
  const EmailSignUpModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordFirstController = useTextEditingController();
    final passwordSecondController = useTextEditingController();
    final emailFocusNode = useFocusNode();
    final passwordFirstFocusNode = useFocusNode();
    final passwordSecondFocusNode = useFocusNode();
    final w = MediaQuery.sizeOf(context).width;

    void handleSubmitEmail() {
      if (formKey.currentState!.validate()) {
        // ref.read(supabaseAuthRepositoryProvider).signUpWithEmail(
        //     emailController.text, passwordFirstController.text);
      }
    }

    useEffect(() {
      return;
    }, []);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: w.clamp(300, 500),
        height: 400 + MediaQuery.of(context).viewInsets.bottom,
        padding: const EdgeInsets.all(16.0),
        color: MyColor.greenLight,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Text('新規登録', style: lightTextTheme.titleLarge),
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('メールアドレス', style: lightTextTheme.bodyMedium),
              ),
              TextFormField(
                // autofocus: true,
                focusNode: emailFocusNode,
                controller: emailController,
                style: lightTextTheme.bodyMedium,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    counterText: '',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: MyColor.greenText),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: MyColor.greenText),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '入力欄が空欄です';
                  } else if (!value.contains('@') || !value.contains('.')) {
                    return 'メールアドレスの形式が正しくありません';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('パスワード', style: lightTextTheme.bodyMedium),
              ),
              TextFormField(
                // autofocus: true,
                focusNode: passwordFirstFocusNode,
                controller: passwordFirstController,
                style: lightTextTheme.bodyMedium,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    counterText: '',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: MyColor.greenText),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: MyColor.greenText),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '入力欄が空欄です';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('パスワード確認', style: lightTextTheme.bodyMedium),
              ),
              TextFormField(
                // autofocus: true,
                focusNode: passwordSecondFocusNode,
                controller: passwordSecondController,
                style: lightTextTheme.bodyMedium,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    counterText: '',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: MyColor.greenText),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: MyColor.greenText),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: MyColor.red),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '入力欄が空欄です';
                  } else if (value != passwordFirstController.text) {
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
                    child: Text('新規登録',
                        style: lightTextTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ))),
                onTap: () {
                  context.go('/sign-up');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BgCustomPainter extends CustomPainter {
  final Color color;
  final bool isLeft;
  BgCustomPainter(this.color, this.isLeft);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final path = Path();
    double width = size.width;
    double height = size.height;

    double waveHeight = height / 4;

    if (isLeft) {
      path.moveTo(0, 0);
      path.lineTo(width / 2, 0);
      for (int i = 0; i < 4; i++) {
        double x = width / 2;
        double startY = waveHeight * i;
        double endY = waveHeight * (i + 1);
        double ctrlX1 = x - 30;
        double ctrlY1 = startY + waveHeight / 4;
        double midY = startY + waveHeight / 2;
        double ctrlX2 = x + 30;
        double ctrlY2 = startY + 3 * waveHeight / 4;

        path.quadraticBezierTo(ctrlX1, ctrlY1, x, midY);
        path.quadraticBezierTo(ctrlX2, ctrlY2, x, endY);
      }
      path.lineTo(width / 2, height);
      path.lineTo(0, height);
      path.close();
    } else {
      path.moveTo(width, 0);
      path.lineTo(width / 2, 0);
      for (int i = 0; i < 4; i++) {
        double x = width / 2;
        double startY = waveHeight * i;
        double endY = waveHeight * (i + 1);
        double ctrlX1 = x - 30;
        double ctrlY1 = startY + waveHeight / 4;
        double midY = startY + waveHeight / 2;
        double ctrlX2 = x + 30;
        double ctrlY2 = startY + 3 * waveHeight / 4;

        path.quadraticBezierTo(ctrlX1, ctrlY1, x, midY);
        path.quadraticBezierTo(ctrlX2, ctrlY2, x, endY);
      }
      path.lineTo(width / 2, height);
      path.lineTo(width, height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BgCustomPainter oldDelegate) {
    return false;
  }
}
