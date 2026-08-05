import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'SOS Connect';

  static const int minNameLength = 2;
  static const int minAddressLength = 12;
  static const int maxAddressLength = 100;
  static const int maxNameLength = 255;
  static const int timeOtp = 120;
  static const int secondsTimeBannerSlide = 5;
  static const int maxOtpLength = 4;

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
  static const String changePasswordUri = '/auth/change-password';
  static const String userProfileUri = '/user/profile';

  static String userDetailUri(String userId) => '/user/$userId';
  static const String teamUserInfoUri = '/team/user-info';
  static const String teamRegisterInformationsUri = '/team/register/informations';
  static const String teamMyTeamUri = '/team/my-team';
  static const String teamDetailUri = '/team/detail';
  static const String teamListUri = '/team';
  static const String teamJoinRequestUri = '/team/join-request';
  static const String teamJoinRequestCurrentUri = '/team/join-request/current';
  static const String teamJoinRequestsPendingUri = '/team/join-requests/pending';
  static const String teamMembersUri = '/team/members';
  static const String updateFcmTokenUri = '/user/fcm-token';
  static const String logOutUri = '/auth/logout';
  static const String notificationUri = '/notification';
  static const String sosConvertUri = '/sos/convert';

  static String teamJoinRequestRespondUri(String requestId) => '/team/join-request/$requestId/respond';

  static String teamMemberKickUri(String memberId) => '/team/members/$memberId/kick';

  static String notificationDetailUri(String notificationId) => '/notification/$notificationId';

  static String markNotificationAsReadUri(String notificationId) => '/notification/$notificationId/read';
}
