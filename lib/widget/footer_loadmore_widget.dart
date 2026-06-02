import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class FooterLoadmoreWidget extends StatelessWidget {
  const FooterLoadmoreWidget({
    super.key,
    required this.start,
    required this.end,
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.goToPage,
  });

  final int start;
  final int end;
  final int total;
  final int totalPages;
  final int currentPage;
  final Function(int page) goToPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'showing_entries'.trParams({'start': start.toString(), 'end': end.toString(), 'total': total.toString()}),
            style: StyleThemeData.size12Weight700(color: appTheme.gray78Color),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_buildPrevButton(), ..._buildPageNumbers(), _buildNextButton()],
          ),
        ),
      ],
    );
  }

  Widget _buildPrevButton() {
    return currentPage > 1
        ? InkWell(
            onTap: currentPage > 1 ? () => goToPage(currentPage - 1) : null,
            borderRadius: .circular(99),
            child: Container(
              width: 30.w,
              height: 30.w,
              margin: padding(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: appTheme.grayE6Color),
                color: appTheme.whiteColor,
              ),
              child: Assets.icons.arrowLeft.svg(
                width: 16.w,
                height: 16.w,
                colorFilter: ColorFilter.mode(
                  currentPage > 1 ? appTheme.blackColor : appTheme.gray78Color,
                  BlendMode.srcIn,
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget _buildNextButton() {
    return currentPage < totalPages
        ? InkWell(
            onTap: currentPage < totalPages ? () => goToPage(currentPage + 1) : null,
            borderRadius: .circular(99),
            child: Container(
              width: 30.w,
              height: 30.w,
              margin: padding(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: appTheme.grayE6Color),
                color: appTheme.whiteColor,
              ),
              child: Assets.icons.arrowRight.svg(
                width: 16.w,
                height: 16.w,
                colorFilter: ColorFilter.mode(
                  currentPage < totalPages ? appTheme.blackColor : appTheme.gray78Color,
                  BlendMode.srcIn,
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  List<Widget> _buildPageNumbers() {
    const maxVisible = 5;
    int startPage = max(1, currentPage - 2);
    int endPage = min(totalPages, startPage + maxVisible - 1);

    if (endPage - startPage < maxVisible - 1) {
      startPage = max(1, endPage - maxVisible + 1);
    }

    final widgets = <Widget>[];

    if (startPage > 1) {
      widgets.add(_buildPageNumber(1, currentPage == 1));
      if (startPage > 2) widgets.add(_buildPageDot());
    }

    for (int i = startPage; i <= endPage; i++) {
      widgets.add(_buildPageNumber(i, currentPage == i));
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) widgets.add(_buildPageDot());
      widgets.add(_buildPageNumber(totalPages, currentPage == totalPages));
    }

    return widgets;
  }

  Widget _buildPageDot() {
    return Container(
      width: 30.w,
      height: 30.w,
      margin: padding(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: appTheme.oldGrayColor, width: 1.w),
        color: appTheme.gray26Color,
      ),
      child: Assets.icons.baseMore.svg(width: 22.w, height: 22.h),
    );
  }

  Widget _buildPageNumber(int page, bool isActive) {
    return InkWell(
      onTap: () => goToPage(page),
      borderRadius: .circular(99),
      child: Container(
        width: 30.w,
        height: 30.w,
        margin: padding(horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: appTheme.oldGrayColor, width: 1.w),
          color: isActive ? appTheme.appColor : appTheme.whiteColor,
        ),
        child: Text(
          '$page',
          style: StyleThemeData.size14Weight700(color: isActive ? appTheme.whiteColor : appTheme.gray78Color),
        ),
      ),
    );
  }
}
