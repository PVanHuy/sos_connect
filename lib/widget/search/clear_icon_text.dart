import 'package:flutter/material.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ClearIconText extends StatelessWidget {
  const ClearIconText({
    super.key,
    this.controller,
    this.text = '',
    this.mainAxisAlignment,
    this.handleAfterClear,
    this.icon,
  });

  final String? text;
  final TextEditingController? controller;
  final VoidCallback? handleAfterClear;
  final MainAxisAlignment? mainAxisAlignment;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      onTap: () {
        if (controller != null) {
          controller?.text = '';
        }
        handleAfterClear?.call();
      },
      child: Column(
        mainAxisSize: .min,
        mainAxisAlignment: mainAxisAlignment ?? .center,
        children: [icon ?? Assets.icons.closeCircle.svg(width: 16.w, height: 16.w)],
      ),
    );
    if (controller != null) {
      return ValueListenableBuilder(
        valueListenable: controller!,
        builder: (_, textCtrl, _) => Visibility(visible: textCtrl.text.isNotEmpty, child: child),
      );
    }
    return Visibility(visible: text?.isNotEmpty ?? false, child: child);
  }
}
