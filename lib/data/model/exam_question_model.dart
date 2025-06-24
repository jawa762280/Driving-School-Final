import 'package:driving_school/data/model/exam_choice_model.dart';

class ExamQuestionModel {
  final int questionId;
  final String questionText;
  final List<ExamChoiceModel> choices;

  ExamQuestionModel({required this.questionId, required this.questionText, required this.choices});

  factory ExamQuestionModel.fromJson(Map<String, dynamic> json) => ExamQuestionModel(
        questionId: json['question_id'],
        questionText: json['question_text'],
        choices: (json['choices'] as List)
            .map((e) => ExamChoiceModel.fromJson(e))
            .toList(),
      );
}