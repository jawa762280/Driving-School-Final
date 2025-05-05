import 'package:driving_school/controller/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingTextButton extends GetView<OnboardingController> {
  const OnboardingTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        controller.skip();
      },
      child: Text("Skip", style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
