import 'package:driving_school/controller/student_homepage_controller.dart';
import 'package:driving_school/view/widget/inkwellbottomappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomAppbarHome extends StatelessWidget {
  const BottomAppbarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentHomepageController>(
      builder: (controller) => BottomAppBar(
        // shape: const CircularNotchedRectangle(),
        // notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkwellBottomAppbarHome(
                active: controller.currentpage == 0 ? true : false,
                textIcon: "الرئيسية",
                icon: Icons.home_outlined,
                onTap: () {
                  controller.changPage(0);
                }),
            InkwellBottomAppbarHome(
                active: controller.currentpage == 1 ? true : false,
                textIcon: "الملف الشخصي",
                icon: Icons.person_2_outlined,
                onTap: () {
                  controller.changPage(1);
                }),
            InkwellBottomAppbarHome(
                active: controller.currentpage == 2 ? true : false,
                textIcon: "البحث",
                icon: Icons.search,
                onTap: () {
                  controller.changPage(2);
                }),
            InkwellBottomAppbarHome(
                active: controller.currentpage == 3 ? true : false,
                textIcon: "الطلبات",
                icon: Icons.assignment,
                onTap: () {
                  controller.changPage(3);
                })
          ],
        ),
      ),
    );
  }
}
