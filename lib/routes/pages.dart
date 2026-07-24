import 'package:get/get.dart';
import 'package:sos_connect/pages/forgot_password/forgot_password_binding.dart';
import 'package:sos_connect/pages/forgot_password/forgot_password_page.dart';
import 'package:sos_connect/pages/onboarding/onboarding_binding.dart';
import 'package:sos_connect/pages/onboarding/onboarding_page.dart';
import 'package:sos_connect/pages/otp/otp_binding.dart';
import 'package:sos_connect/pages/otp/otp_page.dart';
import 'package:sos_connect/pages/sign_in/sign_in_binding.dart';
import 'package:sos_connect/pages/sign_in/sign_in_page.dart';
import 'package:sos_connect/pages/sign_up/sign_up_binding.dart';
import 'package:sos_connect/pages/sign_up/sign_up_page.dart';
import 'package:sos_connect/pages/splash/splash_binding.dart';
import 'package:sos_connect/pages/splash/splash_page.dart';

part 'routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => SplashPage(), binding: SplashBinding()),
    GetPage(name: Routes.ONBOARDING, page: () => OnboardingPage(), binding: OnboardingBinding()),
    GetPage(name: Routes.SIGN_IN, page: () => SignInPage(), binding: SignInBinding()),
    GetPage(name: Routes.SIGN_UP, page: () => SignUpPage(), binding: SignUpBinding()),
    GetPage(name: Routes.FORGOT_PASSWORD, page: () => ForgotPasswordPage(), binding: ForgotPasswordBinding()),
    GetPage(name: Routes.OTP, page: () => OtpPage(), binding: OtpBinding()),
  ];
}
