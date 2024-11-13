import 'package:flutter/material.dart';
import 'package:lingo_ai_app/pages/navigation_page.dart';
import 'package:lingo_ai_app/pages/onboarding_page.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';
import 'package:lingo_ai_app/utils/game_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate();
    });
  }

  void _navigate() async {
    final provider = Provider.of<GameProvider>(context, listen: false);
    bool isFirstOpen = await isFirstAppOpen();
    if (isFirstOpen) {
      await provider.loadDataFromServer();
      await Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OnboardingPage(),
          ),
        ),
      );
    } else {
      await provider.loadDataFromClient();
      await Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const NavigationPage(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: LottieBuilder.asset(
          "data/animations/loading.json",
          width: screenSize.height * 0.15,
          height: screenSize.height * 0.15,
        ),
      ),
    );
  }
}
