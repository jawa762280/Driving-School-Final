import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/training_sessions_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';

class TrainingSessionsScreen extends StatelessWidget {
  final controller = Get.put(TrainingSessionsController());

  TrainingSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          "جدول الجلسات",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primaryColor),
                SizedBox(height: 16),
                Text(
                  "جارٍ تحميل الجلسات...",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        if (controller.sessionsData.isEmpty) {
          return const Center(child: Text("لا توجد جلسات متاحة حالياً"));
        }

        return SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15),
              buildDaySelector(),
              const SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: buildSessionsTable(controller),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildDaySelector() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: controller.sessionsData.length,
        itemBuilder: (context, index) {
          final day = controller.sessionsData[index];
          final isSelected = controller.selectedDayIndex.value == index;

          return GestureDetector(
            onTap: () => controller.selectDay(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day['day_name'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    day['date'],
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSessionsTable(TrainingSessionsController controller) {
    final day = controller.sessionsData[controller.selectedDayIndex.value];
    final sessions = day['sessions'] as List<dynamic>;

    if (sessions.isEmpty) {
      return const Center(child: Text("لا توجد جلسات في هذا اليوم."));
    }

    return ListView.separated(
      itemCount: sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final session = sessions[index];
        final status = session['status'];

        final isAvailable = status == 'available';
        final start = session['start_time'].substring(0, 5);
        final end = session['end_time'].substring(0, 5);

        return GestureDetector(
          onTap: (!controller.isTrainer && isAvailable)
              ? () {
                  Get.toNamed(AppRouts.carsScreen, arguments: {
                    'mode': 'booking',
                    'session_id': session['id'],
                  });
                  Get.snackbar(
                    "تم اختيار الجلسة",
                    "من $start إلى $end",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.black,
                    borderRadius: 12,
                    margin: const EdgeInsets.all(12),
                  );
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isAvailable ? Colors.white : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isAvailable ? AppColors.primaryColor : Colors.grey.shade400,
                width: 1.4,
              ),
              boxShadow: [
                if (isAvailable && !controller.isTrainer)
                  BoxShadow(
                    color:
                        AppColors.primaryColor.withAlpha((0.1 * 255).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$start - $end',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isAvailable
                          ? AppColors.primaryColor
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusBackgroundColor(status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusTextColor(status),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStatusText(String status) {
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

  Color _getStatusTextColor(String status) {
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

  Color _getStatusBackgroundColor(String status) {
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
}
