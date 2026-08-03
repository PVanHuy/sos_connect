import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class NotiSkeletonView extends StatelessWidget {
  const NotiSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Skeleton.replace(width: 48.w, height: 48.w, child: const SizedBox.expand()),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Skeleton.replace(width: double.infinity, height: 16.h, child: Container()),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Skeleton.replace(width: 70.w, height: 12.h, child: Container()),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Skeleton.replace(width: double.infinity, height: 12.h, child: Container()),
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Skeleton.replace(width: 160.w, height: 12.h, child: Container()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
