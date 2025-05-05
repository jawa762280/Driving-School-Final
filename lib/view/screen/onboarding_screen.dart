import 'package:driving_school/controller/onboarding_controller.dart';
import 'package:driving_school/data/model/onboarding_model.dart';
import 'package:driving_school/view/widget/onboarding/dot_controller.dart';
import 'package:driving_school/view/widget/onboarding/onboarding_container.dart';
import 'package:driving_school/view/widget/onboarding/onboarding_getstarted_button.dart';
import 'package:driving_school/view/widget/onboarding/onboarding_icon.dart';
import 'package:driving_school/view/widget/onboarding/onboarding_text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());
    return GetBuilder<OnboardingController>(
      builder: (controller) => Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: controller.pagecontroller,
              onPageChanged: (value) {
                controller.changedpage(value);
              },
              itemCount: onboardingList.length,
              itemBuilder: (context, i) => Stack(
                children: [
                  SizedBox.expand(
                    child: Image.asset(
                      onboardingList[i].image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  OnboardingContainer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 90),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            onboardingList[i].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            onboardingList[i].description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  Colors.white.withAlpha((0.9 * 255).toInt()),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.currentpage == onboardingList.length - 1)
              OnboardingGetstartedButton(),
            if (controller.currentpage != onboardingList.length - 1)
              Positioned(
                bottom: 66,
                right: 24,
                child: const DotController(),
              ),
            if (controller.currentpage != onboardingList.length - 1)
              Positioned(
                bottom: 40,
                left: 24,
                child: Row(
                  children: [OnboardingIcon(), OnboardingTextButton()],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
//  if (controller.currentpage == onboardingList.length - 1)
//                 OnboardingGetstartedButton(),
//               if (controller.currentpage != onboardingList.length - 1)
//                 Positioned(
//                   bottom: 66,
//                   right: 24,
//                   child: const DotController(),
//                 ),
//               if (controller.currentpage != onboardingList.length - 1)
//                 Positioned(
//                   bottom: 40,
//                   left: 24,
//                   child: Row(
//                     children: [OnboardingIcon(), OnboardingTextButton()],
//                   ),
//                 ),
