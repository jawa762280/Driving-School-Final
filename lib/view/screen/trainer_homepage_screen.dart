import 'package:driving_school/core/constant/appimages.dart';
import 'package:driving_school/main.dart';
import 'package:driving_school/view/widget/my_appbar.dart';
import 'package:driving_school/view/widget/trainer_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainerHomePageScreen extends StatelessWidget {
  const TrainerHomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  MyAppBar(
                    image: Image.asset(AppImages.appPhoto),
                    widget: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'http${data.read('user')['image'].toString().split('http').last}'))),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    'مرحباً بك يا ${data.read('user')['first_name']}',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  TrainerServices(),
                ],
              ),
            ),
          )),
        ));
  }
}
