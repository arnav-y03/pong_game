import 'package:flutter/material.dart';
import 'package:pin_ball_game/UI/select_score.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StartScreen());
  }
}
