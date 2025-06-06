import 'package:driving_school/controller/bookings_sessions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingsSessionsScreen extends StatelessWidget {
  final BookingsSessionsController controller = Get.put(BookingsSessionsController());

  BookingsSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جلساتي كمدرب'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        if (controller.sessions.isEmpty) {
          return const Center(child: Text('لا توجد جلسات حالياً'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: controller.sessions.length,
          itemBuilder: (context, index) {
            final item = controller.sessions[index];

            final studentName = item['student']['name'];
            final carModel = item['car']['model'];
            final carTrans = item['car']['transmission'] == 'manual' ? 'عادي' : 'أوتوماتيك';
            final date = item['session']['date'];
            final start = item['session']['start_time'].substring(0, 5);
            final end = item['session']['end_time'].substring(0, 5);
            final createdAt = item['created_at'];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow(Icons.person, 'الطالب', studentName),
                  const SizedBox(height: 6),
                  _buildRow(Icons.directions_car, 'السيارة', '$carModel - $carTrans'),
                  const SizedBox(height: 6),
                  _buildRow(Icons.schedule, 'الوقت', '$start - $end'),
                  const SizedBox(height: 6),
                  _buildRow(Icons.calendar_today, 'التاريخ', _formatDate(date)),
                  const SizedBox(height: 6),
                  _buildRow(Icons.access_time, 'تاريخ الحجز', _formatDateTime(createdAt)),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.deepPurple),
        const SizedBox(width: 6),
        Text(
          '$title: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat.yMMMMd('ar').format(date);
  }

  String _formatDateTime(String dtStr) {
    final dt = DateTime.parse(dtStr);
    return DateFormat('y/MM/dd - HH:mm', 'ar').format(dt);
  }
}
