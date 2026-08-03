import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class InfoItemWidget extends StatelessWidget {
  const InfoItemWidget({
    super.key,
    required this.content,
    required this.title,
    this.fixedLines,
    this.enableScroll = false,
    this.contentBackgroundColor,
  });

  final String content;
  final String title;
  final int? fixedLines;
  final bool enableScroll;
  final Color? contentBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding(bottom: 8),
          child: Text(title, style: StyleThemeData.size12Weight700()),
        ),
        Container(
          width: double.infinity,
          padding: padding(all: 12),
          decoration: BoxDecoration(
            color: contentBackgroundColor ?? appTheme.grayF6Color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final textStyle = StyleThemeData.size14Weight400();
    final displayContent = content.isNotEmpty ? content : 'no_data'.tr;

    if (fixedLines == null) {
      return Text(displayContent, style: textStyle);
    }

    final lineHeight = (textStyle.height ?? 1.2) * (textStyle.fontSize ?? 14);
    return SizedBox(
      height: lineHeight * fixedLines!,
      child: enableScroll
          ? SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Text(displayContent, style: textStyle),
            )
          : Align(
              alignment: Alignment.topLeft,
              child: Text(displayContent, style: textStyle),
            ),
    );
  }
}
