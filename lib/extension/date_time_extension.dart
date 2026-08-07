import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sos_connect/constant/date_format_constants.dart';

extension DateTimeFormatter on DateTime {
  String get toddMMyyyy {
    return DateFormat(DateConstants.ddMMyyyy).format(this);
  }

  String formatWith(String pattern) {
    return DateFormat(pattern).format(this);
  }

  String get toFormattedString {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final year = this.year.toString();
    return '$day/$month/$year';
  }

  bool isSameDateAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  String get toDateOnly {
    return '$year-$month-$day';
  }

  String get toDayMonthYear {
    return '${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year';
  }

  String get toMMMMyyyy {
    final formattedDate = DateFormat(DateConstants.MMMMyyyy, Get.locale?.languageCode).format(this);
    return formattedDate[0].toUpperCase() + formattedDate.substring(1);
  }

  String get toyyyyMMdd {
    return DateFormat(DateConstants.yyyyMMdd).format(this);
  }

  String get toyyyyMMddHHmmss {
    return DateFormat(DateConstants.yyyyMMddHHmmss).format(this);
  }

  String toStringDate() {
    return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  int get inMonths => (year * 12 + month);

  DateTime subtractYears(int years) {
    return DateTime(year - years, month, day, hour, minute, second, millisecond, microsecond);
  }

  String get toyMMMM {
    final formattedDate = DateFormat(DateConstants.yMMMM, Get.locale?.languageCode).format(this);
    return formattedDate[0].toUpperCase() + formattedDate.substring(1);
  }

  String get toMMMMdyyyy {
    final currentLocale = Get.locale?.languageCode ?? Intl.getCurrentLocale();
    return DateFormat.yMMMMd(currentLocale).format(this);
    // return DateFormat('MMMM d, yyyy', 'en_US').format(this);
  }

  String get toHHmm {
    return DateFormat(DateConstants.hhmm).format(this);
  }

  bool isSameOrAfter(DateTime other) => compareTo(other) >= 0;

  List<String> get weekdayNames {
    final monday = DateTime(2024, 1, 1);
    return List.generate(7, (i) {
      final formatted = DateFormat('E', Get.locale?.languageCode).format(monday.add(Duration(days: i)));
      return formatted.replaceAll('Th', 'T');
    });
  }

  String get getWeekdayLabel {
    switch (weekday) {
      case DateTime.monday:
        return 'mon'.tr;
      case DateTime.tuesday:
        return 'tue'.tr;
      case DateTime.wednesday:
        return 'wed'.tr;
      case DateTime.thursday:
        return 'thu'.tr;
      case DateTime.friday:
        return 'fri'.tr;
      case DateTime.saturday:
        return 'sat'.tr;
      case DateTime.sunday:
        return 'sun'.tr;
      default:
        return '';
    }
  }
}

extension DateFormatter on String? {
  String get toRelativeTime {
    if (this == null || this!.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(this!).toLocal();
      final diff = DateTime.now().difference(dateTime);

      if (diff.inSeconds < 60) return 'just_now'.tr;
      if (diff.inMinutes < 60) {
        return 'minutes_ago'.trParams({'count': '${diff.inMinutes}'});
      }
      if (diff.inHours < 24) {
        return 'hours_ago'.trParams({'count': '${diff.inHours}'});
      }
      return 'days_ago'.trParams({'count': '${diff.inDays}'});
    } catch (_) {
      return '';
    }
  }

  String get toHHmmddMMyyyy {
    if (this == null || this!.isEmpty) return 'undefined'.tr;

    try {
      final dateTime = DateTime.parse(this!).toLocal();
      final formattedDate = DateFormat(DateConstants.hhMMddMMMMyyyy).format(dateTime);
      return formattedDate;
    } catch (e) {
      return 'invalid_format'.tr;
    }
  }

  String get toHHmmddMMyyyyDot {
    if (this == null || this!.isEmpty) return 'undefined'.tr;

    try {
      final dateTime = DateTime.parse(this!).toLocal();
      final formattedDate = DateFormat(DateConstants.hhMMddMMMMyyyyDot).format(dateTime);
      return formattedDate;
    } catch (e) {
      return 'invalid_format'.tr;
    }
  }

  String get tohhmmddMMyyyy {
    if (this == null || this!.isEmpty) return 'undefined'.tr;

    try {
      final dateTime = DateTime.parse(this!).toLocal();
      final formattedDate = DateFormat(DateConstants.hhmmddMMyyyy).format(dateTime);
      return formattedDate;
    } catch (e) {
      return 'invalid_format'.tr;
    }
  }

