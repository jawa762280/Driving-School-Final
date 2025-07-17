import 'package:driving_school/view/screen/map_page_screen.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:driving_school/controller/bookings_sessions_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';

class BookingsSessionsScreen extends StatelessWidget {

  const BookingsSessionsScreen({super.key});
  Widget _buildRouteButton(Map<String, dynamic> session, BookingsSessionsController controller) {
  final status = session['status'] ?? 'pending';
  final route = session['route'] as Map<String, dynamic>?;
  if (status == 'booked' && route == null) {
    // مدرب لم يحدد المسار بعد
    return TextButton.icon(
      icon: Icon(Icons.edit_location, color: Colors.orange),
      label: Text('تحديد مسار الجلسة', style: TextStyle(color: Colors.orange)),
      onPressed: () async {
        final ok = await Get.to<bool>(
          () => MapPageScreen(bookingId: session['id']),
        );
        if (ok == true) controller.fetchSessions();
      },
    );
  } else if (status == 'booked' && route != null) {
    // المسار موجود مسبقاً
    return IconButton(
      icon: Icon(Icons.map, color: AppColors.primaryColor),
      tooltip: 'عرض الخريطة',
      onPressed: () {
        Get.to(() => MapPageScreen(
          bookingId: session['id'],
          startLat: double.parse('${route['start_lat']}'),
          startLng: double.parse('${route['start_lng']}'),
          endLat:   double.parse('${route['end_lat']}'),
          endLng:   double.parse('${route['end_lng']}'),
        ));
      },
    );
  }
  return const SizedBox.shrink();
}

  

