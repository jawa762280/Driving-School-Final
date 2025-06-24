import 'package:driving_school/controller/show_training_schedules_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/appimages.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ContainerSearch extends StatelessWidget {
  const ContainerSearch({
    super.key,
    required this.image,
    required this.name,
    required this.email,
    required this.trainerId,
    required this.userRole,
    this.reviews, // 'student' أو 'trainer'
  });

  final String image;
  final String name;
  final String email;
  final int trainerId;
  final String userRole;
  final Widget? reviews;

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
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: buildImageProvider(image),
                backgroundColor: Colors.grey.shade200,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    reviews!,
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.primaryColor),
            ],
          ),
          SizedBox(height: 14.h),
          Divider(thickness: 1, color: Colors.grey.shade200),
          SizedBox(height: 10.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // زر "عرض جداول التدريب" (يظهر للجميع)
              ElevatedButton.icon(
                onPressed: () {
                  // ignore: avoid_print
                  print(
                      "trainerId to fetch schedule: $trainerId"); // طباعة للتأكد من الـ ID

                  final controller =
                      Get.isRegistered<ShowTrainingSchedulesController>()
                          ? Get.find<ShowTrainingSchedulesController>()
                          : Get.put(ShowTrainingSchedulesController());
                  controller.setTrainerId(trainerId);
                  Get.toNamed(AppRouts.showTRainingSchedulesScreen);
                },
                icon: Icon(Icons.table_chart_outlined, size: 18.sp),
                label: Text("عرض جداول التدريب",
                    style: TextStyle(fontSize: 13.sp)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primaryColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              if (userRole ==
                  'student') // زر "حجز جلسة تدريب" (يظهر فقط للطلاب)
                Column(
                  children: [
                    SizedBox(height: 10.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(AppRouts.trainingSessionsScreen,
                            arguments: {
                              'trainer_id': trainerId,
                            });
                      },
                      icon: Icon(Icons.event_available_outlined, size: 18.sp),
                      label: Text("حجز جلسة تدريب",
                          style: TextStyle(fontSize: 13.sp)),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(AppRouts.trainerReviewsScreen, arguments: {
                    'trainer_id': trainerId,
                  });
                },
                icon: Icon(Icons.star_border_sharp, size: 18.sp),
                label: Text("عرض تقييمات المدرب",
                    style: TextStyle(fontSize: 13.sp)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primaryColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}