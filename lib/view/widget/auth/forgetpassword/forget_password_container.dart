import 'package:driving_school/controller/forget_password_controller.dart';
import 'package:driving_school/core/functions/validinput.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordContainer extends StatelessWidget {
  final ForgetPasswordController controller;
  const ForgetPasswordContainer({super.key, required this.controller});

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
                "هل نسيت كلمة المرور ",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "ادخل البريد الالكتروني",
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 15.h),
            MyTextformfield(
              valid: (val) => validInput(val, 4, 50, "email"),
              mycontroller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
              filled: true,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "سيتم ارسال رقم التحقق الى البريد ",
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 11.sp,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            MyButton(
              onPressed: () {
                controller.sendEmail();
              },
              text: "ارسال",
            ),
          ],
        ),
      ),
    );
  }
}
