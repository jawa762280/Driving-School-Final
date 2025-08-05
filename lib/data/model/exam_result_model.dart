class ExamResultModel {
  final int score;
  final int total;
  final double percentage; 
  final List<Map<String, dynamic>> details;

  ExamResultModel({
    required this.score,
    required this.total,
    required this.percentage,
    required this.details,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      score: json['score'],
      total: json['total'],
      percentage: (json['percentage'] as num).toDouble(), 
      details: List<Map<String, dynamic>>.from(json['details']),
    );
  }
}
