import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lingo_ai_app/models/question_category.dart';
import 'package:lingo_ai_app/models/subject.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubjectService {
  Future<List<Subject>> loadDataFromClient() async {
    final jsonData = await _getJson("data");
    final questionCategoriesJson = await _getQuestionCategoryJson();

    if (jsonData != null) {
      List<Subject> subjects = [];
      for (var subjectData in jsonData["subjects"]) {
        Subject subject = Subject.fromJson(subjectData);
        subject.questionCategories =
            (questionCategoriesJson[subject.id] as List<dynamic>)
                .map((q) => QuestionCategory.fromJson(q))
                .toList();
        subjects.add(subject);
      }
      return subjects;
    } else {
      return await loadDataFromServer();
    }
  }

  Future<Map<String, dynamic>> _getQuestionCategoryJson() async {
    final jsonString =
        await rootBundle.loadString("data/question_categories.json");
    final data = jsonDecode(jsonString);
    return data;
  }

  Future<List<Subject>> loadDataFromServer() async {
    final jsonString = await rootBundle.loadString("data/data.json");
    final data = jsonDecode(jsonString);
    final questionCategoriesJson = await _getQuestionCategoryJson();

    List<Subject> subjects = [];
    for (var subjectData in data["subjects"]) {
      Subject subject = Subject.fromJson(subjectData);
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
    final jsonData = {
      "subjects": subjects.map((subject) => Subject.toJson(subject)).toList(),
    };
    await _saveJson(jsonData, "data");
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
