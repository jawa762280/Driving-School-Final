import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/auth/signup/sign_up_container.dart';
import 'package:driving_school/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpdateInformationScreen extends StatelessWidget {
  const UpdateInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    AppLogo(),
                    UpdateInformationScreen(),
                  ],
                ),
              ),
              // if (controller.isLoading.value) const Loading(),
            ]),
          ),
        ),
      ),
    );
  }
}
