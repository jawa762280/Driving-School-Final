import 'package:driving_school/controller/forget_password_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/auth/forgetpassword/forget_password_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPasswordController>(
        init: ForgetPasswordController(),
        builder: (controller) => Scaffold(
              backgroundColor: const Color(0xFFF8FAFB),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      AppLogo(),
                      ForgetPasswordContainer(controller: controller)
                    ],
                  ),
                ),
              ),
            ));
  }
}
