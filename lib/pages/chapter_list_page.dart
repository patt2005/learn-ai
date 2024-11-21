import 'package:flutter/material.dart';
import 'package:lingo_ai_app/components/chapter_card.dart';
import 'package:lingo_ai_app/models/subject.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';
import 'package:lingo_ai_app/utils/game_provider.dart';
import 'package:provider/provider.dart';

class ChapterListPage extends StatefulWidget {
  final String subjectId;

  const ChapterListPage({
    super.key,
    required this.subjectId,
  });

  @override
  State<ChapterListPage> createState() => _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      "Capitole",
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
            Expanded(
              child: Consumer<GameProvider>(
                builder: (context, value, child) {
                  Subject foundSubject = value.subjects
                      .firstWhere((e) => e.id == widget.subjectId);

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: foundSubject.chapters.length,
                    itemBuilder: (context, index) {
                      return ChapterCard(
                        chapterInfo: foundSubject.chapters[index],
                        subjectId: widget.subjectId,
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
