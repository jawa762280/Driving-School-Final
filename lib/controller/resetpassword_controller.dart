import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController passController;
  late TextEditingController rePassController;
  bool isShowPass = true;
  bool isShowRePass = true;

  showPass() {
    isShowPass = !isShowPass;
    update();
  }

  showRePass() {
    isShowRePass = !isShowRePass;
    update();
  }

  @override
  void onInit() {
    passController = TextEditingController();
    rePassController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    passController.dispose();
    rePassController.dispose();
    super.onClose();
  }

  save() {
    if (passController.text != rePassController.text) {
      return Get.defaultDialog(
          title: "Warnning", middleText: "Password not match");
    }
    if (!formState.currentState!.validate()) return;
    Get.offAllNamed(AppRouts.successResetPasswordScreen);
  }
}
