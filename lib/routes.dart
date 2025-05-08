import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/view/screen/login_screen.dart';
import 'package:driving_school/view/screen/onboarding_screen.dart';
import 'package:driving_school/view/screen/forget_password_screen.dart';
import 'package:driving_school/view/screen/reset_password_screen.dart';
import 'package:driving_school/view/screen/sign_up_screen.dart';
import 'package:driving_school/view/screen/verify_code_screen.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> routes = [
  GetPage(
    name: "/",
    page: () => OnboardingScreen(),
  ),
  GetPage(
    name: AppRouts.loginScreen,
    page: () => LoginScreen(),
  ),
  GetPage(
      name: AppRouts.onBoardingScreen, page: () => const OnboardingScreen()),
  GetPage(
    name: AppRouts.forgetPasswordScreen,
    page: () => const ForgetPasswordScreen(),
  ),
  GetPage(
      name: AppRouts.resetPasswordScreen,
      page: () => const ResetPasswordScreen()),
  GetPage(
    name: AppRouts.signupscreen,
    page: () => const SignUpScreen(),
  ),
  GetPage(
    name: AppRouts.verifyCodeScreen,
    page: () => const VerifyCodeScreen(),
  )
];
