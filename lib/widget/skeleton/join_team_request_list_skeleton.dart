import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class JoinTeamRequestListSkeleton extends StatelessWidget {
  const JoinTeamRequestListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(all: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: .circular(12),
        boxShadow: [BoxShadow(color: appTheme.blackColor.withSafeOpacity(.08), blurRadius: 16, offset: Offset.zero)],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Skeleton.replace(width: 44.w, height: 44.w, child: const SizedBox.expand()),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Skeleton.replace(
                      width: 180.w,
                      height: 16.h,
                      child: Container(decoration: BoxDecoration(borderRadius: .circular(4))),
                      
                    ),
                    SizedBox(height: 4.h),
                    Skeleton.replace(
                      width: 90.w,
                      height: 12.h,
                      child: Container(decoration: BoxDecoration(borderRadius: .circular(4))),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Skeleton.replace(
            width: 100.w,
            height: 12.h,
            child: Container(decoration: BoxDecoration(borderRadius: .circular(4))),
          ),
          SizedBox(height: 8.h),
          Skeleton.replace(
            width: double.infinity,
            height: 48.h,
            child: Container(decoration: BoxDecoration(borderRadius: .circular(8))),
          ),
          SizedBox(height: 16.h),
          Row(
            spacing: 8.w,
            children: [
              Expanded(
                child: Skeleton.replace(
                  height: 44.h,
                  child: Container(decoration: BoxDecoration(borderRadius: .circular(50))),
                ),
              ),
              Expanded(
                child: Skeleton.replace(
                  height: 44.h,
                  child: Container(decoration: BoxDecoration(borderRadius: .circular(50))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
