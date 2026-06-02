import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SlideActionButton extends StatefulWidget {
  const SlideActionButton({
    super.key,
    required this.text,
    required this.onCompleted,
    this.margin,
    this.hasSafeArea = true,
  });

  final String text;
  final VoidCallback onCompleted;
  final EdgeInsets? margin;
  final bool hasSafeArea;

  @override
  State<SlideActionButton> createState() => _SlideActionButtonState();
}

class _SlideActionButtonState extends State<SlideActionButton> {
  final RxDouble _dragPosition = 0.0.obs;
  bool _isDragging = false;

  void _updateDragPosition(double dx, double maxPosition) {
    final next = (_dragPosition.value + dx).clamp(0.0, maxPosition);
    _dragPosition.value = next;
  }

  void _onDragEnd(double maxPosition) {
    final reachEnd = _dragPosition.value >= maxPosition * 0.85;
    if (reachEnd) {
      _dragPosition.value = maxPosition;
      widget.onCompleted();
    }
    _isDragging = false;
    _dragPosition.value = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return widget.hasSafeArea ? SafeArea(top: false, child: _buildSlideWidget()) : _buildSlideWidget();
  }

  Widget _buildSlideWidget() {
    return Padding(
      padding: widget.margin ?? .zero,
      child: Container(
        width: .infinity,
        padding: padding(all: 4),
        constraints: BoxConstraints(minHeight: 52.h + 8.h),
        decoration: BoxDecoration(color: appTheme.whiteColor, borderRadius: .circular(999)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxPosition = constraints.maxWidth - 52.w;
            return Stack(
              alignment: .center,
              children: [
                Center(
                  child: Text(widget.text, style: StyleThemeData.size16Weight700(color: appTheme.appColor)),
                ),
                Obx(
                  () => AnimatedPositioned(
                    duration: Duration(milliseconds: _isDragging ? 0 : 250),
                    left: _dragPosition.value,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onHorizontalDragStart: (_) => _isDragging = true,
                      onHorizontalDragUpdate: (details) {
                        _updateDragPosition(details.delta.dx, maxPosition);
                      },
                      onHorizontalDragEnd: (_) => _onDragEnd(maxPosition),
                      child: Container(
                        padding: padding(all: 8),
                        alignment: .center,
                        decoration: BoxDecoration(shape: .circle, color: appTheme.appColor),
                        child: Assets.icons.arrowRightOther.svg(
                          width: 35.w,
                          height: 35.h,
                          colorFilter: .mode(appTheme.whiteColor, .srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
