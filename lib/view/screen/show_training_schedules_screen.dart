import 'package:driving_school/controller/show_training_schedules_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/constant/appcolors.dart';

class ShowTRainingSchedulesScreen extends StatelessWidget {
  const ShowTRainingSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShowTrainingSchedulesController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "جداول التدريب",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        final role = controller.data.read('role') ?? '';
        final isTrainer = role == 'trainer';

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.scheduleList.isEmpty) {
          return const Center(
            child: Text(
              "لا توجد جداول حالياً",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.scheduleList.length,
          itemBuilder: (context, index) {
            final item = controller.scheduleList[index];
            return isTrainer
                ? _buildTrainerCard(item)
                : _buildStudentCard(item);
          },
        );
      }),
    );
  }

  Widget _buildTrainerCard(Map<String, dynamic> item) {
    final isActive = item['status'] == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? AppColors.primaryColor : Colors.redAccent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "اليوم: ${getDayName(item['day_key'])}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryColor : Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? "نشط" : "غير نشط",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "الوقت: ${item['start_time']} - ${item['end_time']}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.repeat_rounded, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "التكرار: ${(item['is_recurring'] ?? false) ? "متكرر" : "مرة واحدة"}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FontAwesomeIcons.calendarCheck,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "الصلاحية: من ${item['valid_from'] ?? "-"} إلى ${item['valid_to'] ?? "-"}",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "اليوم: ${getDayName(item['day_key'])}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "الوقت: ${item['time_range']}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getDayName(String? dayKey) {
    switch (dayKey) {
      case 'saturday':
        return 'السبت';
      case 'sunday':
        return 'الأحد';
      case 'monday':
        return 'الاثنين';
      case 'tuesday':
        return 'الثلاثاء';
      case 'wednesday':
        return 'الأربعاء';
      case 'thursday':
        return 'الخميس';
      case 'friday':
        return 'الجمعة';
      default:
        return '-';
    }
  }
}
