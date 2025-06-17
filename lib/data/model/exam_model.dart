class ExamModel {
  final int id;
  final int trainerId;
  final String type;
  final int durationMinutes;
  final DateTime createdAt;

  ExamModel({
    required this.id,
    required this.trainerId,
    required this.type,
    required this.durationMinutes,
    required this.createdAt,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      trainerId: json['trainer_id'],
      type: json['type'],
      durationMinutes: json['duration_minutes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
