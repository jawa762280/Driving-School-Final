import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/data/model/question_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:driving_school/core/services/crud.dart';
import '../../../core/constant/app_api.dart';

class ExamCreationController extends GetxController {
  final Crud crud = Crud();

  var isLoading = false.obs;
  final durationController = TextEditingController();
  var examType = ''.obs;
  final titleController = TextEditingController();

  var questions = <QuestionModel>[].obs;

  void addQuestion() {
    questions.add(QuestionModel());
  }

  void removeQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      questions.removeAt(index);
    }
  }

  Future<void> submitExam() async {
    for (final q in questions) {
      if (q.choices.length < 2 || q.choices.length > 4) {
        Get.snackbar('خطأ', 'يجب أن يحتوي كل سؤال على 2 إلى 4 اختيارات');
        return;
      }
    }

    isLoading.value = true;

    final Map<String, String> fields = {
      'type': examType.value,
      'title': titleController.text,
      'duration_minutes': durationController.text,
    };

    final List<XFile> images = [];
    final List<String> imageFieldNames = [];

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      fields['questions[$i][question_text]'] = q.textController.text;

      if (q.image.value != null) {
        images.add(q.image.value!);
        imageFieldNames.add('questions[$i][image]');
      }

      for (int j = 0; j < q.choices.length; j++) {
        final choice = q.choices[j];
        fields['questions[$i][choices][$j][text]'] = choice.textController.text;
        fields['questions[$i][choices][$j][is_correct]'] =
            choice.isCorrect.value ? '1' : '0';
      }
    }

    var response = await crud.multiFileRequestMoreImagePath(
      AppLinks.createExam,
      fields,
      images,
      imageFieldNames,
    );

    isLoading.value = false;

    if (response != null && response['message'] != null) {
      Get.snackbar('تم بنجاح', response['message']);
      titleController.clear();
      durationController.clear();
      examType.value = '';
      questions.clear();
    } else {
      Get.snackbar('خطأ', 'فشل إرسال الامتحان');
    }
  }
}
