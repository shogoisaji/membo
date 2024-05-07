import 'package:flutter/material.dart';

class CustomListContent extends StatelessWidget {
  final Icon? titleIcon;
  final String title;
  final TextStyle titleStyle;
  final Color backgroundColor;
  final List<Widget> contentWidgets;
  final EdgeInsets padding;

  const CustomListContent(
      {super.key,
      this.titleIcon,
      required this.title,
      required this.titleStyle,
      required this.backgroundColor,
      required this.contentWidgets,
      this.padding =
          const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0)});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 4.0),
            titleIcon != null ? titleIcon! : const SizedBox.shrink(),
            const SizedBox(width: 8.0),
            Text(title, style: titleStyle),
          ],
        ),
        Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentWidgets,
          ),
        ),
      ],
    );
  }
}
