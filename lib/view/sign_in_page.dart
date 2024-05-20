import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/gen/assets.gen.dart';
import 'package:membo/models/notice/public_notices_model.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
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
    final noticeData = useState<PublicNoticesModel?>(null);

    Future<void> fetchPublicNotices() async {
      try {
        noticeData.value =
            await ref.read(supabaseRepositoryProvider).fetchPublicNotices();
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, '通信状況を確認してください', onTapFunction: () {
            Future.delayed(const Duration(seconds: 2), () {
              fetchPublicNotices();
            });
          });
        }
      }
    }

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

    const Color googleColor = MyColor.superLightBlue;
    const Color appleColor = MyColor.lightYellow;
    final shutterColor = useState<Color>(googleColor);
    final user = ref.watch(userStateProvider);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInQuart,
    );

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

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

    useEffect(() {
      fetchPublicNotices();
      return null;
    }, [user]);

    return Stack(
      children: [
        BgPaint(width: w, height: h),
        noticeData.value == null
            ? const SizedBox.shrink()
            : Scaffold(
                // appBar: AppBar(),
                body: noticeData.value!.noticeCode != 100
                    ? NoticeDialog(onTap: () {
                        fetchPublicNotices();
                      })
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: SvgPicture.asset(
                                    'assets/images/svg/title.svg',
                                    width: 100,
                                    height: 100,
                                    colorFilter: const ColorFilter.mode(
                                        MyColor.greenDark, BlendMode.srcIn),
                                  ),
                                ),
                                Column(
                                  children: [
                                    CustomButton(
                                      width: 300,
                                      height: 60,
                                      color: googleColor,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 14),
                                            child: SvgPicture.asset(
                                              Assets.images.icons
                                                  .googleOfficialSvg,
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
                                    const SizedBox(height: 45),
                                    CustomButton(
                                      width: 300,
                                      height: 60,
                                      color: appleColor,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 14),
                                            child: SvgPicture.asset(
                                              Assets.images.icons
                                                  .appleOfficialSvg,
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
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 300,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style:
                                                      lightTextTheme.bodySmall,
                                                  children: [
                                                    TextSpan(
                                                      text: '利用規約',
                                                      style: lightTextTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 44, 87, 206),
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () async {
                                                              await termsURL();
                                                            },
                                                    ),
                                                    const TextSpan(text: ' と '),
                                                    TextSpan(
                                                      text: 'プライバシーポリシー',
                                                      style: lightTextTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 44, 87, 206),
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () async {
                                                              await policyURL();
                                                            },
                                                    ),
                                                    const TextSpan(
                                                        text:
                                                            'に同意してサインインをお願いします'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                                      painter: BgCustomPainter(
                                          shutterColor.value, true),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: w / 2 * (1 - animation.value) * 1.1,
                                    child: CustomPaint(
                                      size: Size(w, h),
                                      painter: BgCustomPainter(
                                          shutterColor.value, false),
                                    ),
                                  ),
                                ],
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

class NoticeDialog extends HookWidget {
  final Function onTap;
  const NoticeDialog({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final isReload = useState(false);
    return Container(
        width: w,
        height: h,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            decoration: BoxDecoration(
              color: MyColor.greenLight,
              border: Border.all(
                  width: 5,
                  color: MyColor.greenText,
                  strokeAlign: BorderSide.strokeAlignCenter),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 5),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/svg/circle-exclamation.svg',
                      colorFilter: const ColorFilter.mode(
                          MyColor.greenText, BlendMode.srcIn),
                      width: 36,
                      height: 36,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                Text(
                  'メンテナンス中',
                  style: lightTextTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onTap();
                      isReload.value = true;
                      Future.delayed(const Duration(seconds: 2), () {
                        isReload.value = false;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: MyColor.greenText,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                          child: isReload.value
                              ? const CircularProgressIndicator(
                                  strokeWidth: 3, color: Colors.white)
                              : Text('リロード',
                                  style: lightTextTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                  ))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
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
