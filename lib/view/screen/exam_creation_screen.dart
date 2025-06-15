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
              _buildSectionTitle(
                'نوع الامتحان',
              ),
              SizedBox(height: 15),
              _buildDropdown(controller),
              const SizedBox(height: 24),

              _buildSectionTitle('عنوان الامتحان'),
              _buildTextField(
                  controller.titleController, 'أدخل عنوان الامتحان'),
              const SizedBox(height: 24),

              _buildSectionTitle('مدة الامتحان (بالدقائق)'),
              _buildTextField(controller.durationController, "مثال: 60",
                  isNumber: true),
              const SizedBox(height: 32),

              // الأسئلة
              _buildSectionTitle('الأسئلة'),
              const SizedBox(height: 12),

              ...List.generate(controller.questions.length, (qIndex) {
                final question = controller.questions[qIndex];
                return _buildQuestionCard(question, qIndex, controller);
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

  Widget _buildDropdown(ExamCreationController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 4))
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
        items: const [
          DropdownMenuItem(value: 'driving', child: Text('قيادة')),
          DropdownMenuItem(value: 'traffic_rules', child: Text('قواعد المرور')),
          DropdownMenuItem(
              value: 'traffic_signals', child: Text('إشارات المرور')),
          DropdownMenuItem(value: 'mechanics', child: Text('ميكانيك')),
          DropdownMenuItem(value: 'first_aid', child: Text('إسعافات أولية')),
          DropdownMenuItem(
              value: 'special_conditions', child: Text('القيادة في ظروف خاصة')),
          DropdownMenuItem(
              value: 'accident_handling', child: Text('التعامل مع الحوادث')),
        ],
        onChanged: (val) => controller.examType.value = val ?? '',
        iconEnabledColor: AppColors.primaryColor,
        dropdownColor: Colors.white,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isNumber = false, bool noMargin = false}) {
    return Container(
      margin: noMargin ? EdgeInsets.zero : const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 6))
        ],
      ),
      child: TextField(
        controller: controller,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
    );
  }

  Widget _buildQuestionCard(question, int index, controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha((0.07 * 255).toInt()),
              blurRadius: 12,
              offset: const Offset(0, 8)),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('السؤال ${index + 1}'),
          const SizedBox(height: 10),
          _buildTextField(question.textController, 'أدخل نص السؤال'),
          const SizedBox(height: 18),

          // زر رفع صورة السؤال مع عرض مصغر
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primaryColor.withAlpha((0.1 * 255).toInt()),
                  foregroundColor: AppColors.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: Icon(
                  Icons.image_outlined,
                  size: 22,
                  color: AppColors.primaryColor,
                ),
                label: const Text('رفع صورة'),
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    question.image.value = picked;
                    controller.update();
                  }
                },
              ),
              const SizedBox(width: 14),
              Obx(() {
                if (question.image.value != null) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(
                            File(question.image.value!.path),
                          ),
                          fit: BoxFit.cover,
                        )),
                  );
                }
                return const SizedBox(); // لو ما في صورة
              })
            ],
          ),
          const SizedBox(height: 24),

          const Text('الخيارات:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),

          Obx(() {
            return Column(
              children: [
                ...List.generate(question.choices.length, (cIndex) {
                  final choice = question.choices[cIndex];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            choice.textController,
                            'الخيار ${cIndex + 1}',
                            noMargin: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Obx(() => GestureDetector(
                              onTap: () {
                                choice.isCorrect.value =
                                    !choice.isCorrect.value;
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
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
                                width: 24,
                                height: 24,
                                child: choice.isCorrect.value
                                    ? const Icon(Icons.check,
                                        size: 18, color: Colors.white)
                                    : null,
                              ),
                            )),
                        const SizedBox(width: 6),
                        const Text('صحيح؟',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 14),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent, size: 28),
                          onPressed: () {
                            if (question.choices.length <= 2) {
                              Get.snackbar(
                                  'خطأ', 'يجب أن يكون هناك على الأقل خياران');
                            } else {
                              question.choices.removeAt(cIndex);
                              controller.update();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primaryColor,
                    ),
                    label: const Text('إضافة خيار'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor
                          .withAlpha((0.15 * 255).toInt()),
                      foregroundColor: AppColors.primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
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
                )
              ],
            );
          }),
          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.delete_forever,
                  color: Colors.redAccent, size: 32),
              tooltip: 'حذف السؤال',
              onPressed: () => controller.removeQuestion(index),
            ),
          ),
        ],
      ),
    );
  }
}
