import 'package:driving_school/controller/verify_code_sign_up_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyCodeSignUpScreen extends StatelessWidget {
  const VerifyCodeSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyCodeSignUpController());
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFB),
          body: SafeArea(
            child: Obx(
              () => Stack(children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      AppLogo(),
                      SizedBox(height: 18.h),
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor
                              .withAlpha((0.1 * 255).toInt()),
                        ),
                        child: Icon(Icons.email_outlined,
                            size: 60.sp, color: AppColors.primaryColor),
                      ),
                      SizedBox(height: 22.h),
                      Text(
                        "تأكيد البريد الإلكتروني",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "تم إرسال رمز تحقق إلى بريدك الإلكتروني\nالرجاء إدخاله أدناه",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 25.h),
                      OtpTextField(
                        fieldWidth: 45.w,
                        borderRadius: BorderRadius.circular(12.w),
                        numberOfFields: 6,
                        borderColor: AppColors.primaryColor,
                        focusedBorderColor: AppColors.primaryColor,
                        showFieldAsBox: true,
                        onSubmit: (String verificationCode) {
                          controller.code = verificationCode;
                        },
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.submit();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                          ),
                          child: Text(
                            "تأكيد",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
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
                if (controller.isLoading.value) const Loading(),
              ]),
            ),
          )),
    );
  }
}
