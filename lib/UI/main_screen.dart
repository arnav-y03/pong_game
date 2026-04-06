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

  double dx = 15;
  double dy = 5;

  double leftX = 20;
  double leftY = 150;

  double rightX = 300;
  double rightY = 150;

  double racketWidth = 50;
  double racketHeight = 100;

  double boardWidth = 0;
  double boardHeight = 0;

  int leftScore = 0;
  int rightScore = 0;

  bool gameOver = false;
  String winner = "";

  int seconds = 0;

  double speedIncreaseFactor = 1.2;
  double maxspeed = 30;

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
    if (gameOver || boardWidth == 0) return;

    setState(() {
      ballX += dx;
      ballY += dy;

      // top and bottom wall
      if (ballY <= 0 || ballY >= boardHeight - 20) {
        dy = -dy;
      }

      double racketCenter = leftY + racketHeight / 2;
      double ballCenter = ballY + 10;

      if (racketCenter < ballCenter) {
        leftY += 4;
      } else if (racketCenter > ballCenter) {
        leftY -= 4;
      }

      // left racket
      if (ballX <= leftX + racketWidth &&
          ballX >= leftX &&
          ballY + 20 >= leftY &&
          ballY <= leftY + racketHeight &&
          dx < 0) {
        ballX = leftX + racketWidth;
        dx = dx.abs() * speedIncreaseFactor;

        //dx = dx > 0 ? dx + 1 : dx - 1;
        //dy = (Random().nextDouble() * 6) - 4 * speedIncreaseFactor;

        dx = dx.clamp(-maxspeed, maxspeed);
        dy = dy.clamp(-maxspeed, maxspeed);
      }

      //right racket
      if (ballX + 20 >= rightX &&
          ballX <= rightX + racketWidth &&
          ballY + 20 >= rightY &&
          ballY <= rightY + racketHeight &&
          dx > 0) {
        ballX = rightX - 20;
        // dx = -dx.abs() * speedIncreaseFactor;
        dx = -dx.abs() * speedIncreaseFactor;
        //dx = dx > 0 ? dx + 1 : dx - 1;

        //dy = ((Random().nextDouble() * 6) - 4) * speedIncreaseFactor;

        dx = dx.clamp(-maxspeed, maxspeed);
        dy = dy.clamp(-maxspeed, maxspeed);
      }

      //left miss
      if (ballX <= 0) {
        rightScore++;
        resetBall(false);
      }

      // right miss
      if (ballX >= boardWidth - 20) {
        leftScore++;
        resetBall(true);
      }

      /// win logic
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

  String timeFormate(int seconds) {
    int mintunes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String min = mintunes.toString().padLeft(0, '0');
    String sec = remainingSeconds.toString().padLeft(2, '0');

    return "$min: $sec";
  }

  void resetBall(bool fromLeft) {
    ballY = Random().nextDouble() * (boardHeight - 20);

    if (fromLeft) {
      ballX = 5;
      dx = 12;
    } else {
      ballX = boardWidth - 25;
      dx = -12;
    }

    dy = (Random().nextDouble() * 2) - 1;
    // ballX = boardWidth / 2;
    // ballY = boardHeight / 2;

    // dx = Random().nextBool() ? 12 : -12;
    // dy = (Random().nextDouble() * 2) - 1;
  }

  void resetGame() {
    setState(() {
      leftScore = 0;
      rightScore = 0;
      dx = Random().nextBool() ? 15 : 15;
      dy = (Random().nextDouble() * 4) - 2;
      seconds = 0;
      gameOver = false;
      winner = "";

      resetBall(true);
    });
  }

  @override
  void dispose() {
    gameLoop.cancel();
    timer.cancel();
    super.dispose();
  }

  Widget racket(Color color) {
    return Container(
      width: racketWidth,
      height: racketHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 10,
          height: 30,
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    boardWidth = screenWidth * 0.85;
    boardHeight = screenHeight * 0.75;

    return Scaffold(
      backgroundColor: const Color(0xFFE7C44E),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            if (details.localPosition.dx < screenWidth / 2) {
              //leftX += details.delta.dx;
              //leftY += details.delta.dy;

              rightX += details.delta.dx;
              rightY += details.delta.dy;
            } else {
              rightX += details.delta.dx;
              rightY += details.delta.dy;
            }

            // leftX = leftX.clamp(0, boardWidth - racketWidth);
            // leftY = leftY.clamp(0, boardHeight - racketHeight);

            // rightX = rightX.clamp(0, boardWidth - racketWidth);
            // rightY = rightY.clamp(0, boardHeight - racketHeight);
          });
        },
        child: Center(
          child: Container(
            width: boardWidth,
            height: boardHeight,
            decoration: BoxDecoration(
              color: const Color(0xFFF77A57),
              border: Border.all(color: Colors.black, width: 6),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: boardWidth / 2 - 1,
                  top: 0,
                  child: Column(
                    children: List.generate(
                      (boardHeight / 20).floor(),
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        width: 2,
                        height: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
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

                Positioned(left: leftX, top: leftY, child: racket(Colors.blue)),

                Positioned(
                  left: rightX,
                  top: rightY,
                  child: racket(Colors.red),
                ),

                Positioned(
                  top: 20,
                  left: 20,
                  child: Text(
                    "$leftScore",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Text(
                    "$rightScore",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),

                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      timeFormate(seconds),
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                if (gameOver)
                  Center(
                    child: Container(
                      color: Colors.black12,
                      height: 110,
                      width: 150,

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            winner,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: resetGame,
                            child: const Text("Restart"),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
