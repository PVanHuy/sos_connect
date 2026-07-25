import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
  });

  final int totalSteps;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final current = currentStep.clamp(0, totalSteps);
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index < current;
        return Expanded(
          child: Container(
            height: 4.h,
            margin: padding(right: index < totalSteps - 1 ? 8 : 0),
            decoration: BoxDecoration(
              color: isActive ? (activeColor ?? appTheme.appColor) : (inactiveColor ?? appTheme.grayEBColor),
              borderRadius: .circular(999),
            ),
          ),
        );
      }),
    );
  }
}
