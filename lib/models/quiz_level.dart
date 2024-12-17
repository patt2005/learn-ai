import 'package:flutter/foundation.dart';
import 'package:lingo_ai_app/utils/consts.dart';

class QuizLevel {
  final String questionCategoryId;
  final int timePerQuestion;
  final int questions;
  bool isDone;
  final int options;
  final String title;
  final String name;
  int? answeredQuestions;
  int? stars;

  QuizLevel({
    required this.timePerQuestion,
    required this.questions,
    required this.title,
    required this.options,
    required this.name,
    required this.questionCategoryId,
    this.isDone = false,
    this.answeredQuestions,
    this.stars,
  });

  static QuizLevel fromJson(
      Map<String, dynamic> jsonData, Map<String, dynamic> quizLevelProgress) {
    try {
      final foundQuizLevel = (quizLevelProgress["quizLevels"] as List<dynamic>)
          .firstWhere((q) => q["title"] == jsonData["title"]);
      return QuizLevel(
        questionCategoryId: jsonData["questionCategory"],
        timePerQuestion: jsonData["timePerQuestion"],
        questions: jsonData["questions"],
        options: jsonData["options"],
        title: jsonData["title"],
        name: jsonData["name"],
        isDone: foundQuizLevel["isDone"],
        answeredQuestions: foundQuizLevel["answeredQuestions"] ?? 0,
        stars: foundQuizLevel["stars"] ?? 0,
      );
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}

class Question {
  final String assetFilePath;
  final String answer;
  final QuestionType questionTYpe;
  final String text;
  final OptionType optionType;

  Question({
    required this.text,
    required this.assetFilePath,
    required this.answer,
    required this.questionTYpe,
    required this.optionType,
  });

  static Question fromJson(Map<String, dynamic> jsonData) {
    return Question(
      text: jsonData["text"],
      assetFilePath: jsonData["asset"],
      answer: jsonData["answer"],
      questionTYpe: QuestionType.values[jsonData["type"]],
      optionType: OptionType.values[jsonData["optionType"] ?? 0],
    );
  }
}
