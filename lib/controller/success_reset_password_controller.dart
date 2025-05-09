import 'package:driving_school/core/constant/approuts.dart';
import 'package:get/get.dart';

class SuccessResetPasswordController extends GetxController {
  void goToLogin() {
    Get.offAllNamed(AppRouts.loginScreen);
  }
}
