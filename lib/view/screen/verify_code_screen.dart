import 'package:driving_school/controller/verifycode_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/auth/verifycode/verifycode_container.dart';
import 'package:driving_school/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyCodeController());
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: Obx(
          () => Stack(children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppLogo(),
                  VerifycodeContainer(),
                ],
              ),
            ),
            if (controller.isLoading.value) const Loading()
          ]),
        ),
      ),
    );
  }
}
