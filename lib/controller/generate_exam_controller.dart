import 'dart:async';
import 'dart:convert';

import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/data/model/evaluation_student_model.dart';
import 'package:driving_school/data/model/exam_question_model.dart';
import 'package:driving_school/data/model/exam_result_model.dart';
import 'package:driving_school/view/exam_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class GenerateExamController extends GetxController {
  final Crud crud = Crud();
  final GetStorage data = GetStorage();
  var evaluations = <EvaluationStudentModel>[].obs;
  var isExamAlreadyPassed = false.obs;
  bool isCompleted = false;
  RxString startedAt = ''.obs;
  String lastExamType = '';
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
      isLoading.value = false;
      Get.snackbar('خطأ', 'يرجى اختيار نوع الامتحان');
      return;
    }

    lastExamType = selectedType.value;

    try {
      final url = Uri.parse(AppLinks.generateExam);
      String token = data.read('token') ?? '';
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type': selectedType.value,
        }),
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded.containsKey('questions')) {
        final qData = decoded['questions']['exam_data'];
        final qList = qData['questions'] as List;

        examAttemptId.value = decoded['questions']['exam_attempt_id'];
        timeLeft.value = qData['exam_info']['time_limit'] * 60;
        questions.assignAll(
          qList.map((e) => ExamQuestionModel.fromJson(e)).toList(),
        );
        answers.assignAll(
          List.generate(questions.length, (_) => Rx<int?>(null)),
        );

        await startExam(examAttemptId.value);
        isLoading.value = false;
      } else {
        isLoading.value = false;

        String errorMessage = '⚠ حدث خطأ غير متوقع. يرجى إعادة المحاولة.';
        if (decoded['message'] != null &&
            decoded['message'].toString().trim().isNotEmpty) {
          errorMessage = decoded['message'].toString();
          if (errorMessage ==
              '❌   لا يمكنك بدء هذا الامتحان لأنك اجتزته مسبقًا.بنسبة كافية ') {
            isCompleted = true;
            update();
          }
        }

        Get.snackbar(
          'خطأ',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          colorText: Colors.black,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

        if (errorMessage.contains(' لا يمكنك بدء هذا الامتحان') &&
            !completedTypes.contains(selectedType.value)) {
          completedTypes.add(selectedType.value);
        }
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'خطأ في الاتصال',
        'فشل الاتصال بالخادم. تحقق من الإنترنت أو أعد المحاولة.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void regenerateSameExam() {
    selectedType.value = lastExamType;
    generateExam();
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
    isLoading.value = true;
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

    if (userAnswers.isEmpty && !isTimeUp.value) {
      Get.snackbar('خطأ', 'يجب اختيار إجابة واحدة على الأقل قبل التسليم');
      return;
    }

    final response = await crud.postRequest(
      AppLinks.submitExam,
      {
        'attempt_id': examAttemptId.value,
        'answers': userAnswers,
      },
    );

    if (response['success'] == true) {
      Get.snackbar('تم', "تم تصحيح الاجابات المدخلة");

      examResult.value = ExamResultModel.fromJson(response['data']);

      await Get.to(() => ExamResultScreen());

      resetExam();
    } else {
      Get.snackbar('خطأ', 'فشل في إرسال الإجابات');
    }
    isLoading.value = false;
  }

  void resetExam() {
    if (selectedType.value.isNotEmpty) {
      final eval = evaluations.firstWhereOrNull(
        (e) => e.type == selectedType.value && e.status.trim() == '✅ ناجح',
      );

      if (eval != null) {
        completedTypes.add(selectedType.value);
      }
    }

    questions.clear();
    answers.clear();
    selectedType.value = '';
    examAttemptId.value = 0;
    timeLeft.value = 0;
    timer?.cancel();
  }

  Future<void> loadCompletedExamsFromAPI() async {
    isLoading.value = true;
    try {
      final response = await crud.getRequest(AppLinks.evaluationStuent);

      if (response != null && response['details'] != null) {
        final List<dynamic> details = response['details'];
        evaluations.value =
            details.map((e) => EvaluationStudentModel.fromJson(e)).toList();
        final passed = evaluations
            .where((e) => e.status.trim() == '✅ ناجح')
            .map((e) => e.type)
            .toSet();

        completedTypes.assignAll(passed);
        completedTypes.refresh();
        update();
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    String? userType = data.read('role').toString();
    if (userType == 'student') {
      loadCompletedExamsFromAPI();
    }
  }
}
