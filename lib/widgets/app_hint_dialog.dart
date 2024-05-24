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

  final List<Widget> pages = List.generate(
    7,
    (index) =>
        Image.asset('assets/images/hint${index + 1}.png', fit: BoxFit.fill),
  );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

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
      backgroundColor: MyColor.greenSuperLight,
      child: SizedBox(
        width: w * 0.8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: 2 / 3.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: PageView(
                    controller: pageController,
                    children: pages,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSmoothIndicator(
                  activeIndex: currentSlideIndex.value,
                  count: pages.length,
                  effect: const WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    dotColor: MyColor.greenLight,
                    activeDotColor: MyColor.pink,
                    type: WormType.thinUnderground,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            onTap();
                            Navigator.pop(context);
                          },
                          child:
                              Text('スキップ', style: lightTextTheme.bodyMedium)),
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
                                  style: lightTextTheme.bodyMedium!.copyWith(
                                      color: MyColor.greenSuperLight)))
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
      ),
    );
  }
}
