import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ImageAssetCustom extends StatelessWidget {
  final String imagePath;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;
  final bool? sizeBaseOnWidth;
  final BoxFit? boxFit;

  const ImageAssetCustom({
    super.key,
    required this.imagePath,
    this.size,
    this.width,
    this.height,
    this.color,
    this.boxFit,
    this.sizeBaseOnWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.contains('svg')) {
      return SvgPicture.asset(
        imagePath,
        width: width ?? (sizeBaseOnWidth! ? size?.w : size?.h),
        height: height != null
            ? height?.h
            : sizeBaseOnWidth!
            ? width?.h
            : height?.h,
        fit: boxFit ?? .contain,
        colorFilter: color != null ? .mode(color!, .srcIn) : null,
      );
    }
    return Image.asset(
      imagePath,
      color: color,
      width: width ?? (sizeBaseOnWidth! ? size?.w : size?.h),
      height: height != null
          ? height?.h
          : sizeBaseOnWidth!
          ? width?.h
          : height?.h,
      fit: boxFit ?? .contain,
    );
  }
}
