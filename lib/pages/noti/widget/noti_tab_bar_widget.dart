import 'package:flutter/material.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/noti_tab_type_utils.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class NotiTabBarWidget extends StatelessWidget {
  const NotiTabBarWidget({
    super.key,
    required this.selectedTab,
    required this.onSelect,
  });

  final NotiTabType selectedTab;
  final ValueChanged<NotiTabType> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(horizontal: 16, top: 8, bottom: 8),
      child: Container(
        padding: padding(all: 4),
        decoration: BoxDecoration(
          color: appTheme.sliverColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            for (final tab in NotiTabType.values)
              Expanded(
                child: InkWell(
                  onTap: () => onSelect(tab),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: padding(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedTab == tab ? appTheme.whiteColor : appTheme.transparentColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: selectedTab == tab
                          ? [
                              BoxShadow(
                                color: appTheme.blackColor.withSafeOpacity(.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      tab.title,
                      style: selectedTab == tab
                          ? StyleThemeData.size14Weight700(color: appTheme.appColor)
                          : StyleThemeData.size14Weight400(color: appTheme.gray83Color),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
