import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingo_ai_app/models/chapter.dart';
import 'package:lingo_ai_app/pages/quiz_level_list_page.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';

class ChapterCard extends StatelessWidget {
  final Chapter chapterInfo;
  final String subjectId;

  const ChapterCard({
    super.key,
    required this.chapterInfo,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (chapterInfo.status != ChapterStatus.notAvailable) {
          await Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => QuizLevelListPage(
                chapterId: chapterInfo.id,
                subjectId: subjectId,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapterInfo.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                    ),
                  ),
                  Text(
                    chapterInfo.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: "InriaSans",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            chapterInfo.status == ChapterStatus.inProgress ||
                    chapterInfo.status == ChapterStatus.done
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${chapterInfo.levelsDone}/${chapterInfo.quizLevels.length} lecții",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Inter",
                          fontSize: 13,
                        ),
                      ),
                      if (chapterInfo.status == ChapterStatus.done)
                        Text(
                          "Completat!",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: "Inter",
                            color: kOrangeColor,
                          ),
                        ),
                    ],
                  )
                : const Row(
                    children: [
                      Text(
                        "Nedeblocat",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: "Inter",
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(CupertinoIcons.lock, color: Colors.grey),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
