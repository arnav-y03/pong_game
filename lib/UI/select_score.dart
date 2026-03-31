import 'package:flutter/material.dart';
import 'main_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  void startGame(BuildContext context, int score) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MainScreen(maxScore: score)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Select Match Points",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => startGame(context, 5),
                    child: const Text("5 Points"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => startGame(context, 7),
                    child: const Text("7 Points"),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => startGame(context, 10),
                    child: const Text("10 Points"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => startGame(context, 15),
                    child: const Text("15 Points"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
