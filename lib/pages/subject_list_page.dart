import 'package:flutter/material.dart';
import 'package:lingo_ai_app/components/subject_card.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';
import 'package:lingo_ai_app/utils/game_provider.dart';
import 'package:provider/provider.dart';

class SubjectListPage extends StatefulWidget {
  const SubjectListPage({super.key});

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
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
                      "Discipline",
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
            Consumer<GameProvider>(
              builder: (context, value, child) => Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    for (var subject in value.subjects.take(3).toList())
                      SubjectCard(subject: subject),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
