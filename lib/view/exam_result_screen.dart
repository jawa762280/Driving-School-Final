import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/generate_exam_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/view/screen/generate_exam_screen.dart';

class ExamResultScreen extends StatelessWidget {
  final controller = Get.find<GenerateExamController>();

  ExamResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.examResult.value;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "نتيجة الامتحان",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        body: const Center(child: Text("لا توجد نتائج للعرض")),
      );
    }

    final correctedQuestions = result.details;
    final bool passed = result.score >= 5;
    final bool canRetake = !passed;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "نتيجة الامتحان",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryColor
                                .withAlpha((0.7 * 255).toInt()),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor
                                .withAlpha((0.4 * 255).toInt()),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${result.percentage.toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "علامتك",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87.withAlpha((0.7).toInt()),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${result.score} من ${result.total} أسئلة",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      passed ? "نجحت في الامتحان 🎉" : "لم تنجح في الامتحان ❌",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: passed ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "تفاصيل الأسئلة",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: correctedQuestions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final q = correctedQuestions[index];
                        final bool correct = q['is_correct'] ?? false;
                        final questionText = q['question_text'] ?? '';
                        final userAnswer = q['user_answer']?.toString() ?? '';
                        final correctAnswer =
                            q['correct_answer']?.toString() ?? '';

                        return Container(
                          decoration: BoxDecoration(
                            color: correct
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: correct ? Colors.green : Colors.red,
                              width: 1.4,
                            ),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: correct ? Colors.green : Colors.red,
                                ),
                                child: Icon(
                                  correct ? Icons.check : Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "السؤال ${index + 1}: $questionText",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.8,
                                        height: 1.5,
                                      ),
                                    ),
                                    if (!correct) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        "إجابتك: $userAnswer",
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "الإجابة الصحيحة: $correctAnswer",
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                children: [
                  if (canRetake)
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.resetExam();
                              controller.regenerateSameExam();
                              Get.off(() => GenerateExamScreen());
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 6,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "إعادة الامتحان",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.resetExam();
                        Get.off(() => GenerateExamScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "اختيار امتحان جديد",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
