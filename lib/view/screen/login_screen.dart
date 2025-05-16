import 'package:driving_school/controller/login_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/auth/login/login_container.dart';
import 'package:driving_school/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: Obx(() => Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      AppLogo(),
                      SizedBox(height: 40.h),
                      LoginContainer(),
                    ],
                  ),
                ),
                if (controller.isLoading.value) const Loading(),
              ],
            )),
      ),
    );
  }
}
