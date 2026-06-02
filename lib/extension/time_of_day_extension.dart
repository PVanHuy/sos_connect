import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  String get toFormattedHHmmss {
    final now = DateTime.now();
    final formattedTime = DateTime(now.year, now.month, now.day, hour, minute);

    return "${formattedTime.hour.toString().padLeft(2, '0')}:${formattedTime.minute.toString().padLeft(2, '0')}:${formattedTime.second.toString().padLeft(2, '0')}";
  }
}

extension TimeOfDayExtensions on TimeOfDay? {
  String get toTimeFormat {
    if (this == null) return '--:--';
    return '${this!.hour.toString().padLeft(2, '0')}:${this!.minute.toString().padLeft(2, '0')}';
  }
}

extension StringToTimeOfDay on String {
  TimeOfDay get toHmTimeOfDay {
    final parts = split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return TimeOfDay.now();
  }
}
