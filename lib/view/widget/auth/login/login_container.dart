import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/login_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/functions/validinput.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginContainer extends StatelessWidget {
  const LoginContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).toInt()),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Form(
          key: controller.formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "البريد الالكتروني",
                style: TextStyle(color: Colors.grey[700], fontSize: 12.sp),
              ),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(val, 4, 50, "email"),
                mycontroller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
                iconColor: AppColors.primaryColor,
                filled: true,
              ),
              SizedBox(height: 16.h),
              Text(
                "كلمة المرور",
                style: TextStyle(color: Colors.grey[800], fontSize: 12.sp),
              ),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(val, 8, 50, "password"),
                mycontroller: controller.passwordController,
                obscureText: controller.isShowPass,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icons.visibility,
                iconColor: AppColors.primaryColor,
                onTapIcon: () => controller.showPass(),
                filled: true,
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Obx(() => Checkbox(
                        value: controller.rememberMe.value,
                        activeColor: AppColors.primaryColor,
                        onChanged: (_) => controller.toggleRememberMe(),
                      )),
                  Text(
                    "تذكرني",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      controller.goTOForgetPassword();
                    },
                    child: Text(
                      "هل نسيت كلمة المرور؟",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              MyButton(
                onPressed: () => controller.login(),
                icon: Icons.arrow_back,
                text: "تسجيل الدخول",
              ),
              SizedBox(height: 12.h),
              Center(
                child: TextButton(
                  onPressed: () {
                    controller.goToSignUp();
                  },
                  child: Text(
                    "لا تملك حساب ؟",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
