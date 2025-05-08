import 'package:driving_school/controller/verifycode_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/auth/verifycode/verifycode_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifycodeController>(
      init: VerifycodeController(),
      builder: (controller) => Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppLogo(),
                VerifycodeContainer(controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
