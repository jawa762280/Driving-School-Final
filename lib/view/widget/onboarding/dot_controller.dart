import 'package:driving_school/controller/onboarding_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/data/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DotController extends StatelessWidget {
  const DotController({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            onboardingList.length,
            (index) => AnimatedContainer(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              duration: const Duration(milliseconds: 300),
              width: controller.currentpage == index ? 20.w : 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: controller.currentpage == index
                    ? AppColors.primaryColor
                    : Colors.white.withAlpha((0.5 * 225).toInt()),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
