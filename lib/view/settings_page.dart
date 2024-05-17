import 'package:flutter/material.dart';
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

    Widget Spacer() => const SizedBox(height: 20.0);

    Future<void> inquiryURL() async {
      final Uri url = Uri.parse('https://flutter.dev');
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

    // useEffect(() {
    //   return null;
    // }, [appVersion.value]);
    useEffect(() {
      loadVersion();
      return null;
    }, const []);

    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 36),
              onPressed: () {
                context.go('/');
              },
            ),
            title: Text('Settings', style: lightTextTheme.titleLarge),
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
                            Spacer(),
                            ListContentBase(
                              title: 'Account',
                              onTap: () {
                                context.go('/account');
                              },
                            ),
                            Spacer(),
                            ListContentBase(
                              title: 'Policy',
                              onTap: () {
                                context.go('/policy');
                              },
                            ),
                            Spacer(),
                            ListContentBase(
                              title: 'License',
                              onTap: () {
                                context.push('/license');
                              },
                            ),
                            Spacer(),
                            ListContentBase(
                              title: 'Inquiry',
                              onTap: inquiryURL,
                              isWeb: true,
                            ),
                            Spacer(),
                            ListContentBase(
                              title: 'Version',
                              onTap: inquiryURL,
                              tailContent: Text(
                                appVersion.value,
                                style: lightTextTheme.bodyLarge,
                              ),
                            ),
                            Spacer(),
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
        ),
      ],
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: MyColor.greenLight,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: lightTextTheme.titleLarge),
          tailContent ??
              GestureDetector(
                onTap: onTap,
                child: isWeb
                    ? const Icon(Icons.open_in_new, size: 24)
                    : const Icon(Icons.chevron_right_rounded, size: 30),
              ),
        ],
      ),
    );
  }
}
