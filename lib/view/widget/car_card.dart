import 'package:driving_school/controller/booking_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/appimages.dart';
import 'package:driving_school/data/model/car_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CarCard extends StatelessWidget {
  final CarModel car;
  final bool? dialogAvaliable;
  final Widget? orDialog;

  const CarCard(
      {super.key, required this.car, this.dialogAvaliable, this.orDialog});

  @override
  Widget build(BuildContext context) {
    Get.put(BookingController());
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).toInt()),
            blurRadius: 6.r,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: car.image != null
                    ? Image.network(car.image!,
                        width: 90.w, height: 90.h, fit: BoxFit.cover)
                    : Container(
                        width: 90.w,
                        height: 90.h,
                        color: Colors.grey.shade200,
                        child: Image.asset(
                          car.isForSpecialNeeds
                              ? AppImages.specialneedscar
                              : AppImages.car,
                        ),
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${car.make} ${car.model} (${car.year})',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    SizedBox(height: 4.h),
                    Text('لوحة: ${car.licensePlate}',
                        style: TextStyle(fontSize: 13.sp)),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.palette, size: 16.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(car.color),
                        SizedBox(width: 10.w),
                        Icon(Icons.settings, size: 16.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(car.transmission),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: car.isForSpecialNeeds
                            ? Colors.deepPurple.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(car.displayType,
                          style: TextStyle(fontSize: 12.sp)),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 16.h),
          dialogAvaliable == false
              ? orDialog!
              : Center(
                  child: car.status == 'available'
                      ? ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "تأكيد",
                              middleText:
                                  "هل تريد حجز هذه السيارة للجلسة المختارة؟",
                              textConfirm: "نعم",
                              textCancel: "إلغاء",
                              buttonColor: AppColors.primaryColor,
                              onConfirm: () {
                                Get.back();
                                final bookingController =
                                    Get.find<BookingController>();
                                bookingController.bookTrainingSession(car.id);
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.w, vertical: 10.h),
                          ),
                          child: Text(
                            "اختيار",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "محجوزة",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
        ],
      ),
    );
  }
}
