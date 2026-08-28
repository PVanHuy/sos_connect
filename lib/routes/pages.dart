import 'package:get/get.dart';
import 'package:sos_connect/pages/change_password/change_password_binding.dart';
import 'package:sos_connect/pages/change_password/change_password_page.dart';
import 'package:sos_connect/pages/chat/chat_binding.dart';
import 'package:sos_connect/pages/chat/chat_page.dart';
import 'package:sos_connect/pages/create_new_password/create_new_password_binding.dart';
import 'package:sos_connect/pages/create_new_password/create_new_password_page.dart';
import 'package:sos_connect/pages/dashboard/dashboard_binding.dart';
import 'package:sos_connect/pages/dashboard/dashboard_page.dart';
import 'package:sos_connect/pages/forgot_password/forgot_password_binding.dart';
import 'package:sos_connect/pages/forgot_password/forgot_password_page.dart';
import 'package:sos_connect/pages/onboarding/onboarding_binding.dart';
import 'package:sos_connect/pages/onboarding/onboarding_page.dart';
import 'package:sos_connect/pages/appeal_detail/appeal_detail_binding.dart';
import 'package:sos_connect/pages/appeal_detail/appeal_detail_page.dart';
import 'package:sos_connect/pages/appeal_list/appeal_list_binding.dart';
import 'package:sos_connect/pages/appeal_list/appeal_list_page.dart';
import 'package:sos_connect/pages/otp/otp_binding.dart';
import 'package:sos_connect/pages/otp/otp_page.dart';
import 'package:sos_connect/pages/personal_information/personal_information_binding.dart';
import 'package:sos_connect/pages/personal_information/personal_information_page.dart';
import 'package:sos_connect/pages/register_rescue_team/register_rescue_team_binding.dart';
import 'package:sos_connect/pages/register_rescue_team/register_rescue_team_page.dart';
import 'package:sos_connect/pages/join_request_detail/join_request_detail_binding.dart';
import 'package:sos_connect/pages/join_request_detail/join_request_detail_page.dart';
import 'package:sos_connect/pages/join_team_request_list/join_team_request_list_binding.dart';
import 'package:sos_connect/pages/join_team_request_list/join_team_request_list_page.dart';
import 'package:sos_connect/pages/notification_detail/notification_detail_binding.dart';
import 'package:sos_connect/pages/notification_detail/notification_detail_page.dart';
import 'package:sos_connect/pages/rescue_completed/rescue_completed_binding.dart';
import 'package:sos_connect/pages/rescue_completed/rescue_completed_page.dart';
import 'package:sos_connect/pages/rescue_team_detail/rescue_team_detail_binding.dart';
import 'package:sos_connect/pages/rescue_team_detail/rescue_team_detail_page.dart';
import 'package:sos_connect/pages/rescue_team_list/rescue_team_list_binding.dart';
import 'package:sos_connect/pages/rescue_team_list/rescue_team_list_page.dart';
import 'package:sos_connect/pages/send_sos/send_sos_binding.dart';
import 'package:sos_connect/pages/send_sos/send_sos_page.dart';
import 'package:sos_connect/pages/sign_in/sign_in_binding.dart';
import 'package:sos_connect/pages/sign_in/sign_in_page.dart';
import 'package:sos_connect/pages/sign_up/sign_up_binding.dart';
import 'package:sos_connect/pages/sign_up/sign_up_page.dart';
import 'package:sos_connect/pages/sos_chat/sos_chat_binding.dart';
import 'package:sos_connect/pages/sos_chat/sos_chat_page.dart';
import 'package:sos_connect/pages/splash/splash_binding.dart';
import 'package:sos_connect/pages/splash/splash_page.dart';
import 'package:sos_connect/pages/survival/survival_binding.dart';
import 'package:sos_connect/pages/survival/survival_page.dart';
import 'package:sos_connect/pages/survival_guide_detail/survival_guide_detail_binding.dart';
import 'package:sos_connect/pages/survival_guide_detail/survival_guide_detail_page.dart';
import 'package:sos_connect/pages/team_member_list/team_member_list_binding.dart';
import 'package:sos_connect/pages/team_member_list/team_member_list_page.dart';
import 'package:sos_connect/pages/user_detail/user_detail_binding.dart';
import 'package:sos_connect/pages/user_detail/user_detail_page.dart';

