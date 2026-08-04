import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class TeamMemberListSkeleton extends StatelessWidget {
  const TeamMemberListSkeleton({super.key, this.showKickButton = false});

  final bool showKickButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(all: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: appTheme.blackColor.withSafeOpacity(.08), blurRadius: 16, offset: Offset.zero)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Skeleton.replace(width: 44.w, height: 44.w, child: const SizedBox.expand()),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton.replace(
                      width: 140.w,
                      height: 16.h,
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                    ),
                    SizedBox(height: 4.h),
                    Skeleton.replace(
                      width: 100.w,
                      height: 12.h,
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                    ),
                    SizedBox(height: 4.h),
                    Skeleton.replace(
                      width: 120.w,
                      height: 12.h,
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                    ),
                  ],
                ),
              ),
              Skeleton.replace(
                width: 72.w,
                height: 24.h,
                child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20))),
              ),
            ],
          ),
          if (showKickButton) ...[
            SizedBox(height: 12.h),
            Skeleton.replace(
              width: double.infinity,
              height: 40.h,
              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50))),
            ),
          ],
        ],
      ),
    );
  }
}
