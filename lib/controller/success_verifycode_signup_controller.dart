import 'package:get/get.dart';
import 'package:driving_school/core/constant/approuts.dart';

class SuccessVerifyCodeSignUpController extends GetxController {
  void goToLogin() {
    Get.offAllNamed(AppRouts.loginScreen);
  }
}
