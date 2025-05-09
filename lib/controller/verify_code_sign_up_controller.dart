import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class VerifyCodeSignUpController extends GetxController {
  late TextEditingController emailController;
  String code = "";

  @override
  void onInit() {
    emailController = TextEditingController();
    if (Get.arguments != null && Get.arguments["email"] != null) {
      emailController.text = Get.arguments["email"];
    }
    super.onInit();
  }

  void submit() {
    if (code.length == 5) {
      // بعد التحقق من الرمز بنجاح
      Get.offAllNamed(AppRouts.successVerifyCodeSignUpScreen);
    } else {
      Get.snackbar("خطأ", "يرجى إدخال رمز التحقق المكوّن من 5 أرقام");
    }
  }

  void resendCode() {
    Get.snackbar("تم الإرسال", "تم إرسال رمز تحقق جديد إلى بريدك الإلكتروني");
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
