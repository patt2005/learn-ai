import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingo_ai_app/components/subject_card.dart';
import 'package:lingo_ai_app/pages/settings_page.dart';
import 'package:lingo_ai_app/pages/subject_list_page.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';
import 'package:lingo_ai_app/utils/game_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildTipCard(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(
              color: kOrangeColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                provider.advice,
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: kBackgroundColor,
            ),
            child: const Text(
              'Sfatul zilei',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: "HammersmithOne",
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.02),
              Stack(
                children: [
                  Positioned(
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          CupertinoIcons.gear,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenSize.height * 0.06,
                      ),
                      Text(
                        "Learn AI",
                        style: TextStyle(
                          color: kOrangeColor,
                          fontFamily: "JosefinSans",
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.015),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  '"Transformă fiecare cuvânt într-o nouă aventură".',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "Jersey20",
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Consumer<GameProvider>(
                builder: (context, value, child) => Column(
                  children: [
                    for (var subject in value.subjects.take(3).toList())
                      SubjectCard(subject: subject),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const SubjectListPage(),
                    ),
                  );
                },
                child: const Text(
                  "Vezi mai mult",
                  style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                    fontSize: 15,
                  ),
                ),
              ),
              const Divider(
                color: Colors.black38,
              ),
              SizedBox(height: screenSize.height * 0.01),
              _buildTipCard(context),
            ],
          ),
        ),
      ),
    );
  }
}
