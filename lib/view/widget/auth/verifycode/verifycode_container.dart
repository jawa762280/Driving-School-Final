import 'package:driving_school/controller/verifycode_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifycodeContainer extends StatelessWidget {
  const VerifycodeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyCodeController>(
      builder: (controller) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 12.w,
              offset: Offset(0, 4.w),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 32.h),
            Text(
              "أدخل رمز التحقق",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            Text(
              "لقد أرسلنا رمز تحقق مكون من 6 أرقام إلى بريدك الإلكتروني",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            OtpTextField(
              fieldWidth: 39.w,
              borderRadius: BorderRadius.circular(12.w),
              numberOfFields: 6,
              borderColor: AppColors.primaryColor,
              focusedBorderColor: AppColors.primaryColor,
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                controller.code = code;
              },
              onSubmit: (String code) {
                controller.code = code;
              },
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                ),
                onPressed: () {
                  controller.submit();
                },
                child: Text(
                  "تأكيد",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20.h),
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
      ),
    );
  }
}
