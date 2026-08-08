import 'package:flutter/material.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ActivityChipWidget extends StatelessWidget {
  const ActivityChipWidget({super.key, required this.text, required this.foreground, required this.background});

  final String text;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: StyleThemeData.size12Weight700(color: foreground)),
    );
  }
}
