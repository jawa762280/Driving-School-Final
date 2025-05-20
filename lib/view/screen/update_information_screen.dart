import 'package:driving_school/controller/update_information_controller.dart';
import 'package:driving_school/view/widget/app_logo.dart';
import 'package:driving_school/view/widget/auth/signup/update_information_container.dart';
import 'package:driving_school/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpdateInformationScreen extends StatelessWidget {
  const UpdateInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateInformationController());
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
                    UpdateInformationContainer(),
                  ],
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
