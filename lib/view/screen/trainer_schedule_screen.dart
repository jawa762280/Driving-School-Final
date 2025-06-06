import 'package:driving_school/controller/trainer_schedule_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/view/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TrainerScheduleScreen extends StatelessWidget {
  const TrainerScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrainerScheduleController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "انشاء جدول تدريب",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white), // <-- هنا لون السهم
        ),
        backgroundColor: Color(0xFFF1F8F4),
        body: SafeArea(
          child: Obx(
            () => Stack(children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha((0.2 * 255).toInt()),
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Text("اختر اليوم"),
                      SizedBox(
                        height: 10.h,
                      ),
                      Form(
                        key: controller.formKey,
                        child: Wrap(
                          spacing: 6.w,
                          children: controller.days.map((day) {
                            final isSelected =
                                controller.selectedDay.value == day;
                            return ChoiceChip(
                              label: Text(day,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black)),
                              selected: isSelected,
                              selectedColor: Colors.green,
                              onSelected: (_) => controller.selectDay(day),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "اختر وقت البداية",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              height: 45,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r)),
                              child: buildTimeButton(
                                controller
                                    .formatTime(controller.startTime.value),
                                () => controller.pickTime(isStartTime: true),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "اختر وقت النهاية",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              height: 45,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r)),
                              child: buildTimeButton(
                                controller.formatTime(controller.endTime.value),
                                () => controller.pickTime(isStartTime: false),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              "الفترة الزمنية المتاحة",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(15.r)),
                                  child: buildTimeButton(
                                    controller
                                        .formatDate(controller.validFrom.value),
                                    () => controller.pickDate(isFrom: true),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(15.r)),
                                  child: buildTimeButton(
                                    controller
                                        .formatDate(controller.validTo.value),
                                    () => controller.pickDate(isFrom: false),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Row(
                                children: [
                                  Checkbox(
                                    activeColor: AppColors.primaryColor,
                                    value: controller.isRecurring.value,
                                    onChanged: (val) => controller
                                        .isRecurring.value = val ?? true,
                                  ),
                                  const Text(
                                    "تكرار الجلسة أسبوعياً",
                                    style: TextStyle(fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton.icon(
                                onPressed: controller.submitSchedule,
                                label: Text(
                                  "حفظ الجدول",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value) const Loading(),
            ]),
          ),
        ),
      ),
    );
  }
}

Widget buildTimeButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey.shade50,
      foregroundColor: Colors.black87,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 14.h),
    ),
    child: Text(text,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
  );
}
