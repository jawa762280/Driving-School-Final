import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  var rememberMe = true.obs;
  bool isShowPass = true;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  showPass() {
    isShowPass = !isShowPass;
    update();
  }

  goTOForgetPassword() {
    Get.toNamed(AppRouts.forgetPasswordScreen);
  }

  goToSignUp() {
    Get.toNamed(AppRouts.signupscreen);
  }

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void login() {
    if (!formState.currentState!.validate()) return;

    String phone = emailController.text;
    String password = passwordController.text;
    bool remember = rememberMe.value;

    // ignore: avoid_print
    print("رقم الهاتف: $phone");
    // ignore: avoid_print
    print("كلمة المرور: $password");
    // ignore: avoid_print
    print("تذكرني: $remember");
  }
}
