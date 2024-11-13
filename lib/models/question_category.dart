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

  static Map<String, dynamic> toJson(QuestionCategory questionCategoryInfo) {
    return {
      "options": questionCategoryInfo.options,
      "id": questionCategoryInfo.id,
      "questions": questionCategoryInfo.questions
          .map((e) => Question.toJson(e))
          .toList(),
    };
  }

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
