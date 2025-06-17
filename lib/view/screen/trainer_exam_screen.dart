import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/trainer_exam_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/data/model/exam_model.dart';

class TrainerExamsScreen extends StatelessWidget {
  TrainerExamsScreen({super.key});

  final controller = Get.put(TrainerExamController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("امتحانات المدرّب",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.exams.isEmpty) {
          return const Center(child: Text('لا يوجد امتحانات'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.exams.length,
          itemBuilder: (context, index) {
            final exam = controller.exams[index];
            return buildExamCard(exam);
          },
        );
      }),
    );
  }

  Widget buildExamCard(ExamModel exam) {
    String examTypeArabic = {
          'driving': 'قيادة',
          'mechanics': 'ميكانيك',
          'traffic_rules': 'قواعد المرور',
          'traffic_signs': 'إشارات المرور',
          'first_aid': 'إسعافات أولية',
          'special_conditions': 'ظروف خاصة',
          'accident_handling': 'التعامل مع الحوادث',
        }[exam.type] ??
        exam.type;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.08 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                AppColors.primaryColor.withAlpha((0.1 * 255).toInt()),
            child: Icon(Icons.assignment, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  examTypeArabic,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  "المدة: ${exam.durationMinutes} دقيقة",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  "تاريخ الإنشاء: ${exam.createdAt.toLocal().toString().split('.')[0]}",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
