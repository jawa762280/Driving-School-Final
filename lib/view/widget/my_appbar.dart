import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key, required this.image, required this.widget});
  final Image image;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 65.w,
            height: 65.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: image,
          ),
          Row(
            children: [
              SizedBox(width: 10.w),
              IconButton(
                icon: Icon(
                  Icons.notifications_active_outlined,
                  size: 28.sp,
                  color: AppColors.primaryColor,
                ),
                onPressed: () {
                  Get.toNamed(AppRouts.notificationsScreen);
                },
              ),
              widget,
            ],
          ),
        ],
      ),
    );
  }
}
