import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/middleware/mymiddleware.dart';
import 'package:driving_school/view/screen/bookings_sessions_screen.dart';
import 'package:driving_school/view/screen/cars_screen.dart';
import 'package:driving_school/view/screen/exam_creation_screen.dart';
import 'package:driving_school/view/screen/exams_home_screen.dart';
import 'package:driving_school/view/screen/generate_exam_screen.dart';
import 'package:driving_school/view/screen/login_screen.dart';
import 'package:driving_school/view/screen/onboarding_screen.dart';
import 'package:driving_school/view/screen/forget_password_screen.dart';
import 'package:driving_school/view/screen/profile_screen.dart';
import 'package:driving_school/view/screen/reset_password_screen.dart';
import 'package:driving_school/view/screen/search_screen.dart';
import 'package:driving_school/view/screen/show_exam_by_type_screen.dart';
import 'package:driving_school/view/screen/show_training_schedules_screen.dart';
import 'package:driving_school/view/screen/show_vacations_screen.dart';
import 'package:driving_school/view/screen/sign_up_screen.dart';
import 'package:driving_school/view/screen/success_reset_password_screen.dart';
import 'package:driving_school/view/screen/success_verifycode_signup_screen.dart';
import 'package:driving_school/view/screen/trainer_exam_screen.dart';
import 'package:driving_school/view/screen/trainer_reviews_screen.dart';
import 'package:driving_school/view/screen/trainer_schedule_screen.dart';
import 'package:driving_school/view/screen/training_sessions_screen.dart';
import 'package:driving_school/view/screen/update_information_screen.dart';
import 'package:driving_school/view/screen/vacation_screen.dart';
import 'package:driving_school/view/screen/verify_code_screen.dart';
import 'package:driving_school/view/screen/verify_code_sign_up_screen.dart';
import 'package:driving_school/view/widget/buttomappbarhomestudent.dart';
import 'package:driving_school/view/widget/buttomappbarhometrainer.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> routes = [
  GetPage(
      name: "/", page: () => LoginScreen(), middlewares: [AuthMiddleware()]),
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
      page: () => const Buttomappbarhometrainer()),
  GetPage(
    name: AppRouts.profileScreen,
    page: () => const ProfileScreen(),
  ),
  GetPage(
    name: AppRouts.updateInformationScreen,
    page: () => const UpdateInformationScreen(),
  ),
  GetPage(
    name: AppRouts.carsScreen,
    page: () => CarsScreen(),
  ),
  GetPage(
    name: AppRouts.trainerScheduleScreen,
    page: () => TrainerScheduleScreen(),
  ),
  GetPage(
    name: AppRouts.showTRainingSchedulesScreen,
    page: () => ShowTRainingSchedulesScreen(),
  ),
  GetPage(
    name: AppRouts.trainingSessionsScreen,
    page: () => TrainingSessionsScreen(),
  ),
  GetPage(
    name: AppRouts.vacationScreen,
    page: () => VacationScreen(),
  ),
  GetPage(
    name: AppRouts.showVacationsScreen,
    page: () => ShowVacationsScreen(),
  ),
  GetPage(
    name: AppRouts.showVacationsScreen,
    page: () => BookingsSessionsScreen(),
  ),
  GetPage(
    name: AppRouts.creatExamScreen,
    page: () => ExamCreationScreen(),
  ),
  GetPage(
    name: AppRouts.showExamByTypeScreen,
    page: () => ShowExamByTypeScreen(),
  ),
  GetPage(
    name: AppRouts.trainerReviewsScreen,
    page: () => TrainerReviewsScreen(),
  ),
  GetPage(
    name: AppRouts.trainerExamScreen,
    page: () => TrainerExamsScreen(),
  ),
   GetPage(
    name: AppRouts.examHomeScreen,
    page: () => ExamsHomeScreen(),
  ),
  GetPage(
    name: AppRouts.generateExamScreen,
    page: () => GenerateExamScreen(),
  ),
];
