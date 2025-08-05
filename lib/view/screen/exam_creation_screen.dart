import 'dart:io';

import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/data/model/choice_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/exam_creation_controller.dart';
import 'package:image_picker/image_picker.dart';

class ExamCreationScreen extends StatelessWidget {
  const ExamCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExamCreationController());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('إنشاء امتحان نظري',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: Colors.black45,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle(
                'نوع الامتحان',
              ),
              SizedBox(height: 15),
              buildDropdown(controller),
              const SizedBox(height: 24),

              buildSectionTitle('عنوان الامتحان'),
              buildTextField(controller.titleController, 'أدخل عنوان الامتحان'),
              const SizedBox(height: 24),

              buildSectionTitle('مدة الامتحان (بالدقائق)'),
              buildTextField(controller.durationController, "مثال: 60",
                  isNumber: true),
              const SizedBox(height: 32),

              buildSectionTitle('الأسئلة'),
              const SizedBox(height: 12),

              ...List.generate(controller.questions.length, (qIndex) {
                final question = controller.questions[qIndex];
                return buildQuestionCard(question, qIndex, controller);
              }),

              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 16),
                    elevation: 4,
                    shadowColor: Colors.black54,
                  ),
                  icon:
                      const Icon(Icons.add_circle_outline, color: Colors.white),
                  label: const Text('إضافة سؤال',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  onPressed: controller.addQuestion,
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: ElevatedButton(
                  onPressed: controller.submitExam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(200, 55),
                    elevation: 6,
                    shadowColor: Colors.black87,
                  ),
                  child: const Text('إنشاء الامتحان',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget buildDropdown(ExamCreationController controller) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withAlpha((0.1 * 255).toInt()),
              blurRadius: 10,
              offset: const Offset(0, 6))
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: controller.examType.value.isEmpty
            ? null
            : controller.examType.value,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'اختر نوع الامتحان',
        ),
        icon:
            Icon(Icons.arrow_drop_down_rounded, color: AppColors.primaryColor),
        items: const [
          DropdownMenuItem(value: 'driving', child: Text('قيادة')),
          DropdownMenuItem(value: 'traffic_rules', child: Text('قواعد المرور')),
          DropdownMenuItem(
              value: 'traffic_signs', child: Text('إشارات المرور')),
          DropdownMenuItem(value: 'mechanics', child: Text('ميكانيك')),
          DropdownMenuItem(value: 'first_aid', child: Text('إسعافات أولية')),
          DropdownMenuItem(
              value: 'special_conditions', child: Text('القيادة في ظروف خاصة')),
          DropdownMenuItem(
              value: 'accident_handling', child: Text('التعامل مع الحوادث')),
        ],
        onChanged: (val) => controller.examType.value = val ?? '',
        dropdownColor: Colors.white,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint,
      {bool isNumber = false, bool noMargin = false, int maxLines = 1}) {
    return Container(
      margin: noMargin ? EdgeInsets.zero : const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
    );
  }

  Widget buildQuestionCard(question, int index, controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor:
                    AppColors.primaryColor.withAlpha((0.2 * 255).toInt()),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'السؤال رقم ${index + 1}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever_rounded,
                    color: Colors.redAccent, size: 28),
                tooltip: 'حذف السؤال',
                onPressed: () => controller.removeQuestion(index),
              ),
            ],
          ),

          const SizedBox(height: 16),

          buildTextField(
            question.textController,
            'أدخل نص السؤال',
            maxLines: 4,
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.image_rounded, color: AppColors.primaryColor),
                label: const Text('إرفاق صورة'),
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    question.image.value = picked;
                    controller.update();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
              ),
              const SizedBox(width: 20),
              Obx(() {
                if (question.image.value != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      File(question.image.value!.path),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  );
                }
                return const Text('لا توجد صورة مرفقة',
                    style: TextStyle(color: Colors.grey, fontSize: 14));
              }),
            ],
          ),

          const SizedBox(height: 30),

          const Text('الخيارات:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

          const SizedBox(height: 16),

          Obx(() {
            return Column(
              children: List.generate(question.choices.length, (cIndex) {
                final choice = question.choices[cIndex];
                return buildChoiceItem(choice, cIndex, question, controller);
              }),
            );
          }),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add, color: AppColors.primaryColor),
              label: const Text('إضافة خيار'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primaryColor.withAlpha((0.12 * 255).toInt()),
                foregroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 0,
              ),
              onPressed: () {
                if (question.choices.length >= 4) {
                  Get.snackbar('خطأ', 'لا يمكنك إضافة أكثر من 4 خيارات');
                } else {
                  question.choices.add(ChoiceModel());
                  controller.update();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChoiceItem(choice, int cIndex, question, controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: choice.isCorrect.value
              ? AppColors.primaryColor
              : Colors.grey.shade300,
          width: choice.isCorrect.value ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              choice.isCorrect.value = !choice.isCorrect.value;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: choice.isCorrect.value
                    ? AppColors.primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: choice.isCorrect.value
                      ? AppColors.primaryColor
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: choice.isCorrect.value
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 48, 
                maxHeight: 120, 
              ),
              child: TextField(
                controller: choice.textController,
                decoration: InputDecoration(
                  hintText: 'الخيار ${cIndex + 1}',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                style: const TextStyle(fontSize: 16),
                maxLines: null, 
                keyboardType: TextInputType.multiline,
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.close, color: Colors.redAccent, size: 22),
            onPressed: () {
              if (question.choices.length <= 2) {
                Get.snackbar('خطأ', 'يجب أن يكون هناك على الأقل خياران');
              } else {
                question.choices.removeAt(cIndex);
                controller.update();
              }
            },
            tooltip: 'حذف الخيار',
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
