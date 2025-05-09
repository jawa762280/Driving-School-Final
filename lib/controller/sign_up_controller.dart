import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isShowPass = true;
  late TextEditingController passController;
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  showPass() {
    isShowPass = !isShowPass;
    update();
  }

  signUp() {
    if (!formState.currentState!.validate()) return;
    Get.toNamed(AppRouts.verifyCodeSignUpScreen);
  }

  @override
  void onInit() {
    passController = TextEditingController();
    emailController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    passController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}
