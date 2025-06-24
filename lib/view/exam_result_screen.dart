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
                    // الدائرة الكبيرة للنتيجة
                    Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryColor.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.4),
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
                        color: Colors.black87.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${result.score} من ${result.total} اسئلة",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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
                      itemCount: result.details.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final q = result.details[index];
                        final bool correct = q['is_correct'] ?? false;

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
                                      "السؤال ${index + 1}: ${q['question_text'] ?? ''}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.8,
                                        height: 1.5,
                                      ),
                                    ),
                                    if (!correct) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        "إجابتك: ${q['user_answer'] ?? ''}",
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "الإجابة الصحيحة: ${q['correct_answer'] ?? ''}",
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
                    const SizedBox(height: 80), // مساحة أسفل للزر
                  ],
                ),
              ),
            ),

            // زر أسفل الصفحة ثابت مع تباعد جيد
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: SizedBox(
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
                    shadowColor: AppColors.primaryColor.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Row(
                    textDirection:
                        TextDirection.ltr, // أجبر اتجاه النص لليسار لليمين

                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.restart_alt,
                        size: 24,
                        color: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "اختيار امتحان جديد",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
