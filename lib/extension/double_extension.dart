extension DoubleFormatter on double {
  String get percentFormat {
    return this % 1 == 0 ? '${toInt()}%' : '${toStringAsFixed(1)}%';
  }

  String get toTrimmedString {
    return (this % 1 == 0) ? toInt().toString() : toStringAsFixed(2);
  }
}

extension NullableDoubleFormattingExtension on double? {
  String toThousandSeparatorFormat({int fractionDigits = 0}) {
    if (this == null) return '';
    return this!.toStringAsFixed(fractionDigits).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String get formatWorkingTime {
    if (this == null || this == 0) return '--';

    final totalMinutes = (this! * 60).round();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
