import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:lingo_ai_app/models/chapter.dart';
import 'package:lingo_ai_app/models/quiz_level.dart';
import 'package:lingo_ai_app/models/subject.dart';
import 'package:lingo_ai_app/services/subject_service.dart';
import 'package:lingo_ai_app/utils/consts.dart';

class GameProvider extends ChangeNotifier {
  String _nickname = "";
  String get nickname => _nickname;

  String _profileImagePath = "";
  String get profileImagePath => _profileImagePath;

  final SubjectService _subjectService = SubjectService();

  final List<String> _advicesList = [
    "Chiar și 15 minute pe zi pot face o mare diferență. Încearcă să studiezi zilnic, chiar și pentru perioade scurte.",
    "Ascultă podcasturi, cântece sau cărți audio în limba engleză. Încearcă să repeți cu voce tare ceea ce auzi.",
    "Alege cărți, articole sau bloguri care te interesează. Subliniază cuvinte noi și încearcă să le înveți contextul.",
    "Găsește un partener de conversație sau înscrie-te într-un grup de discuții în limba engleză. Practica este esențială!",
    "În plus față de aplicația noastră, explorează și alte aplicații de învățare a limbilor străine.",
    "Scrie câteva propoziții în limba engleză în fiecare zi. Poți descrie ziua ta, gândurile sau sentimentele tale.",
    "Alege filme și seriale cu subtitrări în engleză sau în limba ta maternă.",
    "În loc să înveți liste lungi de cuvinte, încearcă să le înveți în cadrul unor propoziții sau fraze.",
    "Nu-ți fie frică să greșești. Greșelile sunt o parte normală a procesului de învățare. Cu cât exersezi mai mult, cu atât vei face mai puține greșeli.",
    "Răsplătește-te. Stabilește obiective mici și recompensează-te când le atingi."
  ];

  String? _advice;
  String get advice {
    if (_advice == null || _advice!.isEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(_advicesList.length);
      _advice = _advicesList[randomIndex];
    }
    return _advice!;
  }

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  void setProfileImagePath(String path) {
    _profileImagePath = path;
    notifyListeners();
  }

  Future<void> loadData(bool isFirstOpen) async {
    if (isFirstOpen) {
      _subjects = await _subjectService.loadDataFromServer();
    } else {
      _subjects = await _subjectService.loadDataFromClient();
    }
    notifyListeners();
  }

  Future<void> saveQuizLevelProgress(Chapter chapter, QuizLevel quizLevel,
      int answeredQuestions, int stars) async {
    final foundCategory = _subjects
        .expand((subject) => subject.chapters)
        .firstWhere((e) => e == chapter);
    final foundQuizLevel =
        foundCategory.quizLevels.firstWhere((e) => e == quizLevel);
    foundQuizLevel.answeredQuestions = answeredQuestions;
    foundQuizLevel.stars = stars;

    foundQuizLevel.isDone = true;

    foundCategory.updateStatus();

    if (foundCategory.status == ChapterStatus.done) {
      _unlockNextChapter(foundCategory);
    }

    await _subjectService.saveProgress(subjects);
    notifyListeners();
  }

  void _unlockNextChapter(Chapter currentChapter) {
    final subject = _subjects
        .firstWhere((subject) => subject.chapters.contains(currentChapter));
    final currentIndex = subject.chapters.indexOf(currentChapter);

    if (currentIndex < subject.chapters.length - 1) {
      final nextChapter = subject.chapters[currentIndex + 1];
      if (nextChapter.status == ChapterStatus.notAvailable) {
        nextChapter.status = ChapterStatus.inProgress;
      }
    }
  }

  Future<void> resetProgress() async {
    for (var subject in _subjects) {
      for (var chapter in subject.chapters) {
        chapter.status = ChapterStatus.notAvailable;

        for (var quizLevel in chapter.quizLevels) {
          quizLevel.isDone = false;
        }
      }

      if (subject.chapters.isNotEmpty) {
        subject.chapters.first.status = ChapterStatus.inProgress;
      }
    }

    await _subjectService.saveProgress(subjects);

    notifyListeners();
  }

  void setNickname(String name) {
    _nickname = name;
    notifyListeners();
  }
}
