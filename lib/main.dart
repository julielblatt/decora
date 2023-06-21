import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(DecoraApp());
}

class DecoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decora Game',
      home: DecoraGame(),
    );
  }
}

class DecoraGame extends StatefulWidget {
  @override
  _DecoraGameState createState() => _DecoraGameState();
}

class _DecoraGameState extends State<DecoraGame> {
  List<Color> buttonColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
  ];
  List<Color> buttonOriginalColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
  ];
  List<int> sequence = [];
  int currentIndex = 0;
  bool canPressButton = false;
  bool gameOver = false;
  bool isGameStarted = false;

  @override
  void initState() {
    super.initState();
  }

  void startGame() {
    gameOver = false;
    sequence.clear();
    currentIndex = 0;
    generateNextSequence();
    playSequence();
  }

  void generateNextSequence() {
    Random random = Random();
    int nextColorIndex = random.nextInt(4);
    sequence.add(nextColorIndex);
  }

  void playSequence() {
    canPressButton = false;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentIndex >= sequence.length) {
        setState(() {
          currentIndex = 0;
          canPressButton = true;
        });
        timer.cancel();
        return;
      }

      int buttonIndex = sequence[currentIndex];
      highlightButton(buttonIndex);

      currentIndex++;
    });
  }

  void highlightButton(int index) {
    Timer(Duration(milliseconds: 500), () {
      if (!gameOver) {
        setState(() {
          buttonColors[index] = getBrighterColor(buttonOriginalColors[index]);
        });
      }
    });

    Timer(Duration(milliseconds: 1000), () {
      if (!gameOver) {
        setState(() {
          buttonColors[index] = buttonOriginalColors[index];
        });
      }
    });
  }

  Color getBrighterColor(Color color) {
    double correctionFactor = 0.6;
    int red = color.red + ((255 - color.red) * correctionFactor).round();
    int green = color.green + ((165 - color.green) * correctionFactor).round();
    int blue = color.blue + ((0 - color.blue) * correctionFactor).round();

    return Color.fromARGB(color.alpha, red, green, blue);
  }

  void handleButtonPress(int index) {
    if (canPressButton) {
      if (index == sequence[currentIndex]) {
        currentIndex++;

        if (currentIndex >= sequence.length) {
          generateNextSequence();
          currentIndex = 0;
          playSequence();
        }
      } else {
        setState(() {
          gameOver = true;
        });
        showGameOverDialog();
      }
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Você errou! Deseja jogar novamente?'),
          actions: [
            TextButton(
              child: Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
            ),
            TextButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decora'),
      ),
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isGameStarted)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isGameStarted = true;
                  });
                  startGame();
                },
                child: Text('Iniciar'),
              ),
            if (isGameStarted) buildGameButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildGameButtons() {
    return Column(
      children: [
        for (int i = 0; i < buttonColors.length; i++)
          Container(
            color: Colors.black,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: buttonColors[i],
                minimumSize: Size(100, 100),
              ),
              onPressed: () {
                handleButtonPress(i);
              },
              child: SizedBox(
                width: 100,
                height: 100,
              ),
            ),
          ),
      ],
    );
  }
}
// fim de papo
