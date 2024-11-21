import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Size screenSize;

enum ChapterStatus {
  inProgress,
  done,
  notAvailable,
}

enum QuestionType {
  image,
  audio,
}

enum OptionType {
  pickable,
  input,
}

Future<bool> isFirstAppOpen() async {
  final prefs = await SharedPreferences.getInstance();
  bool? firstOpen = prefs.getBool("open") ?? true;
  await prefs.setBool("open", false);
  return firstOpen;
}
