import 'package:driving_school/controller/resetpassword_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/auth/resetpassword/reset_password_container.dart';
import 'package:driving_school/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        body: SafeArea(
          child: Obx(
            () => Stack(children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [AppLogo(), ResetPasswordContainer()],
                ),
              ),
              if (controller.isLoading.value) const Loading(),
            ]),
          ),
        ),
      ),
    );
  }
}
