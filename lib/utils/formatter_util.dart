import 'package:flutter/services.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/widget/input_formatter/currency_input_formatter.dart';
import 'package:sos_connect/widget/input_formatter/leading_zero_block_formatter.dart';
import 'package:sos_connect/widget/input_formatter/money_input_formatter.dart';
import 'package:sos_connect/widget/input_formatter/no_diacritics_text_formatter.dart';
import 'package:sos_connect/widget/input_formatter/no_initial_space_input_formatter_widgets.dart';
import 'package:sos_connect/widget/input_formatter/no_leading_zero_formatter.dart';
import 'package:sos_connect/widget/input_formatter/range_text_input_formatter.dart';

/// NoInitialSpaceInputFormatterWidgets: loại bỏ khoảng trắng đầu
/// NoDiacriticsTextFormatter: loại bỏ các ký tự có dấu

class FormatterUtil {
  static final List<TextInputFormatter> fullNameFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\sÀ-ỹ]')),
    FilteringTextInputFormatter.deny('  '),
    NoInitialSpaceInputFormatter(),
    LengthLimitingTextInputFormatter(25),
  ];

  static final List<TextInputFormatter> phoneFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(10),
  ];

  static final List<TextInputFormatter> passwordFormatter = [
    NoDiacriticsTextFormatter(),
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
    LengthLimitingTextInputFormatter(50),
  ];

  static final List<TextInputFormatter> referralCodeFormatter = [
    NoDiacriticsTextFormatter(),
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
  ];

  static final List<TextInputFormatter> emailFormatter = [
    NoDiacriticsTextFormatter(),
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
    LengthLimitingTextInputFormatter(50),
  ];

  static final List<TextInputFormatter> titleFormatter = [
    FilteringTextInputFormatter.deny('  '),
    NoInitialSpaceInputFormatter(),
    LengthLimitingTextInputFormatter(50),
  ];

  static final List<TextInputFormatter> notesFormatter = [
    FilteringTextInputFormatter.deny('  '),
    NoInitialSpaceInputFormatter(),
    LengthLimitingTextInputFormatter(AppConstants.maxNameLength),
  ];

  static final List<TextInputFormatter> moneyFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(10),
    NoLeadingZeroFormatter(),
    MoneyInputFormatter(),
  ];

  static final List<TextInputFormatter> moneyAllowZeroFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(10),
    LeadingZeroBlockFormatter(),
    MoneyInputFormatter(),
  ];

  static List<TextInputFormatter> moneyAdjustableFormatter({int maxHour = 24}) {
    return [
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      RangeTextInputFormatter(min: 0, max: maxHour),
      LeadingZeroBlockFormatter(),
      MoneyInputFormatter(),
    ];
  }

  static final List<TextInputFormatter> percentFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(2),
    RangeTextInputFormatter(min: 1, max: 100),
  ];

  static final List<TextInputFormatter> percentFormatterAllowZero = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(2),
    LeadingZeroBlockFormatter(),
    RangeTextInputFormatter(min: 0, max: 100),
  ];

  static final List<TextInputFormatter> percent100Formatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(3),
    RangeTextInputFormatter(min: 1, max: 100),
  ];

  static final List<TextInputFormatter> numberHourFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(2),
    RangeTextInputFormatter(min: 1, max: 24),
  ];

  static final List<TextInputFormatter> currencyFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(10),
    CurrencyInputFormatter(),
  ];

  static final List<TextInputFormatter> currencyFormatterNoSymbol = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(10),
    NoLeadingZeroFormatter(),
    CurrencyInputFormatter(showSymbol: false),
  ];

  static final List<TextInputFormatter> searchFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\sÀ-ỹ]')),
    FilteringTextInputFormatter.deny('  '),
    NoInitialSpaceInputFormatter(),
    LengthLimitingTextInputFormatter(50),
  ];

  static final List<TextInputFormatter> userNameAndPhoneFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s!@#\$&*~]')),
    NoInitialSpaceInputFormatter(),
    FilteringTextInputFormatter.deny(' '),
    LengthLimitingTextInputFormatter(20),
  ];

  static final List<TextInputFormatter> length50Formatter = [LengthLimitingTextInputFormatter(50)];

  static final List<TextInputFormatter> numberFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(20),
  ];

  static final List<TextInputFormatter> numberFormatterNoLeadingZero = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(20),
    NoLeadingZeroFormatter(),
  ];

  static final List<TextInputFormatter> codeFormatter = [
    NoDiacriticsTextFormatter(),
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
    LengthLimitingTextInputFormatter(20),
  ];

  static final List<TextInputFormatter> addressFormatter = [
    FilteringTextInputFormatter.deny('  '),
    NoInitialSpaceInputFormatter(),
    LengthLimitingTextInputFormatter(100),
  ];

  static final List<TextInputFormatter> urlFormatter = [
    NoInitialSpaceInputFormatter(),
    LengthLimitingTextInputFormatter(25),
  ];

  static final List<TextInputFormatter> chatMessageFormatter = [
    NoInitialSpaceInputFormatter(),
    LengthLimitingTextInputFormatter(1000),
  ];
}
