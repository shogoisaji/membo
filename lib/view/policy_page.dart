import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:membo/settings/color.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({super.key});

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  /// 仮
  static const url = 'https://replacer-lp.vercel.app/privacy-policy';
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
            context.go('/settings');
          },
        ),
      ),
      body:
          SafeArea(bottom: false, child: WebViewWidget(controller: controller)),
    );
  }
}
