import 'package:flutter/material.dart';
import 'package:lingo_ai_app/models/onboarding_info.dart';
import 'package:lingo_ai_app/pages/navigation_page.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();

  Widget _buildOnboardingPage(OnboardingInfo info, int index) {
    return SafeArea(
      child: Container(
        color: kBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.07),
              Image.asset(
                info.imageAssetPath,
                width: screenSize.height * 0.33,
                height: screenSize.height * 0.33,
                fit: BoxFit.contain,
              ),
              SizedBox(height: screenSize.height * 0.05),
              Text(
                info.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "JosefinSans",
                  color: kOrangeColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Text(
                info.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 3; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: i == index ? 60 : 17,
                      height: 17,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(8.5),
                        color: i == index ? kOrangeColor : kPrimaryColor,
                      ),
                    )
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 15),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(kSecondaryColor),
                ),
                onPressed: () async {
                  if (index == onboardingPagesInfo.length - 1) {
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const NavigationPage(),
                      ),
                    );
                    return;
                  }
                  await _pageController.nextPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      info.buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PageView(
        controller: _pageController,
        children: [
          for (int i = 0; i < onboardingPagesInfo.length; i++)
            _buildOnboardingPage(onboardingPagesInfo[i], i),
        ],
      ),
    );
  }
}
