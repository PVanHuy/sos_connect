import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sos_connect/extension/string_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class FullPhotoViewer extends StatefulWidget {
  const FullPhotoViewer({
    super.key,
    this.initialIndex = 0,
    this.assets = const [],
    this.onPageChanged,
    this.customSubChild,
  });

  final List<dynamic> assets;
  final int initialIndex;
  final Function(int)? onPageChanged;
  final List<Widget>? customSubChild;

  static Future<void> open(
    BuildContext context, {
    required List<dynamic> assets,
    int initialIndex = 0,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.92),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FullPhotoViewer(assets: assets, initialIndex: initialIndex),
      ),
    );
  }

  @override
  State<FullPhotoViewer> createState() => _FullPhotoViewerState();
}

class _FullPhotoViewerState extends State<FullPhotoViewer> {
  late PageController pageController;
  late final ValueNotifier<int> indexNotifier;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialIndex);
    indexNotifier = ValueNotifier(widget.initialIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    indexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      backgroundColor: Colors.transparent,
      onDismissed: () => Navigator.of(context).pop(),
      direction: DismissiblePageDismissDirection.multi,
      isFullScreen: true,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: widget.assets.length,
            onPageChanged: (index) {
              widget.onPageChanged?.call(index);
              indexNotifier.value = index;
            },
            itemBuilder: (BuildContext context, int index) {
              final assetSource = widget.assets[index];
              final isNetworkAsset = assetSource is String && assetSource.isNetworkSource;
              final isFile = assetSource is File;

              return Center(
                child: isNetworkAsset
                    ? CachedNetworkImage(
                        imageUrl: assetSource,
                        placeholder: (context, url) =>
                            const CupertinoActivityIndicator(color: Colors.white, radius: 15),
                        errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                        fit: BoxFit.contain,
                      )
                    : isFile
                    ? Image.file(File(assetSource.path), fit: BoxFit.contain)
                    : Image.asset(assetSource as String, fit: BoxFit.contain),
              );
            },
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 12,
            right: 8,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Row(
                children: [
                  const Icon(Icons.close, color: Colors.white),
                  SizedBox(width: 4.w),
                  Text(
                    'close'.tr,
                    style: StyleThemeData.size14Weight400(color: appTheme.whiteColor, height: 1),
                  ),
                ],
              ),
            ),
          ),
          ...?widget.customSubChild,
          if (widget.assets.length > 1) ...[
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: Center(
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: widget.assets.length,
                  effect: WormEffect(
                    radius: 5.w,
                    dotHeight: 10.w,
                    dotWidth: 10.w,
                    spacing: 6.w,
                    activeDotColor: appTheme.whiteColor,
                    dotColor: appTheme.grayCDColor,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: ValueListenableBuilder(
                valueListenable: indexNotifier,
                builder: (context, index, child) {
                  return Text(
                    '${index + 1}/${widget.assets.length}',
                    style: StyleThemeData.size14Weight400(color: appTheme.whiteColor, height: 1),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
