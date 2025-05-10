import 'package:driving_school/controller/sign_up_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/functions/validinput.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpContainer extends StatelessWidget {
  const SignUpContainer({super.key, required this.controller});
  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 12.w,
            offset: Offset(0, 4.w),
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
                "تسجيل حساب",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24.h),
            Text("الاسم",
                style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
            SizedBox(height: 15.h),
            MyTextformfield(
              valid: (val) => validInput(val, 3, 30, "username"),
              mycontroller: controller.firstNameController,
              keyboardType: TextInputType.name,
              prefixIcon: Icons.person,
              iconColor: AppColors.primaryColor,
              filled: true,
            ),
            SizedBox(height: 16.h),
            Text("الكنية",
                style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
            SizedBox(height: 15.h),
            MyTextformfield(
              valid: (val) => validInput(val, 3, 30, "username"),
              mycontroller: controller.lastNameController,
              keyboardType: TextInputType.name,
              prefixIcon: Icons.person_2_outlined,
              iconColor: AppColors.primaryColor,
              filled: true,
            ),
            SizedBox(height: 16.h),
            Text("البريد الالكتروني",
                style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
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
            Text("كلمة المرور",
                style: TextStyle(color: Colors.grey[800], fontSize: 12.sp)),
            SizedBox(height: 15.h),
            MyTextformfield(
              valid: (val) => validInput(val, 8, 50, "password"),
              mycontroller: controller.passController,
              obscureText: controller.isShowPass,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: Icons.visibility,
              iconColor: AppColors.primaryColor,
              onTapIcon: () => controller.showPass(),
              filled: true,
            ),
            SizedBox(height: 30.h),
            MyButton(
              onPressed: () {
                controller.signUp();
              },
              text: "حفظ",
            ),
          ],
        ),
      ),
    );
  }
}
