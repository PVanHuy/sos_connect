import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class RescuePostsListSkeleton extends StatelessWidget {
  const RescuePostsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(all: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appTheme.grayE5Color),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Skeleton.replace(
                width: 88.w,
                height: 24.h,
                child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(999))),
              ),
              const Spacer(),
              Skeleton.replace(
                width: 72.w,
                height: 24.h,
                child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(999))),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Skeleton.replace(
            width: double.infinity,
            height: 180.h,
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(height: 12.h),
          Skeleton.replace(
            width: double.infinity,
            height: 64.h,
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8))),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(width: double.infinity),
          SizedBox(height: 8.h),
          _buildInfoRow(width: 120.w),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required double width}) {
    return Row(
      children: [
        Skeleton.replace(
          width: 16.w,
          height: 16.h,
          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Skeleton.replace(
              width: width,
              height: 14.h,
              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ),
      ],
    );
  }
}
