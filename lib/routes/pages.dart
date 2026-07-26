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
import 'package:sos_connect/pages/otp/otp_binding.dart';
import 'package:sos_connect/pages/otp/otp_page.dart';
import 'package:sos_connect/pages/personal_information/personal_information_binding.dart';
import 'package:sos_connect/pages/personal_information/personal_information_page.dart';
import 'package:sos_connect/pages/register_rescue_team/register_rescue_team_binding.dart';
import 'package:sos_connect/pages/register_rescue_team/register_rescue_team_page.dart';
import 'package:sos_connect/pages/rescue_posts/rescue_posts_binding.dart';
import 'package:sos_connect/pages/rescue_posts/rescue_posts_page.dart';
import 'package:sos_connect/pages/sign_in/sign_in_binding.dart';
import 'package:sos_connect/pages/sign_in/sign_in_page.dart';
import 'package:sos_connect/pages/sign_up/sign_up_binding.dart';
import 'package:sos_connect/pages/sign_up/sign_up_page.dart';
import 'package:sos_connect/pages/splash/splash_binding.dart';
import 'package:sos_connect/pages/splash/splash_page.dart';
import 'package:sos_connect/pages/survival_guide_detail/survival_guide_detail_binding.dart';
import 'package:sos_connect/pages/survival_guide_detail/survival_guide_detail_page.dart';

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
    GetPage(name: Routes.RESCUE_POSTS, page: () => RescuePostsPage(), binding: RescuePostsBinding()),
    GetPage(
      name: Routes.SURVIVAL_GUIDE_DETAIL,
      page: () => SurvivalGuideDetailPage(),
      binding: SurvivalGuideDetailBinding(),
    ),
    GetPage(name: Routes.CHAT, page: () => ChatPage(), binding: ChatBinding()),
    GetPage(
      name: Routes.CREATE_NEW_PASSWORD,
      page: () => CreateNewPasswordPage(),
      binding: CreateNewPasswordBinding(),
    ),
  ];
}
