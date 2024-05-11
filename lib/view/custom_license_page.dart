import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:membo/settings/color.dart';

class CustomLicensePage extends ConsumerWidget {
  const CustomLicensePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: MyColor.green,
      appBar: AppBar(
        backgroundColor: MyColor.green,
        title: Text('License'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
            size: 32,
          ),
          onPressed: () => context.go('/'),
        ),
      ),
      body: const LicensePage(
        applicationName: 'Membo-',
      ),
    );
  }
}

class _License extends StatelessWidget {
  final List<LicenseEntry> entries;

  const _License({required this.entries});

  @override
  Widget build(BuildContext context) {
    final licenseMap = {};
    for (final entry in entries) {
      for (final package in entry.packages) {
        if (licenseMap.containsKey(package)) {
          licenseMap[package].add(entry);
        } else {
          licenseMap[package] = [entry];
        }
      }
    }

    final licenses = licenseMap.entries.map((entry) {
      final List<Widget> list = <Widget>[];

      list.add(
        Text(
          entry.key,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 24,
          ),
        ),
      );

      for (final licenseEntry in entry.value) {
        for (final LicenseParagraph paragraph in licenseEntry.paragraphs) {
          if (paragraph.indent == LicenseParagraph.centeredIndent) {
            list.add(
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  paragraph.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            list.add(
              Padding(
                padding: EdgeInsetsDirectional.only(
                    top: 8.0, start: 16.0 * paragraph.indent),
                child: Text(paragraph.text,
                    style: TextStyle(color: Colors.blueGrey.shade900)),
              ),
            );
          }
        }
        list.add(const SizedBox(height: 16));
      }

      list.add(const Divider(height: 15, color: Colors.red));

      return list;
    }).toList();

    return ListView.builder(
      itemCount: licenses.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, index) => Column(
        children: licenses[index],
      ),
    );
  }
}
