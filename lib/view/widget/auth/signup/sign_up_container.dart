import 'package:driving_school/controller/sign_up_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/functions/validinput.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:flutter/material.dart';

class SignUpContainer extends StatelessWidget {
  const SignUpContainer({super.key, required this.controller});
  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                "تسجيل حساب",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Text("الاسم",
                style: TextStyle(color: Colors.grey[800], fontSize: 11)),
            const SizedBox(height: 15),
            MyTextformfield(
              valid: (val) => validInput(val, 3, 30, "username"),
              mycontroller: controller.firstNameController,
              keyboardType: TextInputType.name,
              prefixIcon: Icons.person,
              iconColor: AppColors.primaryColor,
              filled: true,
            ),
            SizedBox(
              height: 16,
            ),
            Text("الكنية",
                style: TextStyle(color: Colors.grey[800], fontSize: 11)),
            const SizedBox(height: 15),
            MyTextformfield(
              valid: (val) => validInput(val, 3, 30, "username"),
              mycontroller: controller.lastNameController,
              keyboardType: TextInputType.name,
              prefixIcon: Icons.person_2_outlined,
              iconColor: AppColors.primaryColor,
              filled: true,
            ),
            SizedBox(
              height: 16,
            ),
            Text("البريد الالكتروني",
                style: TextStyle(color: Colors.grey[800], fontSize: 11)),
            const SizedBox(height: 15),
            MyTextformfield(
              valid: (val) => validInput(val, 4, 50, "email"),
              mycontroller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
              iconColor: AppColors.primaryColor,
              filled: true,
            ),
            const SizedBox(height: 16),
            Text("كلمة المرور",
                style: TextStyle(color: Colors.grey[800], fontSize: 12)),
            const SizedBox(height: 15),
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
            SizedBox(
              height: 30,
            ),
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
