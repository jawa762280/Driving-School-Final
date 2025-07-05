import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/practical_exam_controller.dart';
import '../../core/constant/appcolors.dart';

class PracticalExamScreen extends StatelessWidget {
  const PracticalExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticalExamController>(
      init: PracticalExamController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF6F7FA),
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            title: const Text(
              'موعد الاختبار العملي',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.getMyPracticalExams(),
              )
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.exams.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.schedule_outlined, size: 90, color: Colors.grey),
                    SizedBox(height: 16),
                    Text("لا يوجد موعد اختبار حالي",
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              );
            }

            final exam = controller.exams.first;
            final DateTime dateTime = DateTime.parse(
              '${exam['exam_date']} ${exam['exam_time']}',
            );

            final String formattedDate =
                DateFormat('EEEE، d MMMM yyyy', 'ar').format(dateTime);
            final String formattedTime =
                DateFormat('hh:mm a', 'ar').format(dateTime);

            final daysLeft = dateTime.difference(DateTime.now()).inDays;
            final statusText = _getStatusText(exam['status']);
            final Color statusColor = _getStatusColor(exam['status']);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_car_filled,
                            size: 28, color: AppColors.primaryColor),
                        const SizedBox(width: 10),
                        const Text(
                          'اختبار القيادة العملي',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    _infoRow(Icons.calendar_month, "التاريخ", formattedDate),
                    const SizedBox(height: 12),
                    _infoRow(Icons.access_time_filled, "الوقت", formattedTime),
                    const SizedBox(height: 12),
                    _infoRow(Icons.check_circle, "الحالة", statusText,
                        iconColor: statusColor),
                    const SizedBox(height: 12),
                    _infoRow(Icons.hourglass_bottom, "الوقت المتبقي",
                        daysLeft <= 0 ? "اليوم" : "$daysLeft يوم"),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String title, String value,
      {Color iconColor = Colors.grey}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: iconColor),
        const SizedBox(width: 8),
        Text(
          "$title: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF444444),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'scheduled':
        return 'مجدول';
      case 'completed':
        return 'تم';
      case 'missed':
        return 'لم يحضر';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'missed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
