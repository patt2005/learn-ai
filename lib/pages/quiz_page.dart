import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingo_ai_app/models/chapter.dart';
import 'package:lingo_ai_app/models/question_category.dart';
import 'package:lingo_ai_app/models/quiz_level.dart';
import 'package:lingo_ai_app/models/subject.dart';
import 'package:lingo_ai_app/pages/results_page.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';

class QuizPage extends StatefulWidget {
  final QuizLevel quizLevelInfo;
  final Chapter chapter;
  final Subject subject;

  const QuizPage({
    super.key,
    required this.subject,
    required this.quizLevelInfo,
    required this.chapter,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  bool _hasSelectedOptions = false;
  int? _selectedOptionIndex;

  bool _isCorrectAnswer = false;
  int _totalCoins = 0;
  int _remainingSeconds = 0;

  List<String> _currentOptions = [];
  bool _showOptions = false;

  late AnimationController _animationController;
  late final AudioPlayer _audioPlayer;

  late QuestionCategory _questionCategory;
  final List<Question> _questions = [];

  double _totalAnsweredTime = 0;

  int _correntAnswers = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _remainingSeconds = widget.quizLevelInfo.timePerQuestion;
    _questionCategory = widget.subject.questionCategories
        .firstWhere((e) => e.id == widget.quizLevelInfo.questionCategoryId);

    _generateQuestions();
    _generateOptions();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _remainingSeconds),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _totalAnsweredTime += widget.quizLevelInfo.timePerQuestion;
            _hasSelectedOptions = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _generateQuestions() {
    Set<int> usedIndices = {};
    _questions.clear();

    while (_questions.length < widget.quizLevelInfo.questions) {
      int randomIndex = Random().nextInt(_questionCategory.questions.length);

      if (!usedIndices.contains(randomIndex)) {
        _questions.add(_questionCategory.questions[randomIndex]);
        usedIndices.add(randomIndex);
      }
    }
  }

  void _generateOptions() {
    List<String> options = [_questions[_currentQuestionIndex].answer];

    while (options.length < widget.quizLevelInfo.options) {
      String randomOption = _questionCategory
          .options[Random().nextInt(_questionCategory.options.length)];

      if (!options.contains(randomOption)) {
        options.add(randomOption);
      }
    }

    options.shuffle();
    setState(() {
      _currentOptions = options;
    });
  }

  Future<void> _playSound(String audioPath) async {
    try {
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  void _onNextQuestion() async {
    if (_selectedOptionIndex != null || _hasSelectedOptions) {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedOptionIndex = null;
          _hasSelectedOptions = false;
          _showOptions = false;
        });
        _generateOptions();
        _animationController.reset();
      } else {
        int stars = _calculateStars(
          _totalAnsweredTime,
          _questions.length,
          widget.quizLevelInfo.timePerQuestion,
        );
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              answeredQuestions: _correntAnswers,
              totalCoins: _totalCoins,
              stars: stars,
              category: widget.chapter,
              quizLevel: widget.quizLevelInfo,
            ),
          ),
        );
      }
    }
  }

  int _calculateStars(
      double totalTimeSpent, int totalQuestions, int timePerQuestion) {
    double averageTimePerQuestion = totalTimeSpent / totalQuestions;
    double maxAllowedTime = timePerQuestion.toDouble();

    if (averageTimePerQuestion <= 0.5 * maxAllowedTime) {
      return 3;
    } else if (averageTimePerQuestion <= 0.75 * maxAllowedTime) {
      return 2;
    } else {
      return 1;
    }
  }

  Widget _buildOptionsList() {
    return Column(
      children: [
        const Text(
          "Selectează varianta corectă",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black38,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(height: screenSize.height * 0.01),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: _showOptions
                ? [
                    for (int index = 0; index < _currentOptions.length; index++)
                      Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: const WidgetStatePropertyAll(0),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                    color: _selectedOptionIndex == index
                                        ? _isCorrectAnswer
                                            ? Colors.green
                                            : Colors.red
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              backgroundColor: WidgetStateProperty.all(
                                _selectedOptionIndex == index
                                    ? _isCorrectAnswer
                                        ? Colors.green.withOpacity(0.5)
                                        : Colors.red.withOpacity(0.5)
                                    : Colors.transparent,
                              ),
                            ),
                            onPressed: () async {
                              if (!_hasSelectedOptions) {
                                _selectedOptionIndex = index;
                                _isCorrectAnswer = _currentOptions[index] ==
                                    _questions[_currentQuestionIndex].answer;
                                _animationController.forward();
                                if (_isCorrectAnswer) {
                                  double answeredTime =
                                      _animationController.value *
                                          widget.quizLevelInfo.timePerQuestion;
                                  _totalAnsweredTime += answeredTime;
                                  _addCoins(_animationController.value);
                                  _correntAnswers++;
                                  await _audioPlayer.play(AssetSource(
                                      "audio/game_sounds/right.mp3"));
                                } else {
                                  _totalAnsweredTime +=
                                      widget.quizLevelInfo.timePerQuestion;
                                  await _audioPlayer.play(AssetSource(
                                      "audio/game_sounds/wrong.mp3"));
                                }
                                _hasSelectedOptions = true;
                                _animationController.stop();
                                setState(() {});
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${index + 1}. ${_currentOptions[index]}",
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 18,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.black26,
                          ),
                        ],
                      ),
                  ]
                : [
                    const Text(
                      "Trebuie să apeși butonul de play pentru a vedea opțiunile.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
          ),
        ),
      ],
    );
  }

  Color _getIndicatorColor(double value) {
    if (value <= 0.33) {
      return Colors.green;
    } else if (value <= 0.66) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  void _addCoins(double value) {
    if (value <= 0.33) {
      _totalCoins += 3;
    } else if (value <= 0.66) {
      _totalCoins += 2;
    } else {
      _totalCoins++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.02),
              Stack(
                children: [
                  Positioned(
                    left: 0,
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
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text(
                              'Informație',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              'Veți primi puncte în funcție de timpul pe care îl petreceți pentru a răspunde la întrebare. Cu cât răspundeți mai repede, cu atât obțineți mai multe puncte!🙂',
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: const Text('Închide'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(CupertinoIcons.info_circle, size: 30),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenSize.height * 0.055),
                      Text(
                        "Scor : $_totalCoins",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.02),
              LinearProgressIndicator(
                value: _animationController.value,
                color: kPrimaryColor,
                minHeight: 20,
                backgroundColor: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getIndicatorColor(_animationController.value),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                "Întrebarea ${_currentQuestionIndex + 1}/${_questions.length}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                  fontFamily: "Jersey20",
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(18),
                      backgroundColor: kOrangeColor,
                      elevation: 3,
                      shadowColor: Colors.grey.withOpacity(0.5),
                    ),
                    onPressed: () async {
                      if (!_hasSelectedOptions) {
                        _animationController.forward();
                        setState(() {
                          _showOptions = true;
                        });
                      }
                      await _playSound(
                          _questions[_currentQuestionIndex].assetFilePath);
                    },
                    child: const Icon(
                      CupertinoIcons.play_fill,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Atingeți butonul pentru a asculta sunetul.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: "Inter",
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildOptionsList(),
              const Spacer(),
              ElevatedButton(
                onPressed: _onNextQuestion,
                style: ButtonStyle(
                  elevation: const WidgetStatePropertyAll(0),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 13),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(_hasSelectedOptions
                      ? kSecondaryColor
                      : kSecondaryColor.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Următorul",
                      style: TextStyle(
                        fontSize: 17,
                        color:
                            _hasSelectedOptions ? Colors.white : Colors.black26,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
