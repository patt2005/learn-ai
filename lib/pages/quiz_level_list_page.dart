import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingo_ai_app/models/chapter.dart';
import 'package:lingo_ai_app/models/subject.dart';
import 'package:lingo_ai_app/pages/quiz_page.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';
import 'package:lingo_ai_app/utils/game_provider.dart';
import 'package:provider/provider.dart';

class QuizLevelListPage extends StatefulWidget {
  final String subjectId;
  final String chapterId;

  const QuizLevelListPage({
    super.key,
    required this.chapterId,
    required this.subjectId,
  });

  @override
  State<QuizLevelListPage> createState() => _QuizLevelListPageState();
}

class _QuizLevelListPageState extends State<QuizLevelListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.08),
            Stack(
              children: [
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenSize.height * 0.055),
                    const Text(
                      "Lecții",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.03),
            Text(
              "Testează-ți cunoștințele acumulate!",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w400,
                fontFamily: "Jersey20",
                fontSize: 24,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Expanded(
              child: Consumer<GameProvider>(
                builder: (context, value, child) {
                  Subject foundSubject = value.subjects
                      .firstWhere((e) => e.id == widget.subjectId);
                  Chapter foundChapter = foundSubject.chapters
                      .firstWhere((e) => e.id == widget.chapterId);

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: screenSize.height * 0.05),
                    itemCount: foundChapter.quizLevels.length,
                    itemBuilder: (context, index) {
                      final quizLevel = foundChapter.quizLevels[index];

                      final bool isDone = quizLevel.isDone;
                      final Color cardColor =
                          isDone ? Colors.green : kSecondaryColor;
                      final IconData icon = isDone
                          ? CupertinoIcons.check_mark_circled
                          : CupertinoIcons.play;

                      return GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => QuizPage(
                                quizLevelInfo: quizLevel,
                                chapter: foundChapter,
                                subject: foundSubject,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      quizLevel.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                    Text(
                                      quizLevel.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "InriaSans",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (isDone)
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                CupertinoIcons.star_fill,
                                                color: Colors.yellow,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "${quizLevel.stars ?? 0} stele",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          Row(
                                            children: [
                                              const Icon(
                                                CupertinoIcons.question,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "${quizLevel.answeredQuestions ?? 0} / ${quizLevel.questions} corecte",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                children: [
                                  Icon(
                                    icon,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    isDone ? "Finalizat" : "Test",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
