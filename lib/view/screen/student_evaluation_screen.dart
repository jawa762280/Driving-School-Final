import 'package:driving_school/main.dart';
import 'package:driving_school/view/screen/pdf_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/student_evaluation_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';

class StudentEvaluationScreen extends StatelessWidget {
  const StudentEvaluationScreen({
    super.key,
  });

  String _formatType(String type) {
    switch (type) {
      case 'driving':
        return 'القيادة';
      case 'traffic_rules':
        return 'قوانين المرور';
      case 'traffic_signs':
        return 'علامات المرور';
      case 'mechanics':
        return 'ميكانيكا السيارات';
      case 'first_aid':
        return 'الإسعافات الأولية';
      case 'special_conditions':
        return 'ظروف خاصة';
      case 'accident_handling':
        return 'التعامل مع الحوادث';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentEvaluationController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 2,
          title: const Text(
            'نتائج الامتحانات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.evaluations.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد نتائج للعرض',
                style: TextStyle(fontSize: 18, color: Colors.black45),
              ),
            );
          }

          return ListView(padding: const EdgeInsets.all(16), children: [
            // الحالة النهائية
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              margin: const EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                color: controller.passedAll.value
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: controller.passedAll.value ? Colors.green : Colors.red,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    controller.passedAll.value
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        controller.passedAll.value ? Colors.green : Colors.red,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      controller.finalStatus.value,
                      style: TextStyle(
                        color: controller.passedAll.value
                            ? Colors.green.shade900
                            : Colors.red.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // قائمة التقييمات
            ...controller.evaluations.map((item) {
              final bool passed = item.status.contains('✅');
              final bool hasScore = item.score != null;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: passed ? Colors.green.shade300 : Colors.red.shade300,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان نوع الامتحان
                    Text(
                      _formatType(item.type),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // إذا تم تقديم الامتحان
                    if (hasScore)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'العلامة: ${item.score}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'النسبة: ${item.percentage?.toStringAsFixed(1) ?? '---'}%',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      )
                    else
                      const Text(
                        'لم يتم إجراء الامتحان',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),

                    const SizedBox(height: 12),

                    // الحالة
                    Row(
                      children: [
                        Icon(
                          passed ? Icons.check_circle : Icons.cancel,
                          color: passed ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: passed
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            // داخل Obx اللي في جسم الصفحة
            if (controller.passedAll.value)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // لو الشهادة مولدة بالفعل
                    if (controller.isCertificateGenerated.value &&
                        controller.certificateUrl.value.isNotEmpty) {
                      return ElevatedButton(
                        onPressed: () {
                          Get.to(() => PdfViewScreen(
                                url: controller.certificateUrl.value,
                                fileName:
                                    'certificate_${data.read('user')['student']['id']}.pdf',
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Row(
                          textDirection: TextDirection.ltr,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf, color: Colors.white),
                            SizedBox(width: 10),
                            Text('عرض الشهادة'),
                          ],
                        ),
                      );
                    }
                    // إذا الشهادة ما تولدت بعد
                    else {
                      return ElevatedButton(
                        onPressed: () async {
                          final studentId = data.read('user')['student']['id'];
                          if (studentId != null) {
                            await controller.generateCertificate(studentId);
                          } else {
                            Get.snackbar('خطأ', 'لم يتم العثور على رقم الطالب');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Row(
                          textDirection: TextDirection.ltr,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf, color: Colors.white),
                            SizedBox(width: 10),
                            Text('توليد الشهادة'),
                          ],
                        ),
                      );
                    }
                  }),
                ),
              )
          ]);
        }),
      ),
    );
  }
}
