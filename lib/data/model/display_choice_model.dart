class DisplayChoice {
  final String text;
  final bool isCorrect;

  DisplayChoice({
    required this.text,
    required this.isCorrect,
  });

  factory DisplayChoice.fromJson(Map<String, dynamic> json) {
    return DisplayChoice(
      text: json['text'] ?? '',
      isCorrect: json['is_correct'] ?? false,
    );
  }
}
