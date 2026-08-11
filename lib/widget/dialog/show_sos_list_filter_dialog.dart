import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/sos_list_filter_utils.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SosListFilterResult {
  const SosListFilterResult({this.radiusKm, this.timeWindow});

  final int? radiusKm;
  final String? timeWindow;
}

Future<SosListFilterResult?> showSosListFilterDialog({int? radiusKm, String? timeWindow}) {
  return Get.bottomSheet<SosListFilterResult>(
    _SosListFilterSheet(radiusKm: radiusKm, timeWindow: timeWindow),
    isScrollControlled: true,
  );
}

class _SosListFilterSheet extends StatefulWidget {
  const _SosListFilterSheet({this.radiusKm, this.timeWindow});

  final int? radiusKm;
  final String? timeWindow;

  @override
  State<_SosListFilterSheet> createState() => _SosListFilterSheetState();
}

class _SosListFilterSheetState extends State<_SosListFilterSheet> {
  late int? _radiusKm = widget.radiusKm;
  late String? _timeWindow = widget.timeWindow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: padding(horizontal: 16, top: 16, bottom: 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('filter'.tr, style: StyleThemeData.size16Weight700())),
            SizedBox(height: 16.h),
            Text('filter_radius'.tr, style: StyleThemeData.size14Weight700()),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _chip(label: 'all'.tr, selected: _radiusKm == null, onTap: () => setState(() => _radiusKm = null)),
                for (final km in SosListFilterUtils.radiusKmOptions)
                  _chip(label: '$km km', selected: _radiusKm == km, onTap: () => setState(() => _radiusKm = km)),
              ],
            ),
            SizedBox(height: 16.h),
            Text('filter_time_window'.tr, style: StyleThemeData.size14Weight700()),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _chip(label: 'all'.tr, selected: _timeWindow == null, onTap: () => setState(() => _timeWindow = null)),
                for (final window in SosListFilterUtils.timeWindowOptions)
                  _chip(
                    label: window,
                    selected: _timeWindow == window,
                    onTap: () => setState(() => _timeWindow = window),
                  ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: 'cancel'.tr,
                    color: appTheme.grayE5Color,
                    textColor: appTheme.blackColor,
                    hasSafeArea: false,
                    onPressed: () => Get.back(),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomButton(
                    buttonText: 'apply'.tr,
                    hasSafeArea: false,
                    onPressed: () => Get.back(
                      result: SosListFilterResult(radiusKm: _radiusKm, timeWindow: _timeWindow),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({required String label, required bool selected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: padding(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? appTheme.appColor.withSafeOpacity(0.12) : appTheme.whiteColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? appTheme.appColor : appTheme.grayE5Color),
        ),
        child: Text(
          label,
          style: StyleThemeData.size12Weight700(color: selected ? appTheme.appColor : appTheme.gray83Color),
        ),
      ),
    );
  }
}
