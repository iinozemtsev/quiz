import 'package:flutter/material.dart';
import 'package:playground/src/model/game.dart';
import 'package:playground/src/model/game_settings.dart';
import 'package:playground/src/widgets/game_screen.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  [
                    'Max number: ${settings.maxNumber}',
                    if (settings.limit is MaxQuestions)
                      'Question count: ${(settings.limit as MaxQuestions).value}',
                    if (settings.limit is Timeout)
                      'Лимит времени: ${(settings.limit as Timeout).value.inMinutes}'
                  ].join('\n'),
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
                  child: const Text('Настройки'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final gameResult = await navigator.push<Game>(
                        MaterialPageRoute(
                            builder: (context) =>
                                GameScreen(settings: settings)));
                    if (gameResult != null) {
                      navigator.push<void>(MaterialPageRoute(
                          builder: (context) =>
                              GameResultScreen(game: gameResult)));
                    }
                  },
                  child: const Text('Вперёд!'),
                )
              ]),
        ),
      ),
    );
  }
}

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
