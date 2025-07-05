import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController passController;
  late TextEditingController rePassController;
  

  bool isShowPass = true;
  bool isShowRePass = true;

  var isLoading = false.obs;

  late String email;
  late String code;

  @override
  void onInit() {
    super.onInit();

    passController = TextEditingController();
    rePassController = TextEditingController();

    if (Get.arguments != null) {
      email = Get.arguments['email'] ?? "";
      code = Get.arguments['code'] ?? "";
    }
  }

  @override
  void onClose() {
    passController.dispose();
    rePassController.dispose();
    super.onClose();
  }

  void showPass() {
    isShowPass = !isShowPass;
    update();
  }

  void showRePass() {
    isShowRePass = !isShowRePass;
    update();
  }

  void save() async {
    if (!formState.currentState!.validate()) return;

    if (passController.text != rePassController.text) {
      Get.defaultDialog(
        title: "تحذير",
        middleText: "كلمتا المرور غير متطابقتين",
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await Crud().postRequest(
        AppLinks.resetPassword,
        {
          "email": email,
          "code": code,
          "password": passController.text,
          "password_confirmation": rePassController.text,
        },
      );

      if (response != null && response['status'] == 'success') {
        Get.offAllNamed(AppRouts.successResetPasswordScreen);
        Get.snackbar("نجاح", "تم إعادة تعيين كلمة المرور بنجاح");
      } else {
        Get.defaultDialog(
          title: "خطأ",
          middleText: response?['message'] ?? "حدث خطأ أثناء إعادة تعيين كلمة المرور",
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: "خطأ",
        middleText: "حدث خطأ في الاتصال بالخادم",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
