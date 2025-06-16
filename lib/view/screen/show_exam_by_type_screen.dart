import 'package:collection/collection.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/show_exam_by_type_controller.dart';

class ShowExamByTypeScreen extends StatelessWidget {
  ShowExamByTypeScreen({super.key});

  final controller = Get.put(ShowExamByTypeController());

  final Map<String, String> examTypesMap = {
    'قيادة': 'driving',
    'قواعد المرور': 'traffic_rules',
    'إشارات المرور': 'traffic_signs',
    'ميكانيك': 'mechanics',
    'إسعافات أولية': 'first_aid',
    'القيادة في ظروف خاصة': 'special_conditions',
    'التعامل مع الحوادث': 'accident_handling',
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          title: const Text('عرض الامتحان حسب النوع'),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildDropdown(),
              const SizedBox(height: 16),
              _buildFetchButton(),
              const SizedBox(height: 24),
              Expanded(child: _buildExamContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Obx(() {
      String? selectedKey = examTypesMap.entries
          .firstWhereOrNull(
              (entry) => entry.value == controller.selectedType.value)
          ?.key;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withAlpha((0.03 * 255).toInt()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: selectedKey,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'اختر نوع الامتحان',
          ),
          style: const TextStyle(fontSize: 16),
          dropdownColor: Colors.white,
          items: examTypesMap.keys.map((label) {
            return DropdownMenuItem<String>(
              value: label,
              child: Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              controller.selectedType.value = examTypesMap[val]!;
            }
          },
        ),
      );
    });
  }

  Widget _buildFetchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => controller.fetchExamByType(),
        icon: const Icon(
          Icons.play_circle_fill_outlined,
          size: 24,
          color: Colors.white,
        ),
        label: const Text('عرض الامتحان'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 3,
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildExamContent() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final questions = controller.exam.value?.questions ?? [];

      if (questions.isEmpty) {
        return const Center(
          child: Text(
            'لم يتم تحميل أي امتحان بعد.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      final duration = controller.exam.value?.durationMinutes ?? 0;

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 30),
        itemCount: questions.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              color: AppColors.primaryColor.withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                leading: const Icon(Icons.timer, color: Colors.black87),
                title: Text(
                  'مدة الامتحان: $duration دقيقة',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            );
          }

          final question = questions[index - 1];

          return Card(
            margin: const EdgeInsets.only(bottom: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 3,
            shadowColor: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: رقم السؤال
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor
                          .withAlpha((0.15 * 255).toInt()),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'السؤال $index',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // نص السؤال
                  Text(
                    question.text,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  // صورة إن وجدت
                  if ((question.imageUrl?.isNotEmpty ?? false))
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          question.imageUrl!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  const SizedBox(height: 14),

                  // الخيارات
                  Column(
                    children: question.choices.map((choice) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: choice.isCorrect
                              ? Colors.green.shade50
                              : const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: choice.isCorrect
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              choice.isCorrect
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color:
                                  choice.isCorrect ? Colors.green : Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                choice.text,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
