bool parseToBool(dynamic json) {
  if (json is bool) {
    return json;
  } else if (json is int) {
    return json == 1;
  }
  return false;
}

int? parseToInt(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return int.tryParse(value);
  }
  if (value is num) {
    return value.toInt();
  }
  return null;
}

double? parseToDouble(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return .tryParse(value);
  }
  if (value is num) {
    return value.toDouble();
  }
  return null;
}

String? parseToString(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return value;
  }

  return value.toString();
}
