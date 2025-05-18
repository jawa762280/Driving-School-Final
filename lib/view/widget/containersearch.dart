import 'package:driving_school/core/constant/appimages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerSearch extends StatelessWidget {
  const ContainerSearch({
    super.key,
    required this.image,
    required this.name,
    required this.email,
    required this.adressText,
    required this.adress,
    required this.phone,
    required this.phoneText,
    required this.birthdayText,
    required this.birthday,
  });

  final String image;
  final String name;
  final String email;
  final String adressText;
  final String adress;
  final String phoneText;
  final String phone;
  final String birthdayText;
  final String birthday;

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> buildImageProvider(String imagePath) {
      if (imagePath.startsWith('http')) {
        return NetworkImage(imagePath);
      } else {
        return AssetImage(AppImages.defaultUser);
      }
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundImage: buildImageProvider(image),
                onBackgroundImageError: (_, __) =>
                    const Icon(Icons.broken_image),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(thickness: 1, color: Colors.grey.shade200),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    adressText,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    adress,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    phoneText,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    phone,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    birthdayText,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    birthday,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
