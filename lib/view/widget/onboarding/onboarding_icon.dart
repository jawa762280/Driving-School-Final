import 'package:driving_school/controller/onboarding_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingIcon extends GetView<OnboardingController> {
  const OnboardingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          controller.next();
        },
        icon: Icon(Icons.keyboard_arrow_right),
        color: Colors.white,
        iconSize: 28,
      ),
    );
  }
}
