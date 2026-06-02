import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'Jiang Li';

  static const int minNameLength = 2;
  static const int minAddressLength = 12;
  static const int maxAddressLength = 100;
  static const int maxNameLength = 255;
  static const int timeOtp = 120;
  static const int secondsTimeBannerSlide = 5;

  static const int LIMIT = 10;

  static String baseUrl = dotenv.get('BASE_URL');
  static String socketUrl = dotenv.get('SOCKET_URL');

  static const String notificationChannelId = 'notification';
}
