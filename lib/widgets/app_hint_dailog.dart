import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppHintDialog {
  static void show(BuildContext context, Function() onTap) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.3),
        context: context,
        builder: (context) => AppHintDialogWidget(onTap: onTap));
  }
}

class AppHintDialogWidget extends HookWidget {
  final Function() onTap;
  AppHintDialogWidget({super.key, required this.onTap});

  final List<Widget> pages = [
    Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/hint1.png', fit: BoxFit.fill),
      ],
    ),
    Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/hint2.png', fit: BoxFit.contain),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final currentSlideIndex = useState(0);
    final pageController = usePageController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageController.addListener(() {
          currentSlideIndex.value = pageController.page!.round();
        });
      });
      return null;
    }, []);

    return Dialog(
      child: Container(
        width: w * 0.8,
        decoration: BoxDecoration(
          color: MyColor.greenSuperLight,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(3, 3),
              blurRadius: 7,
              spreadRadius: 1,
            ),
          ],
        ),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  children: pages,
                ),
              ),
              AnimatedSmoothIndicator(
                activeIndex: currentSlideIndex.value,
                count: pages.length,
                effect: const WormEffect(
                  dotHeight: 16,
                  dotWidth: 16,
                  dotColor: MyColor.greenLight,
                  activeDotColor: MyColor.pink,
                  type: WormType.thinUnderground,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          onTap();
                          Navigator.pop(context);
                        },
                        child: Text('スキップ', style: lightTextTheme.bodyMedium)),
                    currentSlideIndex.value == pages.length - 1
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColor.greenDark,
                            ),
                            onPressed: () {
                              onTap();
                              Navigator.pop(context);
                            },
                            child: Text('完了',
                                style: lightTextTheme.bodyMedium!
                                    .copyWith(color: MyColor.greenSuperLight)))
                        : ElevatedButton(
                            onPressed: () {
                              pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            },
                            child:
                                Text('次へ', style: lightTextTheme.bodyMedium)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
