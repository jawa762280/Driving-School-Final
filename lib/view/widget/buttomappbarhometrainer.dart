import 'package:driving_school/controller/trainer_homepage_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Buttomappbarhometrainer extends StatelessWidget {
  const Buttomappbarhometrainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainerHomepageController>(
        init: TrainerHomepageController(),
        builder: (controller) {
          return Scaffold(
            body: Center(
              child: controller.pages.elementAt(controller.currentpage),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.currentpage,
              unselectedItemColor: AppColors.grey,
              selectedItemColor: AppColors.primaryColor,
              type: BottomNavigationBarType.fixed,
              onTap: (i) {
                controller.changPage(i);
              },
              items: [
                BottomNavigationBarItem(
                  label: 'الرئيسية',
                  icon: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.green900,
                      border: Border.all(
                        color: controller.currentpage == 0
                            ? AppColors.primaryColor
                            : AppColors.grey,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/home.svg',
                      // ignore: deprecated_member_use
                      color: controller.currentpage == 0
                          ? AppColors.primaryColor
                          : AppColors.grey,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'الملف الشخصي',
                  icon: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.green900,
                      border: Border.all(
                        color: controller.currentpage == 1
                            ? AppColors.primaryColor
                            : AppColors.grey,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/profile.svg',
                      // ignore: deprecated_member_use
                      color: controller.currentpage == 1
                          ? AppColors.primaryColor
                          : AppColors.grey,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'البحث',
                  icon: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.green900,
                      border: Border.all(
                        color: controller.currentpage == 2
                            ? AppColors.primaryColor
                            : AppColors.grey,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/search.svg',
                      // ignore: deprecated_member_use
                      color: controller.currentpage == 2
                          ? AppColors.primaryColor
                          : AppColors.grey,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'الطلبات',
                  icon: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.green900,
                      border: Border.all(
                        color: controller.currentpage == 3
                            ? AppColors.primaryColor
                            : AppColors.grey,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/orders.svg',
                      // ignore: deprecated_member_use
                      color: controller.currentpage == 3
                          ? AppColors.primaryColor
                          : AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
