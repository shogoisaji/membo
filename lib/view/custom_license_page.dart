import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';

class CustomLicensePage extends ConsumerWidget {
  const CustomLicensePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: MyColor.green,
      body: LicensePage(
        applicationName: 'Membo',
      ),
    );
  }
}
