import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/middleware/mymiddleware.dart';
import 'package:driving_school/view/screen/login_screen.dart';
import 'package:driving_school/view/screen/onboarding_screen.dart';
import 'package:driving_school/view/screen/forget_password_screen.dart';
import 'package:driving_school/view/screen/reset_password_screen.dart';
import 'package:driving_school/view/screen/search_screen.dart';
import 'package:driving_school/view/screen/sign_up_screen.dart';
import 'package:driving_school/view/screen/success_reset_password_screen.dart';
import 'package:driving_school/view/screen/success_verifycode_signup_screen.dart';
import 'package:driving_school/view/screen/trainer_homepage_screen.dart';
import 'package:driving_school/view/screen/verify_code_screen.dart';
import 'package:driving_school/view/screen/verify_code_sign_up_screen.dart';
import 'package:driving_school/view/widget/buttomappbarhomestudent.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> routes = [
  GetPage(
    name: "/",
    page: () => LoginScreen(),
    middlewares: [AuthMiddleware()]
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
    name: AppRouts.signUpScreen,
    page: () => const SignUpScreen(),
  ),
  GetPage(
    name: AppRouts.verifyCodeScreen,
    page: () => const VerifyCodeScreen(),
  ),
  GetPage(
    name: AppRouts.successResetPasswordScreen,
    page: () => const SuccessResetPasswordScreen(),
  ),
  GetPage(
    name: AppRouts.successVerifyCodeSignUpScreen,
    page: () => const SuccessVerifyCodeSignUpScreen(),
  ),
  GetPage(
      name: AppRouts.verifyCodeSignUpScreen,
      page: () => const VerifyCodeSignUpScreen()),
  GetPage(
      name: AppRouts.studentHomePageScreen,
      page: () => const BottomAppbarHomeStudent()),
  GetPage(name: AppRouts.searchScreen, page: () => const SearchScreen()),
  GetPage(
      name: AppRouts.trainerHomePageScreen,
      page: () => const TrainerHomePageScreen()),
];
