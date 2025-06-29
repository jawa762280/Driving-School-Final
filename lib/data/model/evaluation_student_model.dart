class EvaluationStudentModel {
  final String type;
  final int? score;
  final double? percentage;
  final String status;

  EvaluationStudentModel({
    required this.type,
    this.score,
    this.percentage,
    required this.status,
  });

  factory EvaluationStudentModel.fromJson(Map<String, dynamic> json) {
    return EvaluationStudentModel(
      type: json['type'] ?? '',
      score: json['score'],
      percentage: json['percentage'] != null
          ? (json['percentage'] as num).toDouble()
          : null,
      status: json['status'] ?? '',
    );
  }
}