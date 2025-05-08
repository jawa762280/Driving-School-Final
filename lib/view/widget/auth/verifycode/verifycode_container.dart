import 'package:driving_school/controller/verifycode_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerifycodeContainer extends StatelessWidget {
  const VerifycodeContainer({super.key, required this.controller});
  final VerifycodeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          const Text(
            "أدخل رمز التحقق",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            "لقد أرسلنا رمز تحقق مكون من 5 أرقام إلى بريدك الإلكتروني",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          OtpTextField(
            fieldWidth: 45,
            borderRadius: BorderRadius.circular(12),
            numberOfFields: 5,
            borderColor: AppColors.primaryColor,
            focusedBorderColor: AppColors.primaryColor,
            showFieldAsBox: true,
            onCodeChanged: (String code) {
              // يتم التحديث عند تغيير أي خانة
              controller.code = code;
            },
            onSubmit: (String code) {
              // عند إدخال الخمس خانات، يتم فقط الحفظ وليس التوجيه
              controller.code = code;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                controller.submit();
              },
              child: const Text(
                "تأكيد",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: controller.resendCode,
            child: Text(
              "إعادة إرسال الرمز؟",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
