import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/data/model/trainer_service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TrainerServices extends StatelessWidget {
  const TrainerServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white,
            AppColors.primaryColor.withAlpha((255 * 0.01).toInt()),
          ],  
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الخدمات',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trainerServices.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final service = trainerServices[index];

              return InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () {
                  final routes = [
                    AppRouts.trainerScheduleScreen,
                    AppRouts.showTRainingSchedulesScreen,
                    AppRouts.vacationScreen,
                    AppRouts.showVacationsScreen,
                    AppRouts.creatExamScreen,
                    AppRouts.examHomeScreen,
                    AppRouts.createFalutCar,
                    AppRouts.showCarFaults,
                  ];
                  if (index < routes.length) {
                    Get.toNamed(routes[index]);
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    // boxShadow: [
                    // BoxShadow(
                    //   color: AppColors.primaryColor.withOpacity(0.5),
                    //   blurRadius: 12,
                    //   offset: Offset(0, 6),
                    // ),
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 65.w,
                        height: 65.w,
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Image.asset(
                          service.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        service.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        service.subtitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
