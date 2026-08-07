import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class RescuePostsListSkeleton extends StatelessWidget {
  const RescuePostsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: appTheme.blackColor.withSafeOpacity(.08), blurRadius: 16, offset: Offset.zero)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Skeleton.replace(width: double.infinity, height: 200.h, child: const SizedBox.expand()),
              Positioned(
                top: 10.h,
                left: 10.w,
                child: Skeleton.replace(
                  width: 72.w,
                  height: 24.h,
                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50))),
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Skeleton.replace(
                  width: 64.w,
                  height: 24.h,
                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50))),
                ),
              ),
            ],
          ),
          Padding(
            padding: padding(all: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton.replace(
                  width: 100.w,
                  height: 12.h,
                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                ),
                SizedBox(height: 8.h),
                Skeleton.replace(
                  width: double.infinity,
                  height: 64.h,
                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12))),
                ),
                SizedBox(height: 12.h),
                _buildInfoRow(width: double.infinity),
                SizedBox(height: 8.h),
                _buildInfoRow(width: 120.w),
              ],
            ),
          ),
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
