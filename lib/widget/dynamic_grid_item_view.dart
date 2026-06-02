import 'package:flutter/material.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class DynamicGridItemView<T> extends StatelessWidget {
  const DynamicGridItemView({
    super.key,
    required this.itemBuilder,
    this.items = const [],
    this.maxItemInLine = 3,
    this.minItemInLine = 2,
    this.paddingBetweenLine,
    this.borderRadius = 0,
  });

  final List<T> items;
  final int maxItemInLine;
  final int minItemInLine;
  final double? paddingBetweenLine;
  final Widget Function(T item, int index) itemBuilder;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    var itemInRow = minItemInLine;
    if (items.length != minItemInLine * 2) {
      itemInRow = maxItemInLine;
    }
    final column = items.length ~/ itemInRow + 1;

    return ClipRRect(
      borderRadius: .circular(borderRadius),
      child: Column(
        children: List.generate(column, (index) {
          final currentIndex = itemInRow * index;
          return Padding(
            padding: padding(
              top: index == 0 ? 0 : paddingBetweenLine,
              bottom: index == column - 1 ? 0 : paddingBetweenLine,
            ),
            child: Row(
              children: List.generate(
                itemInRow,
                (i) => currentIndex + i < items.length
                    ? Expanded(child: itemBuilder(items[currentIndex + i], currentIndex + i))
                    : const SizedBox(),
              ),
            ),
          );
        }),
      ),
    );
  }
}
