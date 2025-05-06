import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/login_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/functions/validinput.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';

class LoginContainer extends StatelessWidget {
  final LoginController controller;

  const LoginContainer({super.key, required this.controller});

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
                "تسجيل الدخول",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Text("رقم الهاتف",
                style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            const SizedBox(height: 15),
            MyTextformfield(
              valid: (val) => validInput(val, 4, 20, "phone"),
              mycontroller: controller.phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone,
              filled: true,
            ),
              const SizedBox(height: 16),
            Text("كلمة المرور",
                style: TextStyle(color: Colors.grey[800], fontSize: 12)),
            const SizedBox(height: 15),
            MyTextformfield(
              valid: (val) => validInput(val, 8, 50, "password"),
              mycontroller: controller.passwordController,
              obscureText: controller.isShowPass,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: Icons.visibility,
              onTapIcon: () => controller.showPass(),
              filled: true,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Obx(() => Checkbox(
                      value: controller.rememberMe.value,
                      activeColor: AppColors.primaryColor,
                      onChanged: (_) => controller.toggleRememberMe(),
                    )),
                const Text("تذكرني"),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    controller.goTOForgetPassword();
                  },
                  child: const Text("هل نسيت كلمة المرور؟"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            MyButton(
              onPressed: () => controller.login(),
              icon: Icons.arrow_back,
              text: "تسجيل الدخول",
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text("لا تملك حساب ؟",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
