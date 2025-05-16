import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key, required this.image});
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      width: double.infinity,
      height: 60.h,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 55.w,
            height: 55.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: image,
          ),
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.person, size: 30.sp, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
