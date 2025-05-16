import 'package:driving_school/controller/student_homepage_controller.dart';
import 'package:driving_school/core/constant/appimages.dart';
import 'package:driving_school/view/widget/buttomappbar.dart';
import 'package:driving_school/view/widget/my_appbar.dart';
import 'package:driving_school/view/widget/student_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StudentHomePageScreen extends StatelessWidget {
  const StudentHomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StudentHomepageController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyAppBar(image: Image.asset(AppImages.appPhoto)),
                  SizedBox(height: 20.h),
                  Text(
                    'مرحباً بك يا جوى',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  StudentServices(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
