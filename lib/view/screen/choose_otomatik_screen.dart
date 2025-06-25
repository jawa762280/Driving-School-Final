import 'package:driving_school/controller/choose_otomatik_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChooseOtomatikScreen extends StatelessWidget {
  const ChooseOtomatikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ChooseOtomatikController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "حجز اوتوماتيك",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primaryColor,
            elevation: 2,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            children: [
              buildSectionTitle("⏰ اختر وقت البداية"),
              buildBox(
                child: buildTimeButton(
                  controller.formatTime(controller.startTime.value),
                  () => controller.pickTime(isStartTime: true),
                  Icons.access_time,
                ),
              ),
              SizedBox(height: 25.h),
              buildSectionTitle("📅 اختر تاريخ البداية"),
              buildBox(
                child: buildTimeButton(
                  controller.formatDate(controller.startDate.value),
                  () => controller.pickDate(isFrom: false),
                  Icons.calendar_today,
                ),
              ),
              SizedBox(height: 25.h),
              buildSectionTitle("🚦 اختر نوع التدريب"),
              Row(
                children: [
                  Expanded(
                    child: buildTrainingOption(
                      selected: controller.trainingType == 'normal',
                      label: 'عادي',
                      icon: Icons.directions_car,
                      onTap: () {
                        controller.trainingType = 'normal';
                        controller.update();
                      },
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: buildTrainingOption(
                      selected: controller.trainingType == 'special_needs',
                      label: 'احتياجات خاصة',
                      icon: Icons.accessibility,
                      onTap: () {
                        controller.trainingType = 'special_needs';
                        controller.update();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              MyButton(
                text: '🔍 عرض الجلسات المقترحة',
                onPressed: () => controller.getSessions(),
              ),
              SizedBox(height: 20.h),
              if (controller.sessions.isNotEmpty)
                ...controller.sessions.map((session) {
                  final status = session['status'];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: AppColors.primaryColor
                              .withAlpha((0.5 * 255).toInt())),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.event, color: AppColors.primaryColor),
                      title: Text(
                        "${session['start_time']} - ${session['end_time']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text("🗓 ${session['session_date']}"),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getStatusBackgroundColor(status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          getStatusText(status),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: getStatusTextColor(status),
                          ),
                        ),
                      ),
                    ),
                  );
                })
              else
                Center(
                  child: Text(
                    "لا توجد جلسات بعد",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87),
      ),
    );
  }

  Widget buildBox({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }

  Widget buildTimeButton(String text, VoidCallback onTap, IconData icon) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        text,
        style: TextStyle(fontSize: 15.sp),
      ),
      trailing: Icon(Icons.edit_calendar, color: Colors.grey),
    );
  }

  Widget buildTrainingOption({
    required bool selected,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.white : AppColors.primaryColor),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getStatusBackgroundColor(String status) {
    switch (status) {
      case 'available':
        return AppColors.primaryColor.withAlpha(40);
      case 'booked':
        return Colors.grey.shade500;
      case 'vacation':
        return Colors.orange.shade100;
      case 'completed':
        return Colors.green.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'available':
        return AppColors.primaryColor;
      case 'booked':
        return Colors.white;
      case 'vacation':
        return Colors.orange.shade700;
      case 'completed':
        return Colors.green.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'available':
        return 'متاح';
      case 'booked':
        return 'محجوز';
      case 'vacation':
        return 'عطلة';
      case 'completed':
        return 'مكتملة';
      case 'cancelled':
        return 'ملغاة';
      default:
        return 'غير معروف';
    }
  }
}
