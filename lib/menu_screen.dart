import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playground/src/model/game.dart';
import 'package:playground/src/model/game_settings.dart';
import 'package:playground/src/widgets/settings_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<MenuScreen> {
  bool isOnMenuScreen = true;
  var settings = GameSettings.defaultSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IntrinsicWidth(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Max number: ${settings.maxNumber}\n'
                  'Question count: ${(settings.limit as MaxQuestions).value}',
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final updatedSettings = await Navigator.of(context)
                        .push<GameSettings>(MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                                  initialSettings: settings,
                                )));
                    if (updatedSettings != null) {
                      setState(() {
                        settings = updatedSettings;
                      });
                    }
                  },
                  child: const Text('Change Settings'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // TODO: should game result pushed from the game?
                    final gameResult = await Navigator.of(context)
                        .push<GameResult>(MaterialPageRoute(
                            builder: (context) =>
                                GameScreen(settings: settings)));
                  },
                  child: const Text('Start'),
                )
              ]),
        ),
      ),
    );
  }
}

class GameResult {
  final int score;
  final GameSettings settings;
  const GameResult({required this.score, required this.settings});
}

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
      return Scaffold(
          body: SafeArea(child: Text('Game over! Score: ${game.score}')));
    }

    if (!timerStarted) {
      setState(() {
        timerStarted = true;
        startedAt = DateTime.now();
      });

      timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
        setState(() {
          final elapsed = DateTime.now().difference(startedAt);
          final hours = elapsed.inHours == 0
              ? ''
              : '${elapsed.inHours.toString().padLeft(2, '0')}:';
          final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
          final millis = (elapsed.inMilliseconds % 1000 ~/ 100).toString();
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
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Expanded(
            child: Center(
              child: Text(
                game.question.text,
                style: Theme.of(context).textTheme.bodyLarge,
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
                        setState(() {
                          game = game.nextQuestion(answer);
                          if (game.answers ==
                              (game.settings.limit as MaxQuestions).value) {
                            game = game.finish();
                          }
                        });
                      },
                      child: Text(answer))
              ],
            ),
          ),
          const SizedBox(height: 50)
        ]),
      ),
    ));
  }
}

class Question {
  final String text;
  final List<String> answers;
  final String rightAnswer;

  Question(
      {required this.text, required this.answers, required this.rightAnswer});

  static Question randomQuestion(
      {required GameSettings settings, Random? random}) {
    random ??= Random();
    final (a, b) = (
      random.nextInt(settings.maxNumber + 1),
      random.nextInt(settings.maxNumber + 1)
    );
    final correctAnswer = a * b;
    final answers = <int>{correctAnswer};

    while (answers.length != 3) {
      answers.add(random.nextInt(settings.maxNumber * settings.maxNumber + 1));
    }

    return Question(
        text: '$a x $b = ?',
        answers: (answers.toList()..shuffle(random))
            .map((x) => x.toString())
            .toList(),
        rightAnswer: correctAnswer.toString());
  }
}
