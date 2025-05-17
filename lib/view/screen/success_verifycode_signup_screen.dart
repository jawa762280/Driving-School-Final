import 'package:driving_school/controller/success_verifycode_signup_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessVerifyCodeSignUpScreen extends StatelessWidget {
  const SuccessVerifyCodeSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SuccessVerifyCodeSignUpController>(
      init: SuccessVerifyCodeSignUpController(),
      builder: (controller) => Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFB),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppLogo(),
                  SizedBox(height: 20.h),
                  Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      color:
                          AppColors.primaryColor.withAlpha((0.1 * 255).toInt()),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.verified,
                        color: AppColors.primaryColor,
                        size: 90.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "تم التحقق من البريد الإلكتروني بنجاح",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "يمكنك الآن تسجيل الدخول إلى حسابك والاستفادة من خدمات التطبيق",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.goToLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                      ),
                      child: Text(
                        "تسجيل الدخول",
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
