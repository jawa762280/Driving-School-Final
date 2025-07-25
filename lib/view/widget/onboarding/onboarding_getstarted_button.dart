import 'package:driving_school/controller/onboarding_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingGetstartedButton extends GetView<OnboardingController> {
  const OnboardingGetstartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40.h,
      left: 24.w,
      right: 24.w,
      child: SizedBox(
        height: 53.h,
        child: ElevatedButton(
          onPressed: () {
            controller.next();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: const Color.fromARGB(255, 148, 140, 140),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Get Started",
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10.w,
              ),
              Icon(
                Icons.arrow_forward_sharp,
                size: 20.sp,
              )
            ],
          ),
        ),
      ),
    );
  }
}
