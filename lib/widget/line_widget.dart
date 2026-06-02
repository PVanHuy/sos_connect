import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class LineWidget extends StatelessWidget {
  const LineWidget({this.width, this.height, this.color, this.margin, this.isDashed = false, super.key});

  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final bool isDashed;

  @override
  Widget build(BuildContext context) {
    final lineWidth = width?.w ?? Get.size.width;
    final lineHeight = height?.h ?? 1.h;

    if (isDashed) {
      return Container(
        margin: margin,
        width: lineWidth,
        height: lineHeight,
        child: CustomPaint(
          painter: _DashedLinePainter(
            gradient: color == null ? AppGradient.blueBFFAndAFFGradient : null,
            color: color ?? appTheme.grayE6Color,
            strokeWidth: lineHeight,
            dashPattern: [4, 4],
          ),
        ),
      );
    }

    return Container(
      margin: margin,
      width: lineWidth,
      height: lineHeight,
      decoration: BoxDecoration(
        gradient: color == null ? AppGradient.blueBFFAndAFFGradient : null,
        color: color ?? appTheme.grayE6Color,
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Gradient? gradient;
  final Color? color;
  final double strokeWidth;
  final List<int> dashPattern;

  _DashedLinePainter({this.gradient, this.color, required this.strokeWidth, required this.dashPattern});

  @override
  void paint(Canvas canvas, Size size) {
    final dashWidth = dashPattern[0].toDouble();
    final dashSpace = dashPattern[1].toDouble();
    final dashLength = dashWidth + dashSpace;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (color != null) {
      paint.color = color!;
    } else if (gradient != null) {
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      final shader = gradient!.createShader(rect);
      paint.shader = shader;
    }

    var startX = 0.0;
    while (startX < size.width) {
      final endX = (startX + dashWidth).clamp(0.0, size.width);
      if (endX > startX) {
        canvas.drawLine(Offset(startX, size.height / 2), Offset(endX, size.height / 2), paint);
      }
      startX += dashLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
