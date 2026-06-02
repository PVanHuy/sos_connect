import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class NotiSkeletonView extends StatelessWidget {
  const NotiSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(all: 12),
      decoration: BoxDecoration(borderRadius: .circular(12), color: appTheme.whiteColor),
      child: Row(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          ClipRRect(
            borderRadius: .circular(1000),
            child: Skeleton.replace(width: 46.w, height: 46.h, child: Container()),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                ClipRRect(
                  borderRadius: .circular(4),
                  child: Skeleton.replace(width: .infinity, height: 17.h, child: Container()),
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: .circular(4),
                  child: Skeleton.replace(width: .infinity, height: 15.h, child: Container()),
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: .circular(4),
                  child: Skeleton.replace(width: 49.w, height: 15.h, child: Container()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
