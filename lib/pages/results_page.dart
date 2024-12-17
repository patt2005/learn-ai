import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingo_ai_app/models/chapter.dart';
import 'package:lingo_ai_app/models/quiz_level.dart';
import 'package:lingo_ai_app/models/subject.dart';
import 'package:lingo_ai_app/pages/quiz_page.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';
import 'package:lingo_ai_app/utils/game_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ResultsPage extends StatefulWidget {
  final int answeredQuestions;
  final int totalCoins;
  final int stars;
  final Subject subject;
  final Chapter chapter;
  final QuizLevel quizLevel;
  final int quizLevelIndex;

  const ResultsPage({
    super.key,
    required this.answeredQuestions,
    required this.totalCoins,
    required this.stars,
    required this.chapter,
    required this.quizLevel,
    required this.subject,
    required this.quizLevelIndex,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _playSound();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _saveProgress(),
    );
  }

  void _saveProgress() async {
    if (widget.stars >= 2) {
      final provider = Provider.of<GameProvider>(context, listen: false);
      await provider.saveQuizLevelProgress(
        widget.chapter,
        widget.quizLevel,
        widget.answeredQuestions,
        widget.stars,
      );
    }
  }

  void _playSound() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.play(
      AssetSource(
        widget.stars > 1
            ? "audio/game_sounds/success.mp3"
            : "audio/game_sounds/game-over.mp3",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.1),
            SizedBox(height: screenSize.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < widget.stars; i++)
                  const Icon(
                    CupertinoIcons.star_fill,
                    color: Colors.orange,
                    size: 35,
                  ),
              ],
            ),
            Lottie.asset(
              widget.stars >= 2
                  ? "data/animations/happy.json"
                  : "data/animations/sad.json",
              width: screenSize.width * 0.6,
              height: screenSize.height * 0.25,
            ),
            SizedBox(height: screenSize.height * 0.05),
            Text(
              widget.stars > 1 ? "Felicitări" : "Mai încearacă",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 26,
                fontFamily: "Geologica",
              ),
            ),
            const Text(
              "Ați acumulat:",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 19,
                fontFamily: "Inter",
              ),
            ),
            Text(
              widget.totalCoins.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 42,
                fontWeight: FontWeight.w500,
                fontFamily: "Geologica",
              ),
            ),
            const Text(
              "puncte",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 19,
                fontFamily: "Geologica",
              ),
            ),
            Text(
              "Răspunsuri corecte: ${widget.answeredQuestions}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                fontFamily: "Inter",
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 13),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(kPrimaryColor),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Acasă",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  const Text(
                    "sau",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 13),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(kPrimaryColor),
                    ),
                    onPressed: () async {
                      int index = 0;
                      if (widget.stars >= 2) {
                        index = widget.quizLevelIndex + 1;
                      } else {
                        index = widget.quizLevelIndex;
                      }
                      await Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (context) => QuizPage(
                              subject: widget.subject,
                              quizLevelInfo: widget.chapter.quizLevels[index],
                              chapter: widget.chapter),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.stars >= 2
                              ? "Următorul nivel"
                              : "Încearcă din nou",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
