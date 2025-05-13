import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/services/crud.dart';
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
    Get.toNamed(AppRouts.signUpScreen);
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

  void login() async {
    if (!formState.currentState!.validate()) return;
    Crud crud = Crud();
    String email = emailController.text;
    String password = passwordController.text;
    bool remember = rememberMe.value;
    final response = await crud.postRequest(AppApi.login, {
      'email': email,
      'password': password,
    });
    if (response['status'] == 'success') {
      Get.toNamed(AppRouts.studentHomePageScreen);
    }
    update();
  }
}
