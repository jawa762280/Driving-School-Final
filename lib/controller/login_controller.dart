import 'dart:async';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/services/services.dart';
import 'package:driving_school/data/model/user_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/approuts.dart';

import '../main.dart';

class LoginController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  var rememberMe = true.obs;
  bool isShowPass = true;
  var isLoading = false.obs;
  late UserModel currentUser;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  int failedAttempts = 0;
  Timer? lockoutTimer;
  var lockoutTime = 52.obs;
  var isDialogVisible = false.obs;
  var isButtonEnabled = true.obs;
  final MyServices myServices = Get.find<MyServices>();

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
    if (lockoutTimer != null && lockoutTimer!.isActive) {
      lockoutTimer!.cancel();
    }
    super.onClose();
  }

  void showPass() {
    isShowPass = !isShowPass;
    update();
  }

  void goTOForgetPassword() {
    Get.toNamed(AppRouts.forgetPasswordScreen);
  }

  void goToSignUp() {
    Get.toNamed(AppRouts.signUpScreen);
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void login() async {
    if (!formState.currentState!.validate()) return;

    String email = emailController.text;
    String password = passwordController.text;

    if (failedAttempts < 6) {
      isLoading.value = true;
      try {
        final response = await Crud().postRequest(AppLinks.login, {
          'email': email,
          'password': password,
        });
        isLoading.value = false;

        if (response != null && response['status'] == 'success') {
          final userData = response['data']['user'];
          // ignore: avoid_print
          print('userData: ${response['data']}');
          final token = response['data']['token'];
          myServices.saveToken(token);
          data.write('user', userData);
          data.write('role', response['data']['role'].toString());
          data.write('token', response['data']['token']);
          data.write('refreshToken', response['data']['refresh_token']);
          data.write('tokenType', response['data']['token_type']);
          currentUser = UserModel.fromJson(userData);
          failedAttempts = 0;
          Get.snackbar("نجاح", "تم تسجيل الدخول بنجاح");
          if (data.read('role') == 'student') {
            Get.offAllNamed(AppRouts.studentHomePageScreen);
          } else if (data.read('role') == 'trainer') {
            Get.offAllNamed(AppRouts.trainerHomePageScreen);
          }
        } else {
          isLoading.value = false;
          failedAttempts++;
          if (failedAttempts == 6) {
            _showLockoutDialog();
          } else {
            _showFailedLoginDialog();
          }
        }
      } catch (e) {
        isLoading.value = false;
        // ignore: avoid_print
        print("❌ حصل استثناء أثناء تسجيل الدخول: $e");
        if (!Get.isSnackbarOpen) {
          Get.snackbar("فشل الاتصال", "تعذر الاتصال بالخادم. حاول لاحقًا.");
        }
      }
    }
  }

  void _showFailedLoginDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("بيانات الدخول غير صحيحة"),
        content:
            Text("البريد الإلكتروني أو كلمة المرور غير صحيحة. حاول مجددًا."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "موافق",
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    Future.delayed(Duration(seconds: 2), () {
      if (Get.isDialogOpen!) {
        Get.back();
      }
    });
  }

  void _showLockoutDialog() {
    isDialogVisible.value = true;
    isButtonEnabled.value = false;

    Get.dialog(
      AlertDialog(
        title: Text("محاولات كثيرة جدًا"),
        content: Obx(() {
          return Text(
              "لقد قمت بمحاولات عديدة خاطئة. حاول بعد ${lockoutTime.value} ثانية.");
        }),
        actions: [
          Obx(() => TextButton(
                onPressed: isButtonEnabled.value
                    ? () {
                        Get.back();
                        lockoutTime.value = 52;
                      }
                    : null,
                child: Text("موافق",
                    style: TextStyle(color: AppColors.primaryColor)),
              )),
        ],
      ),
      barrierDismissible: false,
    );

    lockoutTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (lockoutTime.value <= 0) {
        timer.cancel();
        failedAttempts = 0;
        isDialogVisible.value = false;
        isButtonEnabled.value = true;
      } else {
        lockoutTime.value--;
      }
    });
  }
}
