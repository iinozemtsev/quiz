import 'package:flutter/material.dart';
import 'package:playground/src/model/game.dart';

class GameResultScreen extends StatelessWidget {
  final Game game;

  const GameResultScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text('Игра окончена!', style: Theme.of(context).textTheme.titleLarge),
        Text('Счёт: ${game.score}/${game.answers}',
            style: Theme.of(context).textTheme.titleMedium),
        Expanded(
            child: Image(
                image: AssetImage(game.score == game.answers
                    ? 'assets/mario.webp'
                    : game.score == 0
                        ? 'assets/bowser.webp'
                        : 'assets/toad.webp'))),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Назад')),
        const SizedBox(height: 50),
      ],
    ))));
  }
}
