import 'package:driving_school/controller/login_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/functions/validinput.dart';
import 'package:driving_school/view/widget/login/app_logo.dart';
import 'package:driving_school/view/widget/login/login_button.dart';
import 'package:driving_school/view/widget/login/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) => Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AppLogo(),
                  Container(
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
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text("رقم الهاتف",
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          MyTextformfield(
                              valid: (val) {
                                return validInput(val, 4, 12, "phone");
                              },
                              mycontroller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone,
                              filled: true),
                          const SizedBox(height: 16),
                          const Text("كلمة المرور",
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          MyTextformfield(
                              valid: (val) {
                                return validInput(val, 8, 50, "password");
                              },
                              mycontroller: controller.passwordController,
                              obscureText: controller.isShowPass,
                              keyboardType: TextInputType.visiblePassword,
                              prefixIcon: Icons.visibility,
                              onTapIcon: () {
                                controller.showPass();
                              },
                              filled: true),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Obx(() => Checkbox(
                                    value: controller.rememberMe.value,
                                    activeColor: AppColors.primaryColor,
                                    onChanged: (_) =>
                                        controller.toggleRememberMe(),
                                  )),
                              const Text("تذكرني"),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text("هل نسيت كلمة المرور؟"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LoginButton(
                            onPressed: () {
                              controller.login();
                            },
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: TextButton(
                              onPressed: () {},
                              child: Text("لا تملك حساب ؟",
                                  style:
                                      TextStyle(color: AppColors.primaryColor)),
                            ),
                          )
                        ],
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
