import 'package:flutter/material.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class MapSosMarkerWidget extends StatelessWidget {
  const MapSosMarkerWidget({
    super.key,
    required this.type,
    required this.isSelected,
  });

  final SosEmergencyType type;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final style = type.style;
    final size = isSelected ? 44.w : 36.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: style.text,
            shape: BoxShape.circle,
            border: Border.all(color: appTheme.whiteColor, width: isSelected ? 3 : 2),
            boxShadow: [
              BoxShadow(
                color: style.text.withValues(alpha: 0.35),
                blurRadius: isSelected ? 10 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: ImageAssetCustom(
              imagePath: type.iconPath,
              size: isSelected ? 20 : 16,
              color: appTheme.whiteColor,
            ),
          ),
        ),
        CustomPaint(
          size: Size(10.w, 8.h),
          painter: _MarkerPinPainter(color: style.text),
        ),
      ],
    );
  }
}

class _MarkerPinPainter extends CustomPainter {
  _MarkerPinPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MarkerPinPainter oldDelegate) => oldDelegate.color != color;
}
