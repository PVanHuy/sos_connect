import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class AppealListSkeleton extends StatelessWidget {
  const AppealListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(all: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: appTheme.grayE5Color, width: 10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Skeleton.replace(
                  width: 160.w,
                  height: 16.h,
                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                ),
              ),
              SizedBox(width: 12.w),
              Skeleton.replace(
                width: 88.w,
                height: 24.h,
                child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50))),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _buildInfoRow(contentWidth: 110.w),
          SizedBox(height: 8.h),
          _buildInfoRow(contentWidth: 140.w),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required double contentWidth}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Skeleton.replace(
              width: 16.w,
              height: 16.h,
              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
            ),
            SizedBox(width: 8.w),
            Skeleton.replace(
              width: 88.w,
              height: 14.h,
              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
            ),
          ],
        ),
        Flexible(
          child: Skeleton.replace(
            width: contentWidth,
            height: 14.h,
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
          ),
        ),
      ],
    );
  }
}
