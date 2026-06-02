import 'package:sos_connect/theme/base_theme_data.dart';
import 'package:flutter/material.dart';

enum ThemeType { light, dark }

abstract class BaseAppTheme<A extends BaseThemeData, B extends BaseThemeData> {
  A get lightTheme;

  B get darkTheme;

  late final ThemeData _lightTheme = ThemeData(
    primaryColor: lightTheme.primaryColor,
    dividerColor: lightTheme.dividerColor,
    hintColor: lightTheme.hintColor,
    cardColor: lightTheme.backgroundContainer,
  );

  late final ThemeData _darkTheme = ThemeData(
    primaryColor: darkTheme.primaryColor,
    dividerColor: darkTheme.dividerColor,
    hintColor: darkTheme.hintColor,
    cardColor: darkTheme.backgroundContainer,
  );

  ThemeData getThemeData(ThemeType type) {
    if (type == ThemeType.light) {
      return _lightTheme;
    } else {
      return _darkTheme;
    }
  }

  BaseThemeData getBaseTheme(ThemeType type) {
    if (type == ThemeType.light) {
      return lightTheme;
    } else {
      return darkTheme;
    }
  }
}
