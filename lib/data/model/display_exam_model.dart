import 'package:driving_school/data/model/display_question_model.dart';

class DisplayExam {
  final int durationMinutes;
  final List<DisplayQuestion> questions;

  DisplayExam({
    required this.durationMinutes,
    required this.questions,
  });

  factory DisplayExam.fromJson(Map<String, dynamic> json) {
    return DisplayExam(
      durationMinutes: json['duration_minutes'] ?? 0,
      questions: (json['questions'] as List)
          .map((q) => DisplayQuestion.fromJson(q))
          .toList(),
    );
  }
}