import 'package:driving_school/controller/choose_otomatik_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/view/widget/loading.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChooseOtomatikScreen extends StatelessWidget {
  const ChooseOtomatikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat arNumber = NumberFormat.decimalPattern('ar');

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
          body: controller.isLoading.value
              ? const Loading()
              : ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  children: [
                    buildSectionTitle("⏰ اختر الوقت"),
                    buildBox(
                      child: buildTimeButton(
                        controller.formatTime(controller.startTime.value),
                        () => controller.pickTime(isStartTime: true),
                        Icons.access_time,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    buildSectionTitle("📅 اختر التاريخ "),
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
                            selected:
                                controller.trainingType == 'special_needs',
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
                    SizedBox(height: 25.h),
                    buildSectionTitle("🚦 اختر نوع الفيتيس"),
                    Row(
                      children: [
                        Expanded(
                          child: buildTrainingOption(
                            selected: controller.vitesType == 'automatic',
                            label: 'أوتوماتيك',
                            icon: Icons.transform_outlined,
                            onTap: () {
                              controller.vitesType = 'automatic';
                              controller.update();
                            },
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: buildTrainingOption(
                            selected: controller.vitesType == 'manual',
                            label: 'عادي',
                            icon: Icons.width_normal_outlined,
                            onTap: () {
                              controller.vitesType = 'manual';
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

                    // 👇 هنا التصميم الجديد للجلسات
                    if (controller.sessions.isNotEmpty)
                      ...controller.sessions.map((session) {
                        final String status = session['status'] ?? '';
                        final bool isAvailable = status == 'available';

                        // قراءة السعر (registration_fee) بأمان
                        num? fee;
                        final rawFee = session['registration_fee'];
                        if (rawFee is num) {
                          fee = rawFee;
                        } else if (rawFee != null) {
                          fee = num.tryParse(rawFee.toString());
                        }
                        final String feeText =
                            (fee != null) ? arNumber.format(fee) : '—';

                        return GestureDetector(
                          onTap: () => controller.selectSessions(session),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                            margin: EdgeInsets.only(bottom: 18.h),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.grey.shade100,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // السعر في أعلى يمين البطاقة
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.event_available,
                                        size: 28,
                                        color: AppColors.primaryColor),
                                    if (isAvailable)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primaryColor
                                                  .withOpacity(0.9),
                                              AppColors.primaryColor
                                                  .withOpacity(0.7),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Text(
                                          fee != null ? "$feeText ل.س" : "—",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 12),

                                // الوقت والتاريخ
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        color: AppColors.primaryColor,
                                        size: 22),
                                    SizedBox(width: 8),
                                    Text(
                                      "${session['start_time']} - ${session['end_time']}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        color: Colors.grey.shade600, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      "${session['session_date']}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),

                                // حالة الجلسة
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: getStatusBackgroundColor(status),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      getStatusText(status),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: getStatusTextColor(status),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    else if (controller.hasFetched)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy,
                                color: Colors.grey.shade400, size: 60),
                            SizedBox(height: 12.h),
                            Text(
                              "لا توجد جلسات متاحة حالياً",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "حاول اختيار وقت أو تاريخ مختلف",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

Widget buildSectionTitle(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      title,
      style: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
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
