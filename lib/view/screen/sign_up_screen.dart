import 'package:driving_school/controller/sign_up_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/auth/signup/sign_up_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
        init: SignUpController(),
        builder: (controller) => Scaffold(
              backgroundColor: const Color(0xFFF8FAFB),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      AppLogo(),
                      SignUpContainer(controller: controller)
                    ],
                  ),
                ),
              ),
            ));
  }
}
