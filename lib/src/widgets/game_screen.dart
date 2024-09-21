import 'dart:async';

import 'package:flutter/material.dart';

import '../model/game_settings.dart';
import '../model/game.dart';

class GameScreen extends StatefulWidget {
  final GameSettings settings;

  const GameScreen({super.key, required this.settings});

  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

class _GameState extends State<GameScreen> {
  late Game game;
  late final DateTime startedAt;
  late final Timer timer;
  var timerStarted = false;
  var timeString = '00:00.000';

  @override
  void initState() {
    super.initState();
    game = Game.create(settings: widget.settings);
  }

  @override
  void dispose() {
    super.dispose();
    if (timerStarted) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (game.isOver) {
      throw StateError('this screen is only for pending games');
    }

    if (!timerStarted) {
      setState(() {
        timerStarted = true;
        startedAt = DateTime.now();
      });

      timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
        setState(() {
          final duration = switch (game.settings.limit) {
            MaxQuestions() => DateTime.now().difference(startedAt),
            Timeout(value: final value) =>
              game.started.add(value).difference(DateTime.now()),
          };
          final hours = duration.inHours == 0
              ? ''
              : '${duration.inHours.toString().padLeft(2, '0')}:';
          final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
          final millis = (duration.inMilliseconds % 1000 ~/ 100).toString();
          timeString = '$hours$minutes:$seconds.$millis';
        });
      });
    }
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            'Question #${game.answers + 1}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            timeString,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Expanded(
            child: Center(
              child: Text(
                game.question.text,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final answer in game.question.answers)
                  ElevatedButton(
                      onPressed: () {
                        final updatedGame = game.nextQuestionOrFinish(answer);
                        if (!updatedGame.isOver) {
                          setState(() {
                            game = updatedGame;
                          });
                        } else {
                          Navigator.of(context).pop(updatedGame);
                        }
                      },
                      child: Text(
                        answer,
                        style: Theme.of(context).textTheme.titleLarge,
                      ))
              ],
            ),
          ),
          const SizedBox(height: 50)
        ]),
      ),
    ));
  }
}
