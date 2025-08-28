import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/training_sessions_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:intl/intl.dart';

class TrainingSessionsScreen extends StatelessWidget {
  final controller = Get.put(TrainingSessionsController());
  final NumberFormat arNumber = NumberFormat.decimalPattern('ar');

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
        iconTheme: const IconThemeData(color: Colors.white),
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
                const SizedBox(height: 16),
                const Text(
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
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor.withOpacity(0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.white,
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
        final session = sessions[index] as Map<String, dynamic>;
        final status = session['status'] as String? ?? 'unknown';
        final isAvailable = status == 'available';

        final start = (session['start_time'] as String).substring(0, 5);
        final end = (session['end_time'] as String).substring(0, 5);

        final num? fee = session['registration_fee'] is num
            ? session['registration_fee'] as num
            : (session['registration_fee'] != null
                ? num.tryParse(session['registration_fee'].toString())
                : null);

        final String feeText = fee != null ? arNumber.format(fee) : '—';

        return GestureDetector(
          onTap: (!controller.isTrainer && isAvailable)
              ? () {
                  Get.toNamed(AppRouts.carsScreen, arguments: {
                    'mode': 'booking',
                    'session_id': session['id'],
                    'registration_fee': fee,
                  });
                  Get.snackbar(
                    "تم اختيار الجلسة",
                    "من $start إلى $end • الرسوم: $feeText",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.black,
                    borderRadius: 12,
                    margin: const EdgeInsets.all(12),
                  );
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _getSessionBackground(status),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // وقت + الحالة
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$start - $end',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _getStatusTextColor(status),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getStatusText(status),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getStatusTextColor(status),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                if (isAvailable)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.9),
                          AppColors.primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.payments_outlined,
                            color: Colors.white, size: 22),
                        const SizedBox(height: 4),
                        Text(
                          fee != null ? "$feeText ل.س" : "—",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "سعر الجلسة",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
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
        return AppColors.primaryColor; // أزرق رئيسي
      case 'booked':
        return Colors.white; // أبيض على الخلفية الرمادية
      case 'vacation':
        return Colors.orange.shade700; // برتقالي غامق
      case 'completed':
        return Colors.green.shade700; // أخضر غامق
      case 'cancelled':
        return Colors.red.shade700; // أحمر غامق
      default:
        return Colors.grey;
    }
  }

  Color _getSessionBackground(String status) {
    switch (status) {
      case 'available':
        return AppColors.primaryColor.withAlpha(40); // أزرق فاتح شفاف
      case 'booked':
        return Colors.grey.shade400; // رمادي متوسط
      case 'vacation':
        return Colors.orange.shade100; // برتقالي فاتح
      case 'completed':
        return Colors.green.shade100; // أخضر فاتح
      case 'cancelled':
        return Colors.red.shade200; // أحمر فاتح
      default:
        return Colors.grey.shade300; // رمادي فاتح
    }
  }
}
