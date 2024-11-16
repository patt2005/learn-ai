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

  static Map<String, dynamic> toJson(QuizLevel quizLevel) {
    return {
      "title": quizLevel.title,
      "name": quizLevel.name,
      "isDone": quizLevel.isDone,
      "timePerQuestion": quizLevel.timePerQuestion,
      "questions": quizLevel.questions,
      "questionCategory": quizLevel.questionCategoryId,
      "options": quizLevel.options,
      "answeredQuestions": quizLevel.answeredQuestions ?? 0,
      "stars": quizLevel.stars ?? 0,
    };
  }

  static QuizLevel fromJson(Map<String, dynamic> jsonData) {
    return QuizLevel(
      questionCategoryId: jsonData["questionCategory"],
      timePerQuestion: jsonData["timePerQuestion"],
      questions: jsonData["questions"],
      options: jsonData["options"],
      title: jsonData["title"],
      name: jsonData["name"],
      isDone: jsonData["isDone"] ?? false,
      answeredQuestions: jsonData["answeredQuestions"] ?? 0,
      stars: jsonData["stars"] ?? 0,
    );
  }
}

class Question {
  final String assetFilePath;
  final String answer;
  final QuestionType questionTYpe;
  final String text;

  Question({
    required this.text,
    required this.assetFilePath,
    required this.answer,
    required this.questionTYpe,
  });

  static Question fromJson(Map<String, dynamic> jsonData) {
    return Question(
      text: jsonData["text"],
      assetFilePath: jsonData["asset"],
      answer: jsonData["answer"],
      questionTYpe: QuestionType.values[jsonData["type"]],
    );
  }

  static Map<String, dynamic> toJson(Question questionData) {
    return {
      "asset": questionData.assetFilePath,
      "answer": questionData.answer,
      "text": questionData.text,
      "type": questionData.questionTYpe.index,
    };
  }
}
