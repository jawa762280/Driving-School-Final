import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  late TextEditingController emailController;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Crud crud = Crud();
  var isLoading = false.obs;

  @override
  void onInit() {
    emailController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void sendEmail() async {
    if (!formState.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final response = await crud.postRequest(AppLinks.forgetPassword, {
        "email": emailController.text.trim(),
      });
      isLoading.value = false;

      if (response != null && response['status'] == 'success') {
        Get.snackbar("✅ تم", response['message'],
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.toNamed(AppRouts.verifyCodeScreen,
            arguments: {"email": emailController.text.trim()});
      } else {
        // رسالة مخصصة من السيرفر
        String message = response?['message'] ??
            response?['errors']?['email']?[0] ??
            "حدث خطأ، حاول مرة أخرى";
        Get.snackbar("خطأ", message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل الاتصال بالخادم",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
