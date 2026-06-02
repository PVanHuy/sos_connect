import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    super.key,
    this.imageUrl = '',
    this.size = 24,
    this.borderRadius = 1000,
    this.width,
    this.height,
    this.showBoder = false,
    this.colorBoder,
    this.color,
    this.fit,
    this.noImage = true,
  });

  final String imageUrl;
  final double size;
  final double borderRadius;
  final double? width;
  final double? height;
  final bool showBoder;
  final Color? colorBoder;
  final Color? color;
  final BoxFit? fit;
  final bool noImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: .circular(borderRadius),
        border: showBoder ? Border.all(width: 1.w, color: colorBoder ?? appTheme.blueBellColor) : null,
        color: color,
      ),
      child: ClipRRect(
        borderRadius: .circular(borderRadius),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width ?? size,
          height: height ?? size,
          fit: fit ?? .cover,
          placeholder: (context, url) => noImage == true
              ? ImageAssetCustom(imagePath: Assets.images.placeholder.path, boxFit: .cover, size: size)
              : ImageAssetCustom(imagePath: Assets.images.noUrl.path, boxFit: .cover, size: size),
          errorWidget: (context, url, error) => noImage == true
              ? ImageAssetCustom(imagePath: Assets.images.placeholder.path, boxFit: .cover, size: size)
              : ImageAssetCustom(imagePath: Assets.images.noUrl.path, size: size, boxFit: .cover),
        ),
      ),
    );
  }
}
