import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:membo/gen/assets.gen.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/custom_button.dart';
import 'package:membo/widgets/error_dialog.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color googleColor = Color.fromARGB(255, 127, 210, 227);
    const Color appleColor = Color.fromARGB(255, 247, 189, 144);
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

    useEffect(() {
      return null;
    }, [user]);

    return Stack(
      children: [
        BgPaint(width: w, height: h),
        Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            bottom: false,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: -100,
                  left: -100,
                  child: Lottie.asset(
                    'assets/lotties/test.json', // 'assets/lotties/hello.json
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Stack(
                        children: [
                          Align(
                            alignment: const Alignment(0.5, -0.95),
                            child: Lottie.asset(
                              Assets.lotties.hello,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CustomButton(
                              width: 300,
                              height: 60,
                              color: googleColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70,
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
                                animationController.reset();

                                shutterColor.value = googleColor;
                                animationController.forward();
                                try {
                                  await ref
                                      .read(supabaseAuthRepositoryProvider)
                                      .signInWithGoogle();
                                } catch (e) {
                                  if (context.mounted) {
                                    ErrorDialog.show(context,
                                        'Error signing in with Google');
                                  }
                                }
                                animationController.reverse();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    CustomButton(
                      width: 300,
                      height: 60,
                      color: appleColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 70,
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
                      onTap: () async {
                        animationController.reset();

                        shutterColor.value = appleColor;
                        animationController.forward();

                        try {
                          await ref
                              .read(supabaseAuthRepositoryProvider)
                              .signInWithApple();
                        } catch (e) {
                          if (context.mounted) {
                            ErrorDialog.show(
                                context, 'Error signing in with Apple');
                          }
                        }
                        animationController.reverse();
                      },
                    ),
                  ],
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
                Align(
                    alignment: const Alignment(0, 0.9),
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/');
                      },
                      child: const Text('test'),
                    )),
              ],
            ),
          ),
        ),
      ],
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

    double waveHeight = height / 5;

    if (isLeft) {
      path.moveTo(0, 0);
      path.lineTo(width / 2, 0);
      for (int i = 0; i < 5; i++) {
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
      for (int i = 0; i < 5; i++) {
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
