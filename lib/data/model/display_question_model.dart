import 'package:driving_school/data/model/display_choice_model.dart';

class DisplayQuestion {
  final String text;
  final String? imageUrl;
  final List<DisplayChoice> choices;

  DisplayQuestion({
    required this.text,
    this.imageUrl,
    required this.choices,
  });

  factory DisplayQuestion.fromJson(Map<String, dynamic> json) {
    return DisplayQuestion(
      text: json['text'] ?? '',
      imageUrl: json['image_url'],
      choices: (json['choices'] as List)
          .map((c) => DisplayChoice.fromJson(c))
          .toList(),
    );
  }
}