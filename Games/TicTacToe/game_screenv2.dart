import 'dart:math';
import '../logic/ai_logic.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../models/game_enums.dart';

class GameScreen extends StatefulWidget {
  final Difficulty difficulty;
  final GameMode gameMode;

  const GameScreen({
    super.key,
    required this.difficulty,
    required this.gameMode,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random random = Random();
  late ConfettiController _confettiController;
  List<String> board = List.filled(9, '');
  bool gameOver = false;
  bool computerThinking = false;
  String status = 'Your turn - X';
  String currentPlayer = 'X';

  int playerScore = 0;
  int computerScore = 0;
  int drawScore = 0;
  static const List<List<int>> winningLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  void playerMove(int index) {
    if (gameOver ||
        board[index].isNotEmpty ||
        (widget.gameMode != GameMode.twoPlayer && computerThinking)) {
      return;
    }

    // TWO PLAYER MODE
    if (widget.gameMode == GameMode.twoPlayer) {
      final player = currentPlayer;

      setState(() {
        board[index] = player;
      });

      if (finishGame(player)) {
        return;
      }

      setState(() {
        currentPlayer = player == 'X' ? 'O' : 'X';
        status = 'Player $currentPlayer turn';
      });

      return;
    }

    // AI MODE
    setState(() {
      board[index] = 'X';
    });

    if (finishGame('X')) {
      return;
    }

    setState(() {
      computerThinking = true;
      status = 'Computer is thinking...';
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted || gameOver) {
        return;
      }

      final move = chooseComputerMove();

      if (move == null) {
        return;
      }

      setState(() {
        board[move] = 'O';
        computerThinking = false;
      });

      if (!finishGame('O')) {
        setState(() {
          status = 'Your turn - X';
        });
      }
    });
  }

  int? chooseComputerMove() {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return randomMove(board, random);

      case Difficulty.medium:
        return mediumMove();

      case Difficulty.hard:
        return bestMove();
    }
  }

  int? mediumMove() {
    final computerWinningMove = immediateWinningMove('O');

    if (computerWinningMove != null) {
      return computerWinningMove;
    }

    if (random.nextBool()) {
      final blockingMove = immediateWinningMove('X');

      if (blockingMove != null) {
        return blockingMove;
      }
    }

    if (board[4].isEmpty && random.nextBool()) {
      return 4;
    }

    return randomMove(board, random);
  }

  int? bestMove() {
    int highestScore = -1000;
    int? selectedMove;

    for (final index in emptyPositions(board)) {
      board[index] = 'O';
      final score = minimax(false);
      board[index] = '';

      if (score > highestScore) {
        highestScore = score;
        selectedMove = index;
      }
    }

    return selectedMove;
  }

  int minimax(bool computerTurn) {
    if (hasWinner(board, 'O')) {
      return 10;
    }

    if (hasWinner(board, 'X')) {
      return -10;
    }

    if (emptyPositions(board).isEmpty) {
      return 0;
    }

    if (computerTurn) {
      int highestScore = -1000;

      for (final index in emptyPositions(board)) {
        board[index] = 'O';
        highestScore = max(highestScore, minimax(false));
        board[index] = '';
      }

      return highestScore;
    }

    int lowestScore = 1000;

    for (final index in emptyPositions(board)) {
      board[index] = 'X';
      lowestScore = min(lowestScore, minimax(true));
      board[index] = '';
    }

    return lowestScore;
  }

  int? immediateWinningMove(String player) {
    for (final index in emptyPositions(board)) {
      board[index] = player;
      final wins = hasWinner(board, player);
      board[index] = '';

      if (wins) {
        return index;
      }
    }

    return null;
  }

  bool finishGame(String player) {
    if (hasWinner(board, player)) {
      setState(() {
        gameOver = true;
        computerThinking = false;
        if (player == 'X') {
          playerScore++;

          if (widget.gameMode == GameMode.twoPlayer) {
            status = '🎉 Player X Wins!';
            _confettiController.play();

            Future.delayed(
              const Duration(milliseconds: 300),
              () => showGameOverDialog('🎉 Player X Wins!'),
            );
          } else {
            status = '🎉 You Win!';
            _confettiController.play();

            Future.delayed(
              const Duration(milliseconds: 300),
              () => showGameOverDialog('🎉 You defeated the AI!'),
            );
          }
        } else {
          computerScore++;

          if (widget.gameMode == GameMode.twoPlayer) {
            status = '🎉 Player O Wins!';
            _confettiController.play();

            Future.delayed(
              const Duration(milliseconds: 300),
              () => showGameOverDialog('🎉 Player O Wins!'),
            );
          } else {
            status = '🤖 Computer Wins!';

            Future.delayed(
              const Duration(milliseconds: 300),
              () => showGameOverDialog('🤖 Better luck next time!'),
            );
          }
        }
      });

      return true;
    }

    if (board.every((cell) => cell.isNotEmpty)) {
      setState(() {
        gameOver = true;
        computerThinking = false;
        drawScore++;
        status = '🤝 Draw!';
        Future.delayed(
          const Duration(milliseconds: 300),
          () => showGameOverDialog("🤝 It's a Draw!"),
        );
      });

      return true;
    }

    return false;
  }

  void restartGame() {
    setState(() {
      board = List.filled(9, '');
      gameOver = false;
      computerThinking = false;
      currentPlayer = 'X';

      status = widget.gameMode == GameMode.twoPlayer
          ? 'Player X turn'
          : 'Your turn - X';
    });
  }

  void showGameOverDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Center(
            child: Text(
              "🏆 GAME OVER",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                restartGame();
              },
              child: const Text("Play Again"),
            ),

            if (widget.gameMode != GameMode.twoPlayer)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Difficulty"),
              ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("Home"),
            ),
          ],
        );
      },
    );
  }

  String difficultyName() {
    if (widget.gameMode == GameMode.twoPlayer) {
      return 'Friendly';
    }

    switch (widget.difficulty) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xff101820),
        title: Text(
          "${difficultyName().toUpperCase()} MODE",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff1E293B),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "🏆 SCORE BOARD",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                widget.gameMode == GameMode.twoPlayer
                                    ? '❌ PLAYER X'
                                    : '😊 YOU',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "$playerScore",
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Container(
                            width: 1,
                            height: 55,
                            color: Colors.white24,
                          ),

                          Column(
                            children: [
                              Text(
                                widget.gameMode == GameMode.twoPlayer
                                    ? '⭕ PLAYER O'
                                    : '🤖 AI',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "$computerScore",
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const Divider(height: 15),

                      Text(
                        "🤝 Draws : $drawScore",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => playerMove(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff1E293B),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              board[index],
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: board[index] == 'X'
                                    ? Colors.lightBlueAccent
                                    : Colors.pinkAccent,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: restartGame,
                    child: const Text(
                      'Restart Game',
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
