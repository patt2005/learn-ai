import 'package:lingo_ai_app/models/quiz_level.dart';
import 'package:lingo_ai_app/utils/consts.dart';

class Chapter {
  final String id;
  final String title;
  final String name;
  ChapterStatus status;
  final List<QuizLevel> quizLevels;
  int get levelsDone => quizLevels.where((e) => e.isDone).toList().length;

  Chapter({
    required this.id,
    required this.title,
    required this.status,
    required this.quizLevels,
    required this.name,
  });

  void updateStatus() {
    if (levelsDone == quizLevels.length) {
      status = ChapterStatus.done;
    } else if (levelsDone > 0) {
      status = ChapterStatus.inProgress;
    } else {
      status = ChapterStatus.notAvailable;
    }
  }

  void checkAvailability(Chapter? previousChapter) {
    if (status == ChapterStatus.done) return;

    if (previousChapter == null) {
      status = ChapterStatus.inProgress;
      return;
    }

    if (previousChapter.status == ChapterStatus.done) {
      status = ChapterStatus.inProgress;
    } else {
      status = ChapterStatus.notAvailable;
    }
  }

  static Map<String, dynamic> toJson(Chapter chapterCategory) {
    return {
      "title": chapterCategory.title,
      "name": chapterCategory.name,
      "status": chapterCategory.status.index,
      "quizLevels":
          chapterCategory.quizLevels.map((e) => QuizLevel.toJson(e)).toList(),
      "id": chapterCategory.id,
    };
  }

  static Chapter fromJson(Map<String, dynamic> jsonData) {
    return Chapter(
      id: jsonData["id"],
      title: jsonData["title"],
      status: ChapterStatus.values[jsonData["status"]],
      quizLevels: (jsonData["quizLevels"] as List<dynamic>)
          .map((e) => QuizLevel.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: jsonData["name"],
    );
  }
}
