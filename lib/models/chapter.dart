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

  static Chapter fromJson(
      Map<String, dynamic> jsonData, Map<String, dynamic> chapterProgress) {
    final chapter = (chapterProgress["chapters"] as List<dynamic>).firstWhere(
      (c) => c["id"] == jsonData["id"],
    );
    return Chapter(
      id: jsonData["id"],
      title: jsonData["title"],
      status: ChapterStatus.values[chapter["status"]],
      quizLevels: (jsonData["quizLevels"] as List<dynamic>)
          .map(
            (e) => QuizLevel.fromJson(e as Map<String, dynamic>, chapter),
          )
          .toList(),
      name: jsonData["name"],
    );
  }
}
