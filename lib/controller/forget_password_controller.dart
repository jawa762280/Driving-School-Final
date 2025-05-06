import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  late TextEditingController emailController;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  

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

  void sendEmail() {
    if (!formState.currentState!.validate()) return;
    Get.toNamed(AppRouts.resetPasswordScreen);
  }
}
