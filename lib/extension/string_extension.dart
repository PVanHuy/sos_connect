extension StringToInt on String? {
  int get toIntValue {
    return int.tryParse(this ?? '') ?? 0;
  }

  double get toDoubleValue {
    return .tryParse(this ?? '') ?? 0;
  }
}

extension StringFormatting on String {
  String get formattedCurrency {
    final number = double.tryParse(this);
    if (number == null) {
      return this;
    }
    return '${number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}₫';
  }

  String get formatPhoneNumber {
    final clean = replaceAll(RegExp(r'\D'), '');
    if (clean.isEmpty) return '';

    int firstGroupLength = (clean.length % 3 == 1) ? 4 : 3;
    if (clean.length <= firstGroupLength) return clean;

    String result = '';
    int index = 0;

    result = clean.substring(0, firstGroupLength);
    index = firstGroupLength;

    while (index < clean.length) {
      result += ' ';
      int nextIndex = index + 3;
      if (nextIndex > clean.length) {
        nextIndex = clean.length;
      }
      result += clean.substring(index, nextIndex);
      index = nextIndex;
    }
    return result;
  }

  String get getFormattedPhoneNumber {
    if (isEmpty) {
      return '';
    }

    String phoneNumber = this;
    bool addPlus = phoneNumber.startsWith('1');
    if (addPlus) phoneNumber = phoneNumber.substring(1);
    bool addParents = phoneNumber.length >= 3;
    bool addDash = phoneNumber.length >= 8;

    String updatedNumber = '';
    if (addPlus) updatedNumber += '+1';

    if (addParents) {
      updatedNumber += '(';
      updatedNumber += phoneNumber.substring(0, 3);
      updatedNumber += ')';
    } else {
      updatedNumber += phoneNumber.substring(0);
      return updatedNumber;
    }

    if (addDash) {
      updatedNumber += phoneNumber.substring(3, 6);
      updatedNumber += '-';
    } else {
      updatedNumber += phoneNumber.substring(3);
      return updatedNumber;
    }

    updatedNumber += phoneNumber.substring(6);
    return updatedNumber;
  }

  String get addSpaceAfterComma {
    return replaceAllMapped(RegExp(r',(?!\s)'), (match) => ', ');
  }

  String get toShortId {
    const length = 4;
    if (this.length <= length) return this;
    return substring(this.length - length);
  }

  bool get isNetworkSource {
    return startsWith('http://') || startsWith('https://');
  }
}
