import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingo_ai_app/models/subject.dart';
import 'package:lingo_ai_app/pages/chapter_list_page.dart';
import 'package:lingo_ai_app/utils/colors.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    int totalLevels = subject.chapters
        .fold(0, (sum, chapter) => sum + chapter.quizLevels.length);
    int totalCompleted =
        subject.chapters.fold(0, (sum, chapter) => sum + chapter.levelsDone);

    double progress = totalLevels > 0 ? totalCompleted / totalLevels : 0;

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => ChapterListPage(subjectId: subject.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              kSecondaryColor.withOpacity(0.8),
              kPrimaryColor.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: "InriaSans",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${subject.chapters.length} Capitole",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    color: kOrangeColor,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}% Completat",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            const Icon(
              CupertinoIcons.book,
              color: Colors.white,
              size: 35,
            ),
          ],
        ),
      ),
    );
  }
}
