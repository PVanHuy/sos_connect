import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'SOS Connect';

  static const int minNameLength = 2;
  static const int minAddressLength = 12;
  static const int maxAddressLength = 100;
  static const int maxNameLength = 255;
  static const int timeOtp = 120;
  static const int secondsTimeBannerSlide = 5;
  static const int maxOtpLength = 6;

  static const int LIMIT = 10;

  static String baseUrl = dotenv.get('BASE_URL');
  static String socketUrl = dotenv.get('SOCKET_URL');

  static const String notificationChannelId = 'notification';

  static const String chatbotChatUri = '/chatbot/chat';

  static const String signUpUri = '/auth/register';
  static const String loginUri = '/auth/login';
  static const String otpUri = '/auth/otp';
  static const String verifyOtpUri = '/auth/otp/verify';
  static const String forgotPasswordUri = '/auth/forgot-password';
  static const String userProfileUri = '/user/profile';
}
