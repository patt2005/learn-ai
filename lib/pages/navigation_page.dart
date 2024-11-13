import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingo_ai_app/pages/home_page.dart';
import 'package:lingo_ai_app/pages/profile_page.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final List<Widget> _pageList = [
    const HomePage(),
    const ProfilePage(),
  ];
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            _pageList[_currentPageIndex],
            Positioned(
              right: 29,
              left: 29,
              bottom: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _currentPageIndex = 0;
                          });
                        },
                        icon: Icon(
                          CupertinoIcons.home,
                          color: _currentPageIndex == 0
                              ? Colors.white
                              : Colors.white30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.04,
                      child: const VerticalDivider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _currentPageIndex = 1;
                          });
                        },
                        icon: Icon(
                          CupertinoIcons.profile_circled,
                          color: _currentPageIndex == 1
                              ? Colors.white
                              : Colors.white30,
                        ),
                      ),
                    ),
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
