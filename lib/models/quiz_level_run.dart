import 'package:lingo_ai_app/models/quiz_level.dart';

class QuizLevelRun {
  final List<String> options;
  final int answerTime;
  final List<Question> questions;
  final int gainedCoins;
  final List<String> selectedOptions;

  QuizLevelRun({
    required this.options,
    required this.answerTime,
    required this.questions,
    required this.gainedCoins,
    required this.selectedOptions,
  });
}
