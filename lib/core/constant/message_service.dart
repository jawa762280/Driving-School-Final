import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/constant/appcolors.dart';

class MessageService {
  static void showSnackbar({
    required String title,
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  static void showDialogMessage({
    required String title,
    required String message,
    VoidCallback? onConfirm,
    String confirmText = "موافق",
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: onConfirm ?? () => Get.back(),
            child: Text(
              confirmText,
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