part 'routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => SplashPage(), binding: SplashBinding()),
    GetPage(name: Routes.ONBOARDING, page: () => OnboardingPage(), binding: OnboardingBinding()),
    GetPage(name: Routes.SIGN_IN, page: () => SignInPage(), binding: SignInBinding()),
    GetPage(name: Routes.SIGN_UP, page: () => SignUpPage(), binding: SignUpBinding()),
    GetPage(name: Routes.FORGOT_PASSWORD, page: () => ForgotPasswordPage(), binding: ForgotPasswordBinding()),
    GetPage(name: Routes.OTP, page: () => OtpPage(), binding: OtpBinding()),
    GetPage(name: Routes.DASHBOARD, page: () => DashboardPage(), binding: DashboardBinding()),
    GetPage(
      name: Routes.PERSONAL_INFORMATION,
      page: () => PersonalInformationPage(),
      binding: PersonalInformationBinding(),
    ),
    GetPage(
      name: Routes.REGISTER_RESCUE_TEAM,
      page: () => RegisterRescueTeamPage(),
      binding: RegisterRescueTeamBinding(),
    ),
    GetPage(name: Routes.CHANGE_PASSWORD, page: () => ChangePasswordPage(), binding: ChangePasswordBinding()),
    GetPage(name: Routes.RESCUE_COMPLETED, page: () => RescueCompletedPage(), binding: RescueCompletedBinding()),
    GetPage(name: Routes.RESCUE_TEAM_LIST, page: () => RescueTeamListPage(), binding: RescueTeamListBinding()),
    GetPage(name: Routes.RESCUE_TEAM_DETAIL, page: () => RescueTeamDetailPage(), binding: RescueTeamDetailBinding()),
    GetPage(
      name: Routes.JOIN_TEAM_REQUEST_LIST,
      page: () => JoinTeamRequestListPage(),
      binding: JoinTeamRequestListBinding(),
    ),
    GetPage(
      name: Routes.JOIN_REQUEST_DETAIL,
      page: () => JoinRequestDetailPage(),
      binding: JoinRequestDetailBinding(),
    ),
    GetPage(
      name: Routes.TEAM_MEMBER_LIST,
      page: () => TeamMemberListPage(),
      binding: TeamMemberListBinding(),
    ),
    GetPage(
      name: Routes.USER_DETAIL,
      page: () => UserDetailPage(),
      binding: UserDetailBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATION_DETAIL,
      page: () => NotificationDetailPage(),
      binding: NotificationDetailBinding(),
    ),
    GetPage(
      name: Routes.SURVIVAL_GUIDE_DETAIL,
      page: () => SurvivalGuideDetailPage(),
      binding: SurvivalGuideDetailBinding(),
    ),
    GetPage(name: Routes.SURVIVAL, page: () => SurvivalPage(), binding: SurvivalBinding()),
    GetPage(name: Routes.CHAT, page: () => ChatPage(), binding: ChatBinding()),
    GetPage(name: Routes.SOS_CHAT, page: () => SosChatPage(), binding: SosChatBinding()),
    GetPage(
      name: Routes.CREATE_NEW_PASSWORD,
      page: () => CreateNewPasswordPage(),
      binding: CreateNewPasswordBinding(),
    ),
    GetPage(name: Routes.SEND_SOS, page: () => SendSosPage(), binding: SendSosBinding()),
    GetPage(name: Routes.APPEAL_LIST, page: () => AppealListPage(), binding: AppealListBinding()),
    GetPage(name: Routes.APPEAL_DETAIL, page: () => AppealDetailPage(), binding: AppealDetailBinding()),
  ];
}
