import 'package:driving_school/controller/success_reset_password_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:get/get.dart';

class SuccessResetPasswordScreen extends StatelessWidget {
  const SuccessResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SuccessResetPasswordController>(
        init: SuccessResetPasswordController(),
        builder: (controller) => Scaffold(
              backgroundColor: const Color(0xFFF8FAFB),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppLogo(),
                      const SizedBox(height: 40),
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor
                              .withAlpha((0.1 * 255).toInt()),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.verified,
                            color: AppColors.primaryColor,
                            size: 90,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "تم تغيير كلمة المرور بنجاح",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.goToLogin();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "تسجيل الدخول",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
