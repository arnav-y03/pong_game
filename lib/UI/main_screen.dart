import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final int maxScore;

  const MainScreen({super.key, required this.maxScore});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double ballX = 200;
  double ballY = 200;

  double dx = 8;
  double dy = 0;

  double leftPaddleY = 100;
  double rightPaddleY = 100;

  double paddleHeight = 80;

  int leftScore = 0;
  int rightScore = 0;

  bool gameOver = false;
  String winner = "";

  int seconds = 0;

  late Timer gameLoop;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    gameLoop = Timer.periodic(const Duration(milliseconds: 16), (_) {
      updateGame();
    });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!gameOver) {
        setState(() {
          seconds++;
        });
      }
    });
  }

  void updateGame() {
    if (gameOver) return;

    setState(() {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;

      ballX += dx;
      ballY += dy;

      //top & bottomm
      if (ballY <= 0 || ballY >= height - 20) {
        dy = -dy;
      }

      //left paddle
      if (ballX <= 20 &&
          ballY >= leftPaddleY &&
          ballY <= leftPaddleY + paddleHeight) {
        dx = dx.abs();

        dy = (Random().nextDouble() * 4) - 2;

        dx *= 1.05;

        dx = dx.clamp(-20, 20);
      }

      if (ballX >= width - 30 &&
          ballY >= rightPaddleY &&
          ballY <= rightPaddleY + paddleHeight) {
        dx = -dx.abs();

        dy = (Random().nextDouble() * 2) - 1;

        dx *= 1.05;

        dx = dx.clamp(-20, 20);
      }

      //left miss right getts
      if (ballX <= 0) {
        rightScore++;

        ballX = width / 2;
        ballY = height / 2;

        dx = 10;
        dy = (Random().nextDouble() * 4) - 2;
      }

      //right miss right get
      if (ballX >= width - 20) {
        leftScore++;

        ballX = width / 2;
        ballY = height / 2;

        dx = -10;
        dy = (Random().nextDouble() * 2) - 1;
      }

      if (leftScore >= widget.maxScore) {
        gameOver = true;
        winner = "Blue Wins";
      }

      if (rightScore >= widget.maxScore) {
        gameOver = true;
        winner = "Red Wins";
      }
    });
  }

  void resetGame() {
    setState(() {
      ballX = 200;
      ballY = 200;

      dx = 8;
      dy = (Random().nextDouble() * 4) - 2;

      leftScore = 0;
      rightScore = 0;

      seconds = 0;
      gameOver = false;
      winner = "";
    });
  }

  @override
  void dispose() {
    gameLoop.cancel();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            if (details.localPosition.dx < width / 2) {
              leftPaddleY += details.delta.dy;
              leftPaddleY = leftPaddleY.clamp(0, height - paddleHeight);
            } else {
              rightPaddleY += details.delta.dy;
              rightPaddleY = rightPaddleY.clamp(0, height - paddleHeight);
            }
          });
        },
        child: Stack(
          children: [
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
              left: 50,
              child: Text(
                "$leftScore",
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),

            Positioned(
              top: 40,
              right: 50,
              child: Text(
                "$rightScore",
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),

            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "$seconds s",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

            if (gameOver)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      winner,
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Time: $seconds s",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: resetGame,
                      child: const Text("Restart"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
