import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:membo/settings/color.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  static const url = 'https://membo.vercel.app/terms-of-service';
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(url));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.green,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.go('/settings');
          },
        ),
      ),
      body:
          SafeArea(bottom: false, child: WebViewWidget(controller: controller)),
    );
  }
}
