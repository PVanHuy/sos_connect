import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

Future<T?> showSelectBottomSheet<T>({
  required String title,
  required List<T> items,
  required String Function(T item) labelBuilder,
  bool fitContent = false,
}) {
  return Get.bottomSheet<T>(
    Container(
      constraints: fitContent ? null : BoxConstraints(maxHeight: Get.height * 0.7),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: const .vertical(top: Radius.circular(16)),
      ),
      padding: padding(bottom: 16),
      child: Column(
        mainAxisSize: fitContent ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Padding(
            padding: padding(all: 16),
            child: Text(title, style: StyleThemeData.size16Weight700()),
          ),
          if (fitContent)
            ...items.map(
              (item) => ListTile(
                title: Text(labelBuilder(item), style: StyleThemeData.size14Weight400()),
                onTap: () => Get.back(result: item),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(labelBuilder(item), style: StyleThemeData.size14Weight400()),
                    onTap: () => Get.back(result: item),
                  );
                },
              ),
            ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
