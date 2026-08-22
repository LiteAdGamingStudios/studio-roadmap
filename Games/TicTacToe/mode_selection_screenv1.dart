import 'package:flutter/material.dart';
import 'difficulty_screen.dart';
import '../models/game_enums.dart';
import 'game_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  void openDifficulty(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DifficultyScreen(),
      ),
    );
  }
  void openTwoPlayer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          difficulty: Difficulty.easy,
          gameMode: GameMode.twoPlayer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff0F2027),
              Color(0xff203A43),
              Color(0xff2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Text(
                  "❌  ⭕",
                  style: TextStyle(fontSize: 70),
                ),

                const SizedBox(height: 30),

                const Text(
                  "TIC TAC TOE",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: 280,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      openDifficulty(context);
                    },
                    child: const Text(
                      "🤖 Play vs AI",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: 280,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      openTwoPlayer(context);
                    },
                    child: const Text(
                      "👥 Two Player",
                      style: TextStyle(fontSize: 22),
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