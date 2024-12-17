import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lingo_ai_app/models/question_category.dart';
import 'package:lingo_ai_app/models/subject.dart';
import 'package:lingo_ai_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubjectService {
  Future<List<Subject>> loadDataFromClient() async {
    final jsonData = await ApiService.instance.getJsonContent("data");
    final questionCategoriesJson =
        await ApiService.instance.getJsonContent("question_categories");
    final progressData = await _getJson("progress") ?? {};

    List<Subject> subjects = [];
    for (var subjectData in jsonData["subjects"]) {
      Subject subject = Subject.fromJson(subjectData, progressData);
      subject.questionCategories =
          (questionCategoriesJson[subject.id] as List<dynamic>)
              .map((q) => QuestionCategory.fromJson(q))
              .toList();
      subjects.add(subject);
    }
    return subjects;
  }

  Future<List<Subject>> loadDataFromServer() async {
    final data = await ApiService.instance.getJsonContent("data");
    final questionCategoriesJson =
        await ApiService.instance.getJsonContent("question_categories");

    final dataString = await rootBundle.loadString("data/progress.json");
    final progressData = jsonDecode(dataString);

    List<Subject> subjects = [];
    for (var subjectData in data["subjects"]) {
      Subject subject = Subject.fromJson(subjectData, progressData);
      subject.questionCategories =
          (questionCategoriesJson[subject.id] as List<dynamic>)
              .map((q) => QuestionCategory.fromJson(q))
              .toList();
      subjects.add(subject);
    }

    await saveProgress(subjects);

    return subjects;
  }

  Future<void> saveProgress(List<Subject> subjects) async {
    final progressData = {
      "subjects": subjects.map((subject) {
        return {
          "id": subject.id,
          "chapters": subject.chapters.map((chapter) {
            return {
              "id": chapter.id,
              "status": chapter.status.index,
              "quizLevels": chapter.quizLevels.map((quizLevel) {
                return {
                  "title": quizLevel.title,
                  "isDone": quizLevel.isDone,
                  "answeredQuestions": quizLevel.answeredQuestions,
                  "stars": quizLevel.stars,
                };
              }).toList(),
            };
          }).toList(),
        };
      }).toList(),
    };

    await _saveJson(progressData, "progress");
  }

  Future<void> _saveJson(Map<String, dynamic> jsonData, String key) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(jsonData);
    await prefs.setString(key, jsonString);
  }

  Future<Map<String, dynamic>?> _getJson(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);

    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }
}
