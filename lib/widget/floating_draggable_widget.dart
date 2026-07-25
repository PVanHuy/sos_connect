import 'package:flutter/material.dart';
import 'package:sos_connect/core/app_border_shadow.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class FloatingDraggableWidget extends StatefulWidget {
  final VoidCallback? onTap;
  final Size bodySize;

  final double buttonSize;
  final double topPadding;
  final double bottomPadding;
  final bool enableSnapToEdge;
  final Duration snapDuration;

  const FloatingDraggableWidget({
    super.key,
    required this.bodySize,
    this.onTap,
    this.buttonSize = 56,
    this.topPadding = 12,
    this.bottomPadding = 12,
    this.enableSnapToEdge = true,
    this.snapDuration = const Duration(milliseconds: 300),
  });

  @override
  State<FloatingDraggableWidget> createState() => _FloatingDraggableWidgetState();
}

class _FloatingDraggableWidgetState extends State<FloatingDraggableWidget> with SingleTickerProviderStateMixin {
  static const double _horizontalPadding = 12;

  late Offset _position;
  late AnimationController _snapController;
  late Animation<Offset> _snapAnimation;

  @override
  void initState() {
    super.initState();

    _position = Offset(
      widget.bodySize.width - widget.buttonSize - _horizontalPadding,
      widget.bodySize.height - widget.buttonSize - widget.bottomPadding,
    );

    _snapController = AnimationController(vsync: this, duration: widget.snapDuration);

    _snapAnimation = Tween<Offset>(
      begin: _position,
      end: _position,
    ).animate(CurvedAnimation(parent: _snapController, curve: Curves.easeOut));

    _snapAnimation.addListener(() {
      setState(() {
        _position = _snapAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _updatePosition(Offset newPosition) {
    final minX = _horizontalPadding;
    final maxX = widget.bodySize.width - widget.buttonSize - _horizontalPadding;
    final minY = widget.topPadding;
    final maxY = widget.bodySize.height - widget.buttonSize - widget.bottomPadding;

    final clampedX = newPosition.dx.clamp(minX, maxX);
    final clampedY = newPosition.dy.clamp(minY, maxY);

    setState(() {
      _position = Offset(clampedX, clampedY);
    });
  }

  void _snapToEdge() {
    if (!widget.enableSnapToEdge) return;

    final minX = _horizontalPadding;
    final maxX = widget.bodySize.width - widget.buttonSize - _horizontalPadding;
    final centerX = widget.bodySize.width / 2;

    final snapX = _position.dx < centerX ? minX : maxX;

    final target = Offset(snapX, _position.dy);

    _snapAnimation = Tween<Offset>(
      begin: _position,
      end: target,
    ).animate(CurvedAnimation(parent: _snapController, curve: Curves.easeOut));

    _snapController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: RepaintBoundary(
        child: GestureDetector(
          onPanUpdate: (details) {
            if (_snapController.isAnimating) {
              _snapController.stop();
            }
            _updatePosition(_position + details.delta);
          },
          onPanEnd: (_) => _snapToEdge(),
          child: Material(
            color: appTheme.transparentColor,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(1000),
              child: Container(
                width: widget.buttonSize.w,
                height: widget.buttonSize.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradient.gradientBlueGenderMale,
                  boxShadow: AppBorderShadow.boxShadow,
                ),
                child: Center(
                  child: Assets.images.supportServices.image(width: 28.w, height: 28.w),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
