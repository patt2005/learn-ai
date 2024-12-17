import 'package:lingo_ai_app/models/quiz_level.dart';

class QuestionCategory {
  final String id;
  final List<Question> questions;
  final List<dynamic> options;

  QuestionCategory({
    required this.options,
    required this.id,
    required this.questions,
  });

  static QuestionCategory fromJson(Map<String, dynamic> jsonData) {
    return QuestionCategory(
      options: jsonData["options"],
      id: jsonData["id"],
      questions: (jsonData["questions"] as List<dynamic>)
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }
}
