import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/services/services.dart';
import 'package:driving_school/data/model/onboarding_model.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  int currentpage = 0;
  bool get isLastPage => currentpage == onboardingList.length - 1;

  late PageController pagecontroller;
  MyServices myServices = Get.find();

  changedpage(index) {
    currentpage = index;
    update();
  }

  next() {
    currentpage++;
    if (currentpage > onboardingList.length - 1) {
      data.write("step", "1");
      Get.offAllNamed(AppRouts.loginScreen);
    } else {
      (pagecontroller.animateToPage(currentpage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut));
    }
  }

  skip() {
    Get.toNamed(AppRouts.loginScreen);
  }

  @override
  void onInit() {
    pagecontroller = PageController();
    super.onInit();
  }
}
