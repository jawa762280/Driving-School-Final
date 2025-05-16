import 'package:driving_school/controller/student_homepage_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomAppbarHome extends StatelessWidget {
  const BottomAppbarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentHomepageController>(
        init: StudentHomepageController(),
        builder: (controller) {
          return Scaffold(
            body: Center(
              child: controller.pages.elementAt(controller.currentpage),
            ),
            bottomNavigationBar: BottomNavigationBar(
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
                      color: controller.currentpage == 1
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
                        color: controller.currentpage == 2
                            ? AppColors.primaryColor
                            : AppColors.grey,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/search.svg',
                      color: controller.currentpage == 2
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
                        color: controller.currentpage == 3
                            ? AppColors.primaryColor
                            : AppColors.grey,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/orders.svg',
                      color: controller.currentpage == 3
                          ? AppColors.primaryColor
                          : AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // builder: (controller) => BottomAppBar(
        //   // shape: const CircularNotchedRectangle(),
        //   // notchMargin: 10,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       InkwellBottomAppbarHome(
        //           active: controller.currentpage == 0 ? true : false,
        //           textIcon: "الرئيسية",
        //           icon: Icons.home_outlined,
        //           onTap: () {
        //             controller.changPage(0);
        //           }),
        //       InkwellBottomAppbarHome(
        //           active: controller.currentpage == 1 ? true : false,
        //           textIcon: "الملف الشخصي",
        //           icon: Icons.person_2_outlined,
        //           onTap: () {
        //             controller.changPage(1);
        //           }),
        //       InkwellBottomAppbarHome(
        //           active: controller.currentpage == 2 ? true : false,
        //           textIcon: "البحث",
        //           icon: Icons.search,
        //           onTap: () {
        //             controller.changPage(2);
        //           }),
        //       InkwellBottomAppbarHome(
        //           active: controller.currentpage == 3 ? true : false,
        //           textIcon: "الطلبات",
        //           icon: Icons.assignment,
        //           onTap: () {
        //             controller.changPage(3);
        //           })
        //     ],
        //   ),
        // ),
        );
  }
}
