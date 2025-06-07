import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:driving_school/controller/bookings_sessions_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';

class BookingsSessionsScreen extends StatelessWidget {
  const BookingsSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingsSessionsController());

    return Scaffold(
      backgroundColor: const Color(0xFFEDF6F9),
      appBar: AppBar(
        title: const Text(
          "جلسات الحجز",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 22,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black54,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        if (controller.sessions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note_outlined,
                    size: 110, color: Colors.grey.shade400),
                const SizedBox(height: 20),
                const Text(
                  "لا توجد جلسات حجز حالياً",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: controller.sessions.length,
          itemBuilder: (_, index) {
            final session = controller.sessions[index];
            final sessionData = session['session'] ?? {};

            final dateStr = sessionData['date'] ?? '';
            final date =
                dateStr.isNotEmpty ? DateTime.parse(dateStr) : DateTime.now();
            final formattedDate = DateFormat.yMMMMEEEEd('ar').format(date);

            final startTime = sessionData['start_time'] ?? '';
            final endTime = sessionData['end_time'] ?? '';
            final time = (startTime.isNotEmpty && endTime.isNotEmpty)
                ? "$startTime - $endTime"
                : 'غير محدد';

            final status = session['status'] ?? 'pending';
            final statusData = _getStatusData(status);

            final trainerName = session['trainer']?['name'] ?? 'مدرب غير معروف';
            final studentName = session['student']?['name'] ?? 'طالب غير معروف';
            final carModel = session['car']?['model'] ?? 'موديل غير معروف';
            final transmission = session['car']?['transmission'] ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [
                    statusData.color.withOpacity(0.15),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusData.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // التاريخ والحالة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 20, color: statusData.color),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusData.color.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          statusData.label,
                          style: TextStyle(
                            color: statusData.color,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // الوقت
                  Row(
                    children: [
                      Icon(Icons.access_time_filled_rounded,
                          size: 20, color: Colors.blueGrey.shade400),
                      const SizedBox(width: 12),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          "الوقت: $time",
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade700),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // المدرب
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: 20, color: Colors.deepPurple.shade400),
                      const SizedBox(width: 10),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          "المدرب: $trainerName",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // الطالب
                  Row(
                    children: [
                      Icon(Icons.school_outlined,
                          size: 20, color: Colors.teal.shade400),
                      const SizedBox(width: 10),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          "الطالب: $studentName",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // السيارة
                  Row(
                    children: [
                      Icon(Icons.directions_car_outlined,
                          size: 20, color: Colors.orange.shade400),
                      const SizedBox(width: 10),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          "السيارة: $carModel (${transmission.isNotEmpty ? transmission : 'غير محدد'})",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  _SessionStatus _getStatusData(String status) {
    switch (status) {
      case 'completed':
        return _SessionStatus(label: "مكتملة", color: Colors.green.shade700);
      case 'cancelled':
        return _SessionStatus(label: "ملغاة", color: Colors.red.shade700);
      case 'in_progress':
        return _SessionStatus(
            label: "قيد التنفيذ", color: Colors.orange.shade700);
      case 'pending':
      default:
        return _SessionStatus(
            label: "قيد الانتظار", color: Colors.grey.shade600);
    }
  }
}

class _SessionStatus {
  final String label;
  final Color color;

  _SessionStatus({required this.label, required this.color});
}
