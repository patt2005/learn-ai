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

  static Subject fromJson(Map<String, dynamic> jsonData) {
    return Subject(
      id: jsonData["id"],
      name: jsonData["name"],
      chapters: (jsonData["chapters"] as List<dynamic>)
          .map(
            (e) => Chapter.fromJson(e),
          )
          .toList(),
    );
  }

  static Map<String, dynamic> toJson(Subject subjectData) {
    return {
      "questionCategories": subjectData.questionCategories
          .map((e) => QuestionCategory.toJson(e))
          .toList(),
      "name": subjectData.name,
      "chapters": subjectData.chapters.map((e) => Chapter.toJson(e)).toList(),
      "id": subjectData.id,
    };
  }
}
