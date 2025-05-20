import 'package:driving_school/controller/resetpassword_controller.dart';
import 'package:driving_school/core/functions/validinput.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordContainer extends StatelessWidget {
  const ResetPasswordContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
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
              const Center(
                child: Text(
                  "اعادة تعيين كلمة المرور",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24.h),
              Text("ادخل كلمة المرور الجديدة",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(val, 8, 50, "password"),
                mycontroller: controller.passController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: controller.isShowPass,
                prefixIcon: Icons.visibility,
                onTapIcon: () => controller.showPass(),
                filled: true,
              ),
              SizedBox(height: 16.h),
              Text("تأكيد كلمة المرور الجديدة",
                  style: TextStyle(color: Colors.grey[800], fontSize: 11.sp)),
              SizedBox(height: 15.h),
              MyTextformfield(
                valid: (val) => validInput(val, 8, 50, "password"),
                mycontroller: controller.rePassController,
                obscureText: controller.isShowRePass,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icons.visibility,
                onTapIcon: () => controller.showRePass(),
                filled: true,
              ),
              SizedBox(height: 30.h),
              MyButton(
                onPressed: () {
                  controller.save();
                },
                text: "حفظ",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
