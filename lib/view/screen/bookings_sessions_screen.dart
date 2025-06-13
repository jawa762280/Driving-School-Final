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
        iconTheme: IconThemeData(color: Colors.white), // <-- هنا لون السهم

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

        final userRole = controller.userRole.value;

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
            final statusData = getStatusData(status);
            // ignore: avoid_print
            print("Session status: $status");


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
                    statusData.color.withAlpha((0.1 * 255).toInt()),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusData.color.withAlpha((0.3 * 255).toInt()),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // التاريخ
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 20, color: Colors.teal.shade400),
                      const SizedBox(width: 10),
                      Text(
                        formattedDate,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // الوقت
                  Row(
                    children: [
                      Icon(Icons.access_time_filled_rounded,
                          size: 20, color: Colors.teal.shade400),
                      const SizedBox(width: 12),
                      Text("الوقت: $time",
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade700)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // المدرب
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: 20, color: Colors.teal.shade400),
                      const SizedBox(width: 10),
                      Text("المدرب: $trainerName",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // الطالب
                  Row(
                    children: [
                      Icon(Icons.school_outlined,
                          size: 20, color: Colors.teal.shade400),
                      const SizedBox(width: 10),
                      Text("الطالب: $studentName",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // السيارة
                  Row(
                    children: [
                      Icon(Icons.directions_car_outlined,
                          size: 20, color: Colors.teal.shade400),
                      const SizedBox(width: 10),
                      Text(
                          "السيارة: $carModel (${transmission.isNotEmpty ? transmission : 'غير محدد'})",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 20, color: statusData.color),
                      const SizedBox(width: 10),
                      Text("الحالة: ${statusData.label}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: statusData.color,
                          )),
                    ],
                  ),
                  const SizedBox(height: 15),

                  if ((userRole == 'trainer' &&
                          status != 'completed' &&
                          status != 'cancelled') ||
                      (userRole == 'student' && status == 'booked'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (userRole == 'trainer')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // زر البدء (يمين)
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  minimumSize: const Size(10, 36),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () async {
                                  final bookingId = session['id'];
                                  await controller.startSession(bookingId);
                                  await controller
                                      .fetchSessions(); // لتحديث القائمة
                                },
                                icon: Icon(Icons.play_arrow,
                                    size: 18, color: Colors.teal.shade400),
                                label: const Text("بدء",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                              ),

                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  minimumSize: const Size(10, 36),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: session['status'] == 'started'
                                    ? () async {
                                        final bookingId = session['id'];
                                        await controller
                                            .completeSession(bookingId);
                                        await controller
                                            .fetchSessions(); // لتحديث القائمة
                                      }
                                    : null,
                                icon: Icon(Icons.stop,
                                    size: 18, color: Colors.teal.shade400),
                                label: const Text("إنهاء",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        if (status == 'pending' || status == 'booked')

                        Center(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey.shade500,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              showCancelConfirmationDialog(
                                  context, sessionData['id'], controller);
                            },
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            label: const Text("إلغاء",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
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

  void showCancelConfirmationDialog(BuildContext context, int sessionId,
      BookingsSessionsController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("تأكيد الإلغاء"),
        content: const Text("هل أنت متأكد من رغبتك في إلغاء هذه الجلسة؟"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("تراجع"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await controller.cancelSession(sessionId);
            },
            child: const Text("تأكيد"),
          ),
        ],
      ),
    );
  }

  SessionStatus getStatusData(String status) {
    switch (status) {
      case 'completed':
        return SessionStatus(label: "مكتملة", color: Colors.green.shade500);
      case 'cancelled':
        return SessionStatus(label: "ملغاة", color: Colors.red.shade700);
      case 'started':
        return SessionStatus(label: "تم البدء ", color: Colors.teal.shade400);
      case 'pending':
      default:
        return SessionStatus(
            label: "قيد الانتظار", color: Colors.grey.shade700);
    }
  }
}

class SessionStatus {
  final String label;
  final Color color;

  SessionStatus({required this.label, required this.color});
}
