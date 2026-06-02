import 'package:flutter/widgets.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class InputStepIndexWidget extends StatelessWidget {
  const InputStepIndexWidget({super.key, required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.w,
      mainAxisAlignment: .center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        return Container(
          width: 23.w,
          height: 6.h,
          decoration: BoxDecoration(
            borderRadius: .circular(50),
            color: isActive ? appTheme.whiteColor : appTheme.blueF5Color,
          ),
        );
      }),
    );
  }
}
