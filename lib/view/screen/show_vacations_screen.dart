import 'package:driving_school/controller/show_vacations_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowVacationsScreen extends StatelessWidget {
  final controller = Get.put(ShowVacationsController());

  ShowVacationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F6),
      appBar: AppBar(
        title: const Text("إجازاتي", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white), 

        backgroundColor: AppColors.primaryColor,
        elevation: 3,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(controller.errorMessage.value,
                style: const TextStyle(fontSize: 16, color: Colors.red)),
          );
        }

        if (controller.vacations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 100, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text("لا توجد إجازات بعد",
                    style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.vacations.length,
          itemBuilder: (_, index) {
            final vacation = controller.vacations[index];
            final status = vacation['status'];
            final statusData = _getStatusData(status);
            final date = DateTime.parse(vacation['date']);
            final formattedDate = DateFormat.yMMMMEEEEd('ar').format(date);
            final reason = vacation['reason'] ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusData.color.withAlpha((0.15 * 255).toInt()),
                  ),
                  child:
                      Icon(statusData.icon, size: 30, color: statusData.color),
                ),
                title: Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1C1C1C),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    reason,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusData.color.withAlpha((0.15 * 255).toInt()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusData.label,
                    style: TextStyle(
                      color: statusData.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  _VacationStatus _getStatusData(String status) {
    switch (status) {
      case 'approved':
        return _VacationStatus(
            label: "مقبولة",
            color: Colors.green,
            icon: Icons.check_circle_rounded);
      case 'rejected':
        return _VacationStatus(
            label: "مرفوضة", color: Colors.red, icon: Icons.cancel_rounded);
      case 'pending':
      default:
        return _VacationStatus(
            label: "قيد الانتظار",
            color: Colors.orange,
            icon: Icons.hourglass_top_rounded);
    }
  }
}

class _VacationStatus {
  final String label;
  final Color color;
  final IconData icon;

  _VacationStatus(
      {required this.label, required this.color, required this.icon});
}
