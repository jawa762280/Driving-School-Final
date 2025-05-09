import 'package:driving_school/controller/verify_code_sign_up_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class VerifyCodeSignUpScreen extends StatelessWidget {
  const VerifyCodeSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyCodeSignUpController>(
      init: VerifyCodeSignUpController(),
      builder: (controller) => Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                AppLogo(),
                const SizedBox(height: 18),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        AppColors.primaryColor.withAlpha((0.1 * 255).toInt()),
                  ),
                  child: Icon(Icons.email_outlined,
                      size: 60, color: AppColors.primaryColor),
                ),
                const SizedBox(height: 22),
                const Text(
                  "تأكيد البريد الإلكتروني",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "تم إرسال رمز تحقق إلى بريدك الإلكتروني\nالرجاء إدخاله أدناه",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 25),
                OtpTextField(
                  fieldWidth: 45,
                  borderRadius: BorderRadius.circular(12),
                  numberOfFields: 5,
                  borderColor: AppColors.primaryColor,
                  focusedBorderColor: AppColors.primaryColor,
                  showFieldAsBox: true,
                  onSubmit: (String verificationCode) {
                    controller.code = verificationCode;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.submit();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "تأكيد",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    controller.resendCode();
                  },
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
          ),
        ),
      ),
    );
  }
}
