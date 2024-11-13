import 'package:flutter/material.dart';
import 'package:lingo_ai_app/pages/splash_page.dart';
import 'package:lingo_ai_app/utils/consts.dart';
import 'package:lingo_ai_app/utils/game_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      child: const MyApp(),
      create: (context) => GameProvider(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return MaterialApp(
      theme: ThemeData(fontFamily: "ComicNeue"),
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}