  String get tohhmmSpaceddMMyyyy {
    if (this == null || this!.isEmpty) return 'undefined'.tr;

    try {
      final dateTime = DateTime.parse(this!).toLocal();
      final formattedDate = DateFormat(DateConstants.hhmmSpaceddMMyyyy).format(dateTime);
      return formattedDate;
    } catch (e) {
      return 'invalid_format'.tr;
    }
  }

  String get toddMMyyyyNoEmpty {
    if (this == null || this!.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(this!).toLocal();
      final formattedDate = DateFormat(DateConstants.ddMMyyyy).format(dateTime);
      return formattedDate;
    } catch (e) {
      return '';
    }
  }

  String get toDayMonthYear {
    if (this == null || this!.isEmpty) return 'N/A';

    final dateTime = DateTime.parse(this ?? '');

    return DateFormat(DateConstants.ddMMyyyy).format(dateTime);
  }

  DateTime? get toDateTime {
    if (this == null || this!.isEmpty) return null;
    try {
      return DateTime.tryParse(this!);
    } catch (_) {
      return null;
    }
  }

  String get formatted12HourTime {
    if (this == null || this!.isEmpty) return '';

    try {
      final date = DateTime.parse(this!);
      return DateFormat(DateConstants.hhmma).format(date.toLocal());
    } catch (e) {
      return '';
    }
  }

  String get toyyyyMMdd {
    if (this == null || this!.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(this!).toLocal();
      final formattedDate = DateFormat(DateConstants.yyyyMMdd).format(dateTime);
      return formattedDate;
    } catch (e) {
      return '';
    }
  }

  String get formatTo12hTime {
    if (this == null) return '';
    final date = this!.toDateTime.toLocal();
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String get toFullDateTimeString {
    final locale = Get.locale?.toString() ?? Intl.getCurrentLocale();
    final dateTime = DateTime.parse(this!).toLocal();

    return DateFormat(DateConstants.hhMMssddMMMMyyyy, locale).format(dateTime);
  }

  String get toddMMyyyyHHmm {
    if (this == null || this!.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(this!).toLocal();
      final formattedDate = DateFormat(DateConstants.toddMMyyyyHHmm).format(dateTime);
      return formattedDate;
    } catch (e) {
      return '';
    }
  }

  String get toddMM {
    if (this == null || this!.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(this!).toLocal();
      final formattedDate = DateFormat(DateConstants.ddMM).format(dateTime);
      return formattedDate;
    } catch (e) {
      return '';
    }
  }

  String get toHourMinute {
    if (this == null || this!.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(this!).toLocal();
      final formattedDate = DateFormat(DateConstants.hhmm).format(dateTime);
      return formattedDate;
    } catch (e) {
      return '';
    }
  }
}

extension DateTimeExtension on DateTime? {
  bool isSameDay(DateTime dateTime) {
    if (this == null) return false;
    return dateTime.day == this!.day && dateTime.month == this!.month && dateTime.year == this!.year;
  }

  bool get isToday {
    if (this == null) return false;
    final now = DateTime.now();
    return now.day == this!.day && now.month == this!.month && now.year == this!.year;
  }

  String get toHourMinute {
    if (this == null) return '--:--';
    return DateFormat(DateConstants.hhmm).format(this!);
  }

  String get toddMMyyyy {
    if (this == null) return '--/--/----';
    return DateFormat(DateConstants.ddMMyyyy).format(this!);
  }

  String get tohhMMddMMyyyy {
    if (this == null) return '--/--/----';
    return DateFormat(DateConstants.hhmmddMMyyyy).format(this!);
  }

  String get toddMM {
    if (this == null) return '--/--';
    return DateFormat(DateConstants.ddMM).format(this!);
  }
}

extension DateFormatting on String {
  DateTime get toDateTime => DateTime.parse(this);

  String get toTimeWithAMPM {
    try {
      return DateFormat('h:mm a').format(DateTime.parse(this).toLocal());
    } catch (e) {
      return this;
    }
  }

  String get formatToHourMinute {
    try {
      final time = DateTime.parse(this).toLocal();
      return DateFormat(DateConstants.hhmm).format(time);
    } catch (e) {
      return this;
    }
  }

  bool isTimeDifferenceGreaterThan(String? otherTime, int hours) {
    final current = toDateTime;
    final other = otherTime?.toDateTime;

    if (other == null) return true;

    return current.difference(other).inHours >= hours;
  }
}
