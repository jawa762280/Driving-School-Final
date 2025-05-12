import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class SignUpController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isShowPass = true;
  File? imageFile;

  late TextEditingController passController;
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  late TextEditingController birthDateController;
  late TextEditingController genderController;
  late TextEditingController imageController;

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
    birthDateController = TextEditingController();
    genderController = TextEditingController();
    imageController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    passController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    imageController.dispose();
    super.onClose();
  }
}