  @override
  Widget build(BuildContext context) {

    
    return GetBuilder<BookingsSessionsController>(
        init: BookingsSessionsController(),
        builder: (controller) {
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
              iconTheme:
                  IconThemeData(color: Colors.white), // <-- هنا لون السهم

              elevation: 5,
              shadowColor: Colors.black54,
            ),
            body: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryColor));
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: controller.sessions.length,
                itemBuilder: (_, index) {
                  final session = controller.sessions[index];
                  final sessionData = session['session'] ?? {};

                  final dateStr = sessionData['date'] ?? '';
                  final date = dateStr.isNotEmpty
                      ? DateTime.parse(dateStr)
                      : DateTime.now();
                  final formattedDate =
                      DateFormat.yMMMMEEEEd('ar').format(date);

                  final startTime = sessionData['start_time'] ?? '';
                  final endTime = sessionData['end_time'] ?? '';
                  final time = (startTime.isNotEmpty && endTime.isNotEmpty)
                      ? "$startTime - $endTime"
                      : 'غير محدد';

                  final status = session['status'] ?? 'pending';
                  final statusData = getStatusData(status);
                  // ignore: avoid_print
                  print("Session status: $status");

                  final trainerName =
                      session['trainer']?['name'] ?? 'مدرب غير معروف';
                  final studentName =
                      session['student']?['name'] ?? 'طالب غير معروف';
                  final carModel =
                      session['car']?['model'] ?? 'موديل غير معروف';
                  final transmission = session['car']?['transmission'] ?? '';
                  final matchingReview = controller.reviews.firstWhere(
                    (element) =>
                        element['session_id'].toString() ==
                        session['session']['id'].toString(),
                    orElse: () => null,
                  );

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.only(
                        right: 20, bottom: 20, top: 20, left: 10),
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
                          color:
                              statusData.color.withAlpha((0.3 * 255).toInt()),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // التاريخ
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 20, color: statusData.color),
                            const SizedBox(width: 10),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // الوقت
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 20, color: statusData.color),
                            const SizedBox(width: 12),
                            Text("الوقت: $time",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // المدرب
                        Row(
                          children: [
                            Icon(Icons.person_outline,
                                size: 20, color: statusData.color),
                            const SizedBox(width: 10),
                            Text("المدرب: $trainerName",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.school_outlined,
                                size: 20, color: statusData.color),
                            const SizedBox(width: 10),
                            Text("الطالب: $studentName",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // السيارة
                        Row(
                          children: [
                            Icon(Icons.directions_car_outlined,
                                size: 20, color: statusData.color),
                            const SizedBox(width: 10),
                            Text(
                                "السيارة: $carModel (${transmission.isNotEmpty ? transmission : 'غير محدد'})",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black)),
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
                        if ((userRole == 'trainer' || userRole == 'student') &&
                            status == 'completed' &&
                            matchingReview != null) ...[
                          Row(
                            children: [
                              Icon(Icons.star_border,
                                  size: 20, color: statusData.color),
                              const SizedBox(width: 10),
                              Text(
                                'المستوى:  ${translateLevel(matchingReview['level'])}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Icon(Icons.note_outlined,
                                  size: 20, color: statusData.color),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'ملاحظات المدرب:  ${matchingReview['notes']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        // const SizedBox(height: 15),

                        if ((userRole == 'trainer' &&
                                status != 'completed' &&
                                status != 'cancelled') ||
                            (userRole == 'student' && status == 'booked'))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (userRole == 'trainer')
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (status == 'booked')
                                      IconButton( 
                                        icon: Icon(Icons.map,
                                            color: AppColors.primaryColor),
                                        tooltip: 'عرض الخريطة',
                                        onPressed: () {
                                          Get.to(() => MapPageScreen(
                                                bookingId: session['id'],
                                              ));
                                        },
                                      ),
                                    // زر البدء (يمين)
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        minimumSize: const Size(10, 36),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () async {
                                        final bookingId = session['id'];
                                        await controller
                                            .startSession(bookingId);
                                        await controller
                                            .fetchSessions(); // لتحديث القائمة
                                      },
                                      icon: Icon(Icons.play_arrow,
                                          size: 18,
                                          color: Colors.teal.shade400),
                                      label: const Text("بدء",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ),

                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade600,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        minimumSize: const Size(10, 36),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: session['status'] == 'started'
                                          ? () async {
                                              final bookingId = session['id'];
                                              await controller
                                                  .completeSession(bookingId);
                                              await controller.fetchSessions();
                                            }
                                          : null,
                                      icon: Icon(Icons.stop,
                                          size: 18,
                                          color: Colors.teal.shade400),
                                      label: const Text("إنهاء",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
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
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    onPressed: () {
                                      showCancelConfirmationDialog(context,
                                          sessionData['id'], controller);
                                    },
                                    icon: const Icon(Icons.cancel,
                                        color: Colors.red),
                                    label: const Text("إلغاء",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ),
                            ],
                          ),

                        SizedBox(height: 15),

                        if (userRole == 'trainer' &&
                            status == 'completed' &&
                            session['is_rated'] == false)
                          InkWell(
                            onTap: () {
                              showMyDialog(context, (session['id']));
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primaryColor,
                              ),
                              child: Text(
                                'تقييم الطالب',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          );
        });
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

  String translateLevel(String? level) {
    switch (level) {
      case 'beginner':
        return 'مبتدئ';
      case 'intermediate':
        return 'متوسط';
      case 'excellent':
        return 'ممتاز';
      default:
        return 'بدون مستوى';
    }
  }
}

class SessionStatus {
  final String label;
  final Color color;

  SessionStatus({required this.label, required this.color});
}

void showMyDialog(BuildContext context, id) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GetBuilder<BookingsSessionsController>(
          init: Get.find<BookingsSessionsController>(),
          builder: (controller) {
            return Obx(
              () => Padding(
                padding: const EdgeInsets.all(20),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('تقييم الطالب'),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    controller.level = 'beginner';
                                    controller.levelCount = 0;
                                    controller.update();
                                  },
                                  child: buildBox("مبتدئ", 0),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    controller.level = 'intermediate';
                                    controller.levelCount = 1;
                                    controller.update();
                                  },
                                  child: buildBox("متوسط", 1),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    controller.level = 'excellent';
                                    controller.levelCount = 2;
                                    controller.update();
                                  },
                                  child: buildBox("ممتاز", 2),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          MyTextformfield(
                            maxLines: 5,
                            mycontroller: controller.comment,
                            keyboardType: TextInputType.visiblePassword,
                            hintText: 'ملاحظة للطالب',
                            filled: true,
                          ),
                          SizedBox(height: 20),
                          MyButton(
                            onPressed: () {
                              controller.sendFeedback(id);
                            },
                            text: "ارسال",
                          ),
                        ],
                      ),
              ),
            );
          }),
    ),
  );
}

Widget buildBox(String text, int i) {
  final controller = Get.put(BookingsSessionsController());
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    padding: EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
      color: controller.levelCount == i
          ? AppColors.primaryColor
          : Colors.transparent,
      border: Border.all(
        color:
            controller.levelCount == i ? AppColors.primaryColor : Colors.grey,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: controller.levelCount == i ? Colors.white : Colors.black,
      ),
    ),
  );
}
