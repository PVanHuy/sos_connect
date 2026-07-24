import 'package:flutter/widgets.dart';
import 'package:sos_connect/main.dart';

class AppGradient {
  static LinearGradient blueBFFAndAFFGradient = const LinearGradient(colors: [Color(0xFF006BFF), Color(0xFF00AAFF)]);

  static LinearGradient gradientBlueGenderMale = LinearGradient(colors: [appTheme.blueBFFColor, appTheme.blueFFColor]);

  static LinearGradient gradientPinkFemale = LinearGradient(colors: [appTheme.pinkA6Color, appTheme.pink8CColor]);

  static LinearGradient pinkE5AndWhiteGradient = LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [appTheme.pinkE5Color, appTheme.whiteColor],
  );

  static LinearGradient pinkEBAndWhiteGradient = LinearGradient(
    begin: .centerLeft,
    end: .centerRight,
    colors: [appTheme.pinkEBColor, appTheme.whiteColor],
  );

  static LinearGradient redGradient = LinearGradient(colors: [appTheme.red61Color, appTheme.appColor]);

  static LinearGradient redEBAndFFGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [appTheme.appColor, appTheme.red58Color],
  );

  static LinearGradient linearBlue = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [appTheme.blueF4Color, appTheme.whiteColor],
  );

  static LinearGradient purpleFFAndPurpleFFGradient = LinearGradient(
    colors: [appTheme.purpleFFColor, appTheme.appColor],
  );
}
