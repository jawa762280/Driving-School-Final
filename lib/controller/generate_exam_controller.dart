import 'dart:async';

import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/data/model/exam_question_model.dart';
import 'package:driving_school/data/model/exam_result_model.dart';
import 'package:driving_school/view/exam_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerateExamController extends GetxController {
  final Crud crud = Crud();
  RxString startedAt = ''.obs;
  var examResult = Rx<ExamResultModel?>(null);
  var isTimeUp = false.obs;

  var completedTypes = <String>{}.obs;
  var isLoading = false.obs;
  final Map<String, String> examTypesMap = {
    'قيادة': 'driving',
    'قواعد المرور': 'traffic_rules',
    'إشارات المرور': 'traffic_signs',
    'ميكانيك': 'mechanics',
    'إسعافات أولية': 'first_aid',
    'القيادة في ظروف خاصة': 'special_conditions',
    'التعامل مع الحوادث': 'accident_handling',
  };

  var selectedType = ''.obs;
  var questions = <ExamQuestionModel>[].obs;
  var answers = <Rx<int?>>[].obs;
  var examAttemptId = 0.obs;
  var timeLeft = 0.obs;
  Timer? timer;

  void generateExam() async {
    isLoading.value = true;
    if (selectedType.isEmpty) {
      Get.snackbar('خطأ', 'يرجى اختيار نوع الامتحان');
      return;
    }

    final response = await crud.postRequest(AppLinks.generateExam, {
      'type': selectedType.value,
    });

    final qData = response['questions']['exam_data'];
    final qList = qData['questions'] as List;

    examAttemptId.value = response['questions']['exam_attempt_id'];
    timeLeft.value = qData['exam_info']['time_limit'] * 60;
    questions
        .assignAll(qList.map((e) => ExamQuestionModel.fromJson(e)).toList());
    answers.assignAll(List.generate(questions.length, (_) => Rx<int?>(null)));
    await startExam(examAttemptId.value);
    isLoading.value = false;
  }

  Future<void> startExam(int attemptId) async {
    final response = await crud.postRequest(
      AppLinks.startExam,
      {
        'exam_attempt_id': attemptId,
      },
    );

    if (response['message'] == 'تم بدء الامتحان بنجاح') {
      // ignore: avoid_print
      print("✅ الامتحان بدأ رسميًا عند: ${response['started_at']}");

      // ⏱️ ابدأ المؤقت بعد بدء الامتحان رسميًا
      timer?.cancel();
      timer = Timer.periodic(Duration(seconds: 1), (_) {
  if (timeLeft.value > 0) {
    timeLeft.value--;
  } else {
    timer?.cancel();
    isTimeUp.value = true;

    Get.snackbar(
      'انتباه',
      'انتهى وقت الامتحان. سيتم تصحيح الإجابات المُدخلة فقط.',
      snackPosition: SnackPosition.TOP,
      colorText: Colors.black87,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
});

    } else {
      Get.snackbar('خطأ', 'فشل بدء الامتحان');
    }
  }

  Future<void> submitAnswers() async {
    final Map<String, String> userAnswers = {};

    for (int i = 0; i < questions.length; i++) {
      final selectedIndex = answers[i].value;
      if (selectedIndex != null) {
        final questionId = questions[i].questionId.toString();
        final choiceId =
            questions[i].choices[selectedIndex].choiceId.toString();
        userAnswers[questionId] = choiceId;
      }
    }

    final response = await crud.postRequest(
      AppLinks.submitExam,
      {
        'attempt_id': examAttemptId.value,
        'answers': userAnswers,
      },
    );

    if (response['success'] == true) {
      Get.snackbar('تم', "تم تصحيح الاجابات المدخلة فقط ");

      examResult.value = ExamResultModel.fromJson(response['data']);

      // ✅ اعرض شاشة النتائج وانتظر حتى يرجع المستخدم
      await Get.to(() => ExamResultScreen());

      // ✅ بعد رجوعه، نعيد تعيين الامتحان ونضيفه للمكتملين
      resetExam();
    } else {
      Get.snackbar('خطأ', 'فشل في إرسال الإجابات');
    }
  }

  void resetExam() {
    if (selectedType.value.isNotEmpty) {
      completedTypes.add(selectedType.value);
    }

    questions.clear();
    answers.clear();
    selectedType.value = '';
    examAttemptId.value = 0;
    timeLeft.value = 0;
    timer?.cancel();
  }
}
