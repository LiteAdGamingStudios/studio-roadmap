import 'game_screen.dart';
import 'package:flutter/material.dart';
import '../models/game_enums.dart';
import '../widgets/difficulty_button.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  void openGame(BuildContext context, Difficulty difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          difficulty: difficulty,
          gameMode: GameMode.ai,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Text(
                  "❌   ⭕",
                  style: TextStyle(fontSize: 60),
                ),

                const SizedBox(height: 20),

                const Text(
                  "TIC TAC TOE",
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Challenge the AI",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 70),

                DifficultyButton(
                  text: "🟢 Easy",
                  onPressed: () => openGame(context, Difficulty.easy),
                ),

                const SizedBox(height: 20),

                DifficultyButton(
                  text: "🟡 Medium",
                  onPressed: () => openGame(context, Difficulty.medium),
                ),

                const SizedBox(height: 20),

                DifficultyButton(
                  text: "🔴 Hard",
                  onPressed: () => openGame(context, Difficulty.hard),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}