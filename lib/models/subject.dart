import 'package:lingo_ai_app/models/chapter.dart';
import 'package:lingo_ai_app/models/question_category.dart';

class Subject {
  final String id;
  final String name;
  final List<Chapter> chapters;
  List<QuestionCategory> questionCategories = [];

  Subject({
    required this.name,
    required this.chapters,
    required this.id,
  });

  static Subject fromJson(
      Map<String, dynamic> jsonData, Map<String, dynamic> progressData) {
    return Subject(
      id: jsonData["id"],
      name: jsonData["name"],
      chapters: (jsonData["chapters"] as List<dynamic>)
          .map(
            (e) => Chapter.fromJson(
              e,
              (progressData["subjects"] as List<dynamic>).firstWhere(
                (s) => s["id"] == jsonData["id"],
              ),
            ),
          )
          .toList(),
    );
  }
}
