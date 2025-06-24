class ExamChoiceModel {
  final int choiceId;
  final String text;

  ExamChoiceModel({required this.choiceId, required this.text});

  factory ExamChoiceModel.fromJson(Map<String, dynamic> json) => ExamChoiceModel(
        choiceId: json['choice_id'],
        text: json['text'],
      );
}