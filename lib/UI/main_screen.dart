import 'dart:async';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double ballX = 200; //verticall
  double ballY = 200; //horizontal

  double dx = 3; // horizontal speed
  double dy = 3; // vertical speed

  double leftPaddleY = 100;
  double rightPaddleY = 100;

  double paddleHeight = 80;

  bool gameOver = false;
  int leftCount = 0;
  int rightCount = 0;

  String winText = "";

  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      updateGame();
    });
  }

  void updateGame() {
    if (gameOver) return;

    setState(() {
      ballX += dx;
      ballY += dy;

      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      /// Top & Bottom bounce horizontall
      if (ballY <= 0 || ballY >= screenHeight - 20) {
        dy = -dy;
      }

      /// LEFT paddle
      if (ballX <= 20 &&
          ballY >= leftPaddleY &&
          ballY <= leftPaddleY + paddleHeight) {
        dx = -dx;
        leftCount++;
      }

      /// RIGHT paddle hit
      if (ballX >= screenWidth - 30 &&
          ballY >= rightPaddleY &&
          ballY <= rightPaddleY + paddleHeight) {
        dx = -dx;
        rightCount++;
      }

      /// Game over
      if (ballX < 0 || ballX > screenWidth) {
        gameOver = true;

        if (leftCount > rightCount) {
          winText = "Blue Wins";
        } else if (rightCount > leftCount) {
          winText = 'Red Wins';
        } else {
          winText = 'Draw';
        }
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void resetGame() {
    setState(() {
      ballX = 100;
      ballY = 100;
      dx = 3;
      dy = 3;
      gameOver = false;
      leftCount = 0;
      rightCount = 0;
      winText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            if (details.localPosition.dx <
                MediaQuery.of(context).size.width / 2) {
              leftPaddleY += details.delta.dy;
            } else {
              rightPaddleY += details.delta.dy;
            }
          });
        },
        child: Stack(
          children: [
            /// Ball
            Positioned(
              left: ballX,
              top: ballY,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            /// Left Paddle
            Positioned(
              left: 10,
              top: leftPaddleY,
              child: Container(
                width: 10,
                height: paddleHeight,
                color: Colors.blue,
              ),
            ),
            Positioned(
              top: 40,
              left: 50,
              child: Text(
                "$leftCount",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// Right Paddle
            Positioned(
              right: 10,
              top: rightPaddleY,
              child: Container(
                width: 10,
                height: paddleHeight,
                color: Colors.red,
              ),
            ),
            Positioned(
              top: 40,
              right: 50,
              child: Text(
                "$rightCount",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (gameOver)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      winText,
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: resetGame,
                      child: const Text("Restart"),
                    ),
                  ],
                ),
              ),

            // /// Game Over UI
            // if (gameOver)
            //   Center(
            //     child: ElevatedButton(
            //       onPressed: resetGame,
            //       child: const Text("Restart"),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
