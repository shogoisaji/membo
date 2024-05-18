import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';
import 'package:membo/settings/text_theme.dart';
import 'package:membo/widgets/bg_paint.dart';
import 'package:membo/widgets/error_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final appVersion = useState('');

    Widget spacer() => const SizedBox(height: 24.0);

    Future<void> inquiryURL() async {
      final Uri url = Uri.parse('https://membo.vercel.app/inquiry');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ErrorDialog.show(context, 'Could not launch $url');
        }
      }
    }

    Future<void> loadVersion() async {
      final packageInfo = await PackageInfo.fromPlatform();

      appVersion.value = packageInfo.version;
    }

    useEffect(() {
      loadVersion();
      return null;
    }, const []);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.go('/');
          },
        ),
        title: Text('設定', style: lightTextTheme.titleLarge),
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
                        spacer(),
                        ListContentBase(
                          title: 'アカウント',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.go('/account');
                          },
                        ),
                        spacer(),
                        ListContentBase(
                          title: 'プライバシーポリシー',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.go('/policy');
                          },
                        ),
                        spacer(),
                        ListContentBase(
                          title: '利用規約',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.go('/terms-of-service');
                          },
                        ),
                        spacer(),
                        ListContentBase(
                          title: 'ライセンス',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.push('/license');
                          },
                        ),
                        spacer(),
                        ListContentBase(
                          title: '問い合わせ',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            inquiryURL();
                          },
                          isWeb: true,
                        ),
                        spacer(),
                        ListContentBase(
                          title: 'バージョン',
                          onTap: () {},
                          tailContent: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              appVersion.value,
                              style: lightTextTheme.bodyLarge,
                            ),
                          ),
                        ),
                        spacer(),
                        const SizedBox(height: 100.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListContentBase extends StatelessWidget {
  const ListContentBase({
    super.key,
    required this.title,
    required this.onTap,
    this.isWeb = false,
    this.tailContent,
  });

  final String title;
  final Function() onTap;
  final bool isWeb;
  final Widget? tailContent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: MyColor.greenLight,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: lightTextTheme.titleMedium),
            tailContent ??
                SizedBox(
                  child: isWeb
                      ? const Padding(
                          padding: EdgeInsets.only(right: 6.0),
                          child: Icon(Icons.open_in_new, size: 28),
                        )
                      : const Icon(Icons.chevron_right_rounded, size: 36),
                ),
          ],
        ),
      ),
    );
  }
}
