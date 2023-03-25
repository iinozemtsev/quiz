import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_bloc.dart';
import 'math.dart';
import 'game.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: BlocProvider<GameBloc>(
            create: (_) => GameBloc(game: create(MathGameOptions())),
            child: BlocBuilder<GameBloc, Game>(
              builder: (context, state) {
                if (state.isOver) {
                  return EndScreen(game: state);
                } else {
                  return GameScreen(game: state);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class EndScreen extends StatelessWidget {
  final Game game;

  const EndScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (!game.isOver) {
      throw ArgumentError('Game is not over');
    }
    String winText;
    if (game.score == game.questions.length) {
      winText = 'Чемпион! 🥳';
    } else if (game.score > game.questions.length ~/ 2) {
      winText = 'Молодец! 😃';
    } else if (game.score > 0) {
      winText = 'Можно лучше! 🙁';
    } else {
      winText = '💩';
    }

    return Column(
      children: [
        Text(
          '${game.score}/${game.questions.length}',
          style: const TextStyle(fontSize: 160),
        ),
        Text(winText, style: const TextStyle(fontSize: 120)),
        TextButton(
          onPressed: () => context.read<GameBloc>().add(NewGame()),
          child: const Text('Сыграем ещё?', style: TextStyle(fontSize: 100)),
        )
      ],
    );
  }
}

class GameScreen extends StatelessWidget {
  final Game game;
  const GameScreen({super.key, required this.game});
  @override
  Widget build(BuildContext context) {
    final question = game.questions[game.currentQuestion];
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                question.title,
                style: const TextStyle(fontSize: 190),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < question.answers.length; i++)
                TextButton(
                  onPressed: () => context.read<GameBloc>().add(GameAnswer(i)),
                  child: Text(question.answers[i].title,
                      style: const TextStyle(
                        fontSize: 120,
                      )),
                ),
            ],
          ),
          Text(
            'Счёт: ${game.score}',
            style: const TextStyle(fontSize: 60),
          )
        ],
      ),
    );
  }
}
