import 'package:driving_school/controller/generate_exam_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerateExamScreen extends StatelessWidget {
  final GenerateExamController controller = Get.find();
  GenerateExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          title: const Text('توليد امتحان'),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                controller.loadCompletedExamsFromAPI();
              },
              tooltip: 'تحديث',
            ),
          ],
        ),
       body: Obx(() {
  if (controller.isLoading.value) {
    return Center(child: CircularProgressIndicator());
  }

  return Padding(
    padding: const EdgeInsets.all(16),
    child: controller.questions.isEmpty
      ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('اختر نوع الامتحان:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildExamTypeSelector(),
              const SizedBox(height: 16),
              _buildStartButton(),
            ],
          ),
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimer(),
            const SizedBox(height: 16),
            Expanded(child: _buildQuestionsList()),
            const SizedBox(height: 12),
            _buildSubmitButton(),
          ],
        ),
  );
}),

      ),
    );
  }

  Widget _buildExamTypeSelector() {
  return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: controller.examTypesMap.entries.map((entry) {
          final label = entry.key;
          final value = entry.value;
          final isSelected = controller.selectedType.value == value;
          final isCompleted = controller.completedTypes.contains(value);

          return GestureDetector(
            onTap: isCompleted
                ? null
                : () => controller.selectedType.value = value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green.shade50
                    : isSelected
                        ? AppColors.primaryColor.withAlpha((0.1 * 255).toInt())
                        : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? Colors.green
                            : isSelected
                                ? AppColors.primaryColor
                                : Colors.black,
                      ),
                    ),
                  ),
                  if (isCompleted)
                    const Icon(Icons.check_circle, color: Colors.green),
                  if (isSelected && !isCompleted)
                    Icon(Icons.radio_button_checked,
                        color: AppColors.primaryColor),
                ],
              ),
            ),
          );
        }).toList(),
      ));
}


  Widget _buildStartButton() {
    bool allExamsCompleted =
        controller.completedTypes.length == controller.examTypesMap.length;
    Color unifiedButtonColor = Colors.green.shade500;

    ButtonStyle unifiedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: unifiedButtonColor,
      foregroundColor: Colors.white,
      elevation: 3,
      textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );

    return Column(
      children: [
        if(!allExamsCompleted)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (controller.selectedType.value.isEmpty) {
                Get.snackbar(
                  'تنبيه',
                  'يرجى اختيار نوع الامتحان أولاً',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange.shade100,
                  colorText: Colors.black87,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              } else {
                controller.generateExam();
              }
            },
            style: unifiedButtonStyle,
            child: Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.arrow_forward, color: Colors.white),
                SizedBox(width: 10),
                Text('ابدأ الامتحان'),
              ],
            ),
          ),
        ),
        if (allExamsCompleted) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRouts.evaluationStudentScreen);
              },
              style: unifiedButtonStyle,
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.assessment, color: Colors.white),
                  SizedBox(width: 10),
                  Text('عرض النتائج'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimer() {
    return Obx(() {
      final minutes = controller.timeLeft.value ~/ 60;
      final seconds =
          (controller.timeLeft.value % 60).toString().padLeft(2, '0');
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.timer, color: Colors.red),
            const SizedBox(width: 10),
            Text(
              'الوقت المتبقي: $minutes:$seconds',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuestionsList() {
    return ListView.builder(
      itemCount: controller.questions.length,
      padding: const EdgeInsets.only(bottom: 20),
      itemBuilder: (_, index) {
        final question = controller.questions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'السؤال ${index + 1}',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  question.questionText,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Column(
                  children: List.generate(question.choices.length, (i) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Obx(
                        () => RadioListTile<int>(
                          value: i,
                          groupValue: controller.answers[index].value,
                          onChanged: controller.isTimeUp.value
                              ? null
                              : (val) {
                                  controller.answers[index].value = val;
                                },
                          title: Text(question.choices[i].text),
                          activeColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.submitAnswers,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          textDirection: TextDirection.ltr, // أجبر اتجاه النص لليسار لليمين

          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('تسليم الإجابات'),
          ],
        ),
      ),
    );
  }
}
