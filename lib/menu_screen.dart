import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

final elevatedButtonStyle =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 35));

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
                  'Question count: ${settings.questionCount}',
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
                  style: elevatedButtonStyle,
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
                  style: elevatedButtonStyle,
                  child: const Text('Start'),
                )
              ]),
        ),
      ),
    );
  }
}

class GameResult {}

class GameSettings {
  final int questionCount;
  final int maxNumber;

  const GameSettings({required this.questionCount, required this.maxNumber});

  static const defaultSettings = GameSettings(questionCount: 10, maxNumber: 10);
}

class SettingsScreen extends StatefulWidget {
  final GameSettings initialSettings;

  const SettingsScreen({
    super.key,
    required this.initialSettings,
  });

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  late GameSettings settings;
  final _countController = TextEditingController();
  final _maxController = TextEditingController();
  _SettingsState();

  @override
  void dispose() {
    _countController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    settings = widget.initialSettings;
    _countController.text = settings.questionCount.toString();
    _maxController.text = settings.maxNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Question Count'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: _countController,
              ),
            ),
            const Text('Max Number'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: _maxController,
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(GameSettings(
                  maxNumber:
                      int.tryParse(_maxController.text) ?? settings.maxNumber,
                  questionCount: int.tryParse(_countController.text) ??
                      settings.questionCount)),
              style: elevatedButtonStyle,
              child: const Text('Back'),
            )
          ],
        ),
      ),
    );
  }
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
  @override
  Widget build(BuildContext context) => Scaffold(body: Text('Unimplemented'));
}
