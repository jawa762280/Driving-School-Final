import 'dart:async';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/message_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/approuts.dart';

class VerifyCodeController extends GetxController {
  late TextEditingController emailController;
  String code = "";
  var isLoading = false.obs;

  int attempts = 0;
  bool isLocked = false;
  RxInt countdown = 0.obs;
  Timer? timer;
  var canRetry = false.obs;

  Crud crud = Crud();
  DateTime? codeSentTime;

  @override
  void onInit() {
    emailController = TextEditingController();
    if (Get.arguments != null && Get.arguments["email"] != null) {
      emailController.text = Get.arguments["email"];
    }
    codeSentTime = DateTime.now(); 
    super.onInit();
  }

  void submit() async {
    if (isLocked) return;

    code = code.trim();

    if (code.length != 6) {
      Get.snackbar("خطأ", "يرجى إدخال رمز التحقق المكوّن من 6 أرقام");
      return;
    }

    if (codeSentTime != null &&
        DateTime.now().difference(codeSentTime!).inMinutes > 10) {
      Get.snackbar("خطأ", "الكود منتهي الصلاحية. يرجى طلب كود جديد.");
      return;
    }

    isLoading.value = true;

    try {
      final response = await crud.postRequest(
        AppLinks.verifyCode,
        {
          "email": emailController.text,
          "code": code,
        },
      );

      if (response != null &&
          response['message'] != null &&
          response['message'].toString().contains("محاولات كثيرة")) {
        final message = response['message'];
        final seconds = _extractWaitSecondsFromMessage(message);
        showLockoutDialog(message);
        startLockoutDialog(seconds);
        return;
      }

      if (response != null &&
          response['status'] == 'fail' &&
          response['message'].toString().contains("انتهت صلاحية")) {
        Get.snackbar("خطأ", response['message']);
        return;
      }

      if (response != null && response['status'] == 'success') {
        Get.toNamed(AppRouts.resetPasswordScreen, arguments: {
          "email": emailController.text,
          "code": code,
        });
      } else {
        attempts++;
        if (attempts >= 6) {
          startLockoutDialog(300); 
        } else {
          Get.snackbar(
              "فشل التحقق", response?['message'] ?? "رمز التحقق غير صحيح");
        }
      }
    } catch (e) {
      MessageService.showSnackbar(title: 'خطأ', message: "فشل الاتصال بالخادم");
    } finally {
      isLoading.value = false;
    }
  }

  void showTooManyRequestsDialog(String message) {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      AlertDialog(
        title: Text("🚫 تم الحظر مؤقتًا"),
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Get.isDialogOpen ?? false) Get.back();
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
  }

  int _extractWaitSecondsFromMessage(String message) {
    final regex = RegExp(r"\d+");
    final match = regex.firstMatch(message);
    return match != null ? int.tryParse(match.group(0)!) ?? 300 : 300;
  }

  void startLockoutDialog(int waitTime) {
    isLocked = true;

    countdown.value = waitTime;
    canRetry.value = false;


    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown.value--;
      if (countdown.value <= 0) {
        timer.cancel();
        isLocked = false;
        attempts = 0;
        canRetry.value = true;
      }
    });
  }

  void showLockoutDialog(String message) {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      Obx(() => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            titlePadding: EdgeInsets.zero,
            title: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text(
                "🚫 محاولات كثيرة",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Icon(Icons.lock_outline, size: 40, color: Colors.grey),
                const SizedBox(height: 10),
                Obx(() => Text(
                      canRetry.value
                          ? "يمكنك المحاولة مجددًا الآن."
                          : "تم قفل المحاولة مؤقتًا.\nيرجى الانتظار ${countdown.value} ثانية.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    )),
                const SizedBox(height: 20),
                if (canRetry.value)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (Get.isDialogOpen ?? false) {
                        Get.back();
                      }
                    },
                    child: const Text("🔄 حاول مجددًا",
                        style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          )),
      barrierDismissible: false,
    );
  }

  void resendCode() async {
    if (isLocked) {
      return;
    }

    try {
      final response = await crud.postRequest(
        AppLinks.resendVerifyCode,
        {
          "email": emailController.text,
        },
      );

      if (response != null && response['status'] == 'success') {
        codeSentTime = DateTime.now(); 
        Get.snackbar(
          "تم الإرسال",
          "تم إرسال رمز تحقق جديد إلى بريدك الإلكتروني",
        );
      } else {
        Get.snackbar(
            "فشل الإرسال", response?['message'] ?? "حدث خطأ أثناء إرسال الرمز",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء إرسال الرمز");
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    emailController.dispose();
    super.onClose();
  }
}
