import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SupportSosListSkeleton extends StatelessWidget {
  const SupportSosListSkeleton({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Skeleton.replace(
                    width: 160.w,
                    height: 16.h,
                    child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              ClipOval(
                child: Skeleton.replace(width: 36.w, height: 36.w, child: const SizedBox.expand()),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Skeleton.replace(
            width: double.infinity,
            height: 180.h,
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(height: 8.h),
          Skeleton.replace(
            width: double.infinity,
            height: 64.h,
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12))),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Skeleton.replace(
                width: 16.w,
                height: 16.h,
                child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Skeleton.replace(
                  width: double.infinity,
                  height: 12.h,
                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Skeleton.replace(
                  width: double.infinity,
                  height: 40.h,
                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50))),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Skeleton.replace(
                  width: double.infinity,
                  height: 40.h,
                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
