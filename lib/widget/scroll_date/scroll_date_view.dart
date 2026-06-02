import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

import 'scroll_number.dart';

class ScrollDateTimeView extends StatefulWidget {
  final DateTime? dateTime;
  final void Function(DateTime)? onChanged;

  const ScrollDateTimeView({super.key, this.dateTime, this.onChanged});

  @override
  State<ScrollDateTimeView> createState() => _ScrollDateTimeViewState();
}

class _ScrollDateTimeViewState extends State<ScrollDateTimeView> {
  late final ValueNotifier<int> _dayOffset;
  late final ValueNotifier<int> _timeSlot;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final initialDateTime = widget.dateTime ?? now;

    final todayStart = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(initialDateTime.year, initialDateTime.month, initialDateTime.day);
    final daysDiff = targetDate.difference(todayStart).inDays;

    final minutes = initialDateTime.hour * 60 + initialDateTime.minute;
    final timeSlot = (minutes / 5).round();

    _dayOffset = ValueNotifier(daysDiff < 0 ? 0 : daysDiff);
    _timeSlot = ValueNotifier(timeSlot);
  }

  DateTime get _selectedDateTime {
    final now = DateTime.now();
    final baseDate = DateTime(now.year, now.month, now.day);
    final targetDate = baseDate.add(Duration(days: _dayOffset.value));

    final totalMinutes = _timeSlot.value * 5;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    return DateTime(targetDate.year, targetDate.month, targetDate.day, hours, minutes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: padding(horizontal: 12),
      child: Row(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: _timeSlot,
              builder: (context, value, _) {
                return ScrollNumber(
                  minValue: 0,
                  maxValue: 287,
                  value: value,
                  infiniteLoop: true,
                  selectedTextStyle: StyleThemeData.size16Weight700(),
                  textStyle: StyleThemeData.size14Weight500(color: appTheme.gray93Color),
                  onChanged: (int newValue) {
                    _timeSlot.value = newValue;
                    widget.onChanged?.call(_selectedDateTime);
                  },
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: appTheme.grayF5Color),
                      bottom: BorderSide(color: appTheme.grayF5Color),
                    ),
                  ),
                  textMapper: (numberText) => _formatTime(int.parse(numberText)),
                );
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: _dayOffset,
              builder: (context, value, _) {
                return ScrollNumber(
                  minValue: 0,
                  maxValue: 89,
                  value: value,
                  infiniteLoop: false,
                  selectedTextStyle: StyleThemeData.size16Weight700(),
                  textStyle: StyleThemeData.size14Weight500(color: appTheme.gray93Color),
                  onChanged: (int newValue) {
                    _dayOffset.value = newValue;
                    widget.onChanged?.call(_selectedDateTime);
                  },
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: appTheme.grayF5Color),
                      bottom: BorderSide(color: appTheme.grayF5Color),
                    ),
                  ),
                  textMapper: (numberText) => _formatDay(int.parse(numberText)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDay(int dayOffset) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day).add(Duration(days: dayOffset));

    if (dayOffset == 0) {
      return 'today'.tr;
    } else if (dayOffset == 1) {
      return 'tomorrow'.tr;
    } else {
      return date.toddMMyyyy;
    }
  }

  String _formatTime(int timeSlot) {
    final totalMinutes = timeSlot * 5;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
