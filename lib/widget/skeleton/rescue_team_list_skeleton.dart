import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class RescueTeamListSkeleton extends StatelessWidget {
  const RescueTeamListSkeleton({super.key});

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
          _buildHeader(),
          SizedBox(height: 8.h),
          _buildInfoRow(),
          SizedBox(height: 8.h),
          _buildInfoRow(),
          SizedBox(height: 8.h),
          _buildInfoRow(),
          SizedBox(height: 8.h),
          _buildInfoRow(),
          SizedBox(height: 8.h),
          _buildInfoRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Skeleton.replace(
          width: 140.w,
          height: 16.h,
          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
        ),
        Skeleton.replace(
          width: 90.w,
          height: 24.h,
          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50))),
        ),
      ],
    );
  }

  Widget _buildInfoRow() {
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
              width: 80.w,
              height: 14.h,
              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
            ),
          ],
        ),
        Flexible(
          child: Skeleton.replace(
            width: 120.w,
            height: 14.h,
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
          ),
        ),
      ],
    );
  }
}
