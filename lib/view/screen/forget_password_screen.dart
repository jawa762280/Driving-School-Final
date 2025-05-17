import 'package:driving_school/controller/forget_password_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/auth/forgetpassword/forget_password_container.dart';
import 'package:driving_school/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFB),
          body: SafeArea(
            child: Obx(
              () => Stack(children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        AppLogo(),
                        ForgetPasswordContainer(),
                      ],
                    ),
                  ),
                ),
                if (controller.isLoading.value) const Loading(),
              ]),
            ),
          )),
    );
  }
}
