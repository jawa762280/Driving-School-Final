import 'package:driving_school/controller/resetpassword_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/auth/resetpassword/reset_password_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
        init: ResetPasswordController(),
        builder: (controller) => Scaffold(
              backgroundColor: const Color(0xFFF8FAFB),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      AppLogo(),
                      ResetPasswordContainer(controller:controller )
                    ],
                  ),
                ),
              ),
            ));
  }
}
