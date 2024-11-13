import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lingo_ai_app/models/subject.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';
import 'package:lingo_ai_app/utils/game_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? imageFile;

  Widget _buildSubjectProgressCard(Subject subjectInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subjectInfo.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        SizedBox(height: screenSize.height * 0.01),
        for (var chapter in subjectInfo.chapters)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    chapter.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "${chapter.levelsDone}/${chapter.quizLevels.length} teste",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: chapter.levelsDone / chapter.quizLevels.length,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
      ],
    );
  }

  void _showCupertinoPopup(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final controller = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Introduceți numele'),
          content: Column(
            children: [
              const SizedBox(height: 8.0),
              CupertinoTextField(
                controller: controller,
                placeholder: 'Poreclă...',
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Anulează'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Salvează'),
              onPressed: () async {
                provider.setNickname(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.05),
            Consumer<GameProvider>(
              builder: (context, value, child) => Container(
                padding:
                    EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: screenSize.width,
                child: Row(
                  children: [
                    value.profileImagePath.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black38),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                File(value.profileImagePath),
                                width: screenSize.height * 0.15,
                                height: screenSize.height * 0.15,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            width: screenSize.height * 0.15,
                            height: screenSize.height * 0.15,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBDBDB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black38),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset("images/placeholder.jpg"),
                            ),
                          ),
                    SizedBox(width: screenSize.width * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bine te-am găsit",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              fontFamily: "Geologica",
                            ),
                          ),
                          Consumer<GameProvider>(
                            builder: (context, value, child) => Text(
                              value.nickname.isEmpty
                                  ? "utilizator!"
                                  : "${value.nickname}!",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(kPrimaryColor),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 19,
                  ),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Schimbați numele",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _showCupertinoPopup(context);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 13, horizontal: 19),
                ),
                backgroundColor: WidgetStatePropertyAll(kPrimaryColor),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Schimbați imaginea de profil",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                final imagePicker = ImagePicker();
                final image =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final cacheDir = await getTemporaryDirectory();
                  final filePath =
                      path.join(cacheDir.path, 'profile_picture.png');
                  final newFile = File(filePath);

                  if (await newFile.exists()) {
                    await newFile.delete();
                  }

                  await File(image.path).copy(filePath);

                  provider.setProfileImagePath(filePath);
                }
              },
            ),
            SizedBox(height: screenSize.height * 0.02),
            const Text(
              "Progresul tău",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontFamily: "Geologica",
                fontSize: 22,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Consumer<GameProvider>(
              builder: (context, value, child) => Expanded(
                child: ListView.builder(
                  itemCount: value.subjects.length,
                  padding: EdgeInsets.only(bottom: screenSize.height * 0.1),
                  itemBuilder: (context, index) {
                    return _buildSubjectProgressCard(value.subjects[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
